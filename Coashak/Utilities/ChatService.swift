//
//  ChatService.swift
//  Coashak
//
//  Created by Mohamed Magdy on 17/05/2025.
//

import FirebaseFirestore
import FirebaseFirestoreCombineSwift
import Combine

class ChatService: ObservableObject {
    private let db = Firestore.firestore()
    
    @Published var conversations: [Conversation] = []
    
    private var conversationListener: ListenerRegistration?
    private var messageListener: ListenerRegistration?
    private var typingListeners: [String: ListenerRegistration] = [:]
    
    // MARK: - fetch all users
    func fetchAllUsers(completion: @escaping ([UserForChat]) -> Void) {
        db.collection("users").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching users: \(error)")
                completion([])
                return
            }
            let users = snapshot?.documents.compactMap { doc -> UserForChat? in
                try? doc.data(as: UserForChat.self)
            } ?? []
            DispatchQueue.main.async {
                completion(users)
            }
        }
    }
    // MARK: - get or create conversation
    func getOrCreateConversation(
        participants: [UserForChat],
        completion: @escaping (String?) -> Void
    ) {
        let participantIds = participants.compactMap { $0.id }.sorted() // sort for consistent matching

        // Query to find if a conversation already exists with exact participants
        db.collection("conversations")
            .whereField("participantIds", arrayContainsAny: participantIds)
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    print("Error querying conversations: \(error)")
                    completion(nil)
                    return
                }

                // Try to find a conversation that exactly matches participantIds (same count and content)
                if let docs = snapshot?.documents {
                    for doc in docs {
                        if let conversation = try? doc.data(as: Conversation.self) {
                            let existingIds = conversation.participantIds.sorted()
                            if existingIds == participantIds {
                                // Found existing conversation
                                completion(doc.documentID)
                                return
                            }
                        }
                    }
                }

                // No existing conversation found, create new
                self?.createConversation(participants: participants) { newConversationId in
                    completion(newConversationId)
                }
            }
    }


    // MARK: - Listen to Conversations (Real-time)
    func listenToConversations(forUserId userId: String) {
        conversationListener?.remove()
        
        let query = db.collection("conversations")
            .whereField("participantIds", arrayContains: userId)
            .order(by: "lastActivity", descending: true)
        
        conversationListener = query.addSnapshotListener { [weak self] snapshot, error in
            if let error = error {
                print("Error fetching conversations: \(error)")
                return
            }
            guard let snapshot = snapshot else {
                print("No snapshot found for conversations")
                return
            }
            print("Conversations snapshot count: \(snapshot.documents.count)")
            snapshot.documents.forEach { doc in
                print("Conversation doc id: \(doc.documentID), data: \(doc.data())")
            }
            
            DispatchQueue.main.async {
                self?.conversations = snapshot.documents.compactMap { doc in
                    do {
                        return try doc.data(as: Conversation.self)
                    } catch {
                        print("Error decoding conversation: \(error)")
                        return nil
                    }
                }
            }
        }
    }

    func stopListening() {
            conversationListener?.remove()
        }
    
    // MARK: - Fetch Conversations (One-time)
    func fetchConversations(forUserId userId: String, completion: @escaping ([Conversation]) -> Void = { _ in }) {
        db.collection("conversations")
            .whereField("participantIds", arrayContains: userId)
            .order(by: "lastActivity", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching conversations: \(error)")
                    completion([])
                    return
                }
                let conversations = snapshot?.documents.compactMap { doc in
                    try? doc.data(as: Conversation.self)
                } ?? []
                DispatchQueue.main.async {
                    self.conversations = conversations
                    completion(conversations)
                }
            }
    }
    
    // MARK: - Listen to Messages (Real-time)
    func listenToMessages(inConversationId conversationId: String, onUpdate: @escaping ([Message]) -> Void) {
        messageListener?.remove()
        
        messageListener = db.collection("conversations").document(conversationId)
            .collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error listening to messages: \(error)")
                    onUpdate([])
                    return
                }
                let messages = snapshot?.documents.compactMap { doc in
                    try? doc.data(as: Message.self)
                } ?? []
                DispatchQueue.main.async {
                    onUpdate(messages)
                }
            }
    }
    
    // MARK: - Fetch Messages (One-time)
    func fetchMessages(forConversationId conversationId: String, completion: @escaping ([Message]) -> Void) {
        db.collection("conversations").document(conversationId)
            .collection("messages")
            .order(by: "timestamp", descending: false)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching messages: \(error)")
                    completion([])
                    return
                }
                let messages = snapshot?.documents.compactMap { doc in
                    try? doc.data(as: Message.self)
                } ?? []
                DispatchQueue.main.async {
                    completion(messages)
                }
            }
    }
    
    // MARK: - Send a Message
    func sendMessage(_ message: Message, toConversationId conversationId: String) {
        do {
            try db.collection("conversations").document(conversationId)
                .collection("messages").addDocument(from: message) { [weak self] error in
                    if let error = error {
                        print("Error adding message: \(error)")
                        return
                    }
                    // Update conversation lastMessage and lastActivity
                    self?.db.collection("conversations").document(conversationId).updateData([
                        "lastMessage": [
                            "text": message.text,
                            "senderId": message.senderId,
                            "timestamp": Timestamp(date: message.timestamp)
                        ],
                        "lastActivity": Timestamp(date: message.timestamp),
                        // Increment unreadMessageCount or handle per your app logic
                        "unreadMessageCount": FieldValue.increment(Int64(1))
                    ]) { error in
                        if let error = error {
                            print("Error updating conversation: \(error)")
                        }
                    }
                }
        } catch {
            print("Error serializing message for Firestore: \(error)")
        }
    }
    
    // MARK: - Create a New Conversation
    func createConversation(
        participants: [UserForChat],
        completion: @escaping (String?) -> Void
    ) {
        let participantIds = participants.compactMap { $0.id }
        let participantNames = participants.compactMap { $0.displayName ?? $0.email }
        
        let conversation = Conversation(
            participantIds: participantIds,
            participantNames: participantNames,
            lastMessage: nil,
            unreadMessageCount: 0,
            lastActivity: Date()
        )
        
        do {
            let ref = db.collection("conversations").document()
            try ref.setData(from: conversation) { error in
                if let error = error {
                    print("Error creating conversation: \(error)")
                    completion(nil)
                } else {
                    completion(ref.documentID)
                }
            }
        } catch {
            print("Error serializing conversation for Firestore: \(error)")
            completion(nil)
        }
    }
    
    // MARK: - Mark Conversation as Read
    func markConversationAsRead(conversationId: String, userId: String) {
        db.collection("conversations").document(conversationId)
            .updateData([
                "unreadMessageCount": 0,
                "readBy": FieldValue.arrayUnion([userId])
            ]) { error in
                if let error = error {
                    print("Error marking conversation as read: \(error)")
                }
            }
    }
    
    // MARK: - Mark Message as Read
    func markMessageAsRead(conversationId: String, messageId: String, userId: String) {
        db.collection("conversations").document(conversationId)
            .collection("messages").document(messageId)
            .updateData([
                "readBy": FieldValue.arrayUnion([userId])
            ]) { error in
                if let error = error {
                    print("Error marking message as read: \(error)")
                }
            }
    }
    
    // MARK: - Update Typing Status
    func updateTypingStatus(conversationId: String, userId: String, isTyping: Bool) {
        let typingRef = db.collection("conversations").document(conversationId)
            .collection("typing").document(userId)
        
        if isTyping {
            typingRef.setData([
                "userId": userId,
                "timestamp": FieldValue.serverTimestamp()
            ]) { error in
                if let error = error {
                    print("Error updating typing status: \(error)")
                }
            }
        } else {
            typingRef.delete { error in
                if let error = error {
                    print("Error clearing typing status: \(error)")
                }
            }
        }
    }
    
    // MARK: - Listen for Typing Indicators
    func listenForTypingIndicators(conversationId: String, completion: @escaping ([String]) -> Void) {
        let typingRef = db.collection("conversations").document(conversationId)
            .collection("typing")
        
        let listener = typingRef.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error listening for typing indicators: \(error)")
                completion([])
                return
            }
            
            let typingUserIds = snapshot?.documents.compactMap { doc -> String? in
                return doc.documentID
            } ?? []
            
            completion(typingUserIds)
        }
        
        typingListeners[conversationId] = listener
    }
    
    // MARK: - Archive Conversation
    func archiveConversation(conversationId: String, userId: String, archived: Bool) {
        db.collection("users").document(userId)
            .collection("archivedConversations").document(conversationId)
            .setData([
                "archived": archived,
                "timestamp": FieldValue.serverTimestamp()
            ]) { error in
                if let error = error {
                    print("Error \(archived ? "archiving" : "unarchiving") conversation: \(error)")
                }
            }
    }
    
    // MARK: - Delete Conversation
    func deleteConversation(conversationId: String, userId: String, completion: @escaping (Bool) -> Void) {
        db.collection("users").document(userId)
            .collection("deletedConversations").document(conversationId)
            .setData([
                "deleted": true,
                "timestamp": FieldValue.serverTimestamp()
            ]) { error in
                if let error = error {
                    print("Error deleting conversation: \(error)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
    }
    
    deinit {
        conversationListener?.remove()
        messageListener?.remove()
        typingListeners.values.forEach { $0.remove() }
    }
}
