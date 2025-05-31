//
//  CoashakChatViews.swift
//  Coashak
//
//  Created by Mohamed Magdy on 17/05/2025.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreCombineSwift

// Filter options for conversations
enum FilterOption: String, CaseIterable {
    case all = "All"
    case unread = "Unread"
    case recent = "Recent"
}

// MARK: - Chat Bubble View
struct ChatBubbleView: View {
    let message: Message
    let currentUserId: String

    var body: some View {
        HStack {
            if message.senderId == currentUserId {
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text(message.text)
                        .padding(12)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .clipShape(RoundedCorner(radius: 16, corners: [.topLeft, .bottomLeft, .bottomRight]))
                    Text(message.timestamp, style: .time)
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                .padding(.leading, 40)
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    Text(message.text)
                        .padding(12)
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.primary)
                        .clipShape(RoundedCorner(radius: 16, corners: [.topRight, .bottomLeft, .bottomRight]))
                    Text(message.timestamp, style: .time)
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 40)
                Spacer()
            }
        }
        .id(message.nonOptionalId) // Use nonOptionalId here
    }
}


// MARK: - Message List View
struct MessageListView: View {
    let messages: [Message]
    let currentUserId: String

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(messages, id: \.nonOptionalId) { message in
                        ChatBubbleView(message: message, currentUserId: currentUserId)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            .onChange(of: messages.count) { _ in
                if let lastMessage = messages.last {
                    withAnimation {
                        proxy.scrollTo(lastMessage.nonOptionalId, anchor: .bottom)
                    }
                }
            }
            .onAppear {
                if let lastMessage = messages.last {
                    proxy.scrollTo(lastMessage.nonOptionalId, anchor: .bottom)
                }
            }
        }
    }
}


// MARK: - Attachment Types
enum AttachmentType: Identifiable {
    case photoLibrary
    case camera
    case file

    var id: Int { hashValue }
}

// MARK: - ChatInputView
struct ChatInputView: View {
    @Binding var text: String
    let onSend: () -> Void
    let onAttachment: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onAttachment) {
                Image(systemName: "paperclip")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
            }
            .padding(.leading, 4)

            TextField("Enter message...", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color.gray.opacity(0.1))
                .clipShape(Capsule())

            Button(action: onSend) {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 20))
                    .padding(8)
                    .background(Color.accentColor.opacity(text.isEmpty ? 0.5 : 1.0))
                    .foregroundColor(.white)
                    .clipShape(Circle())
            }
            .disabled(text.isEmpty)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(.thinMaterial)
    }
}

// MARK: - AttachmentOptionsView
struct AttachmentOptionsView: View {
    let onSelectImage: () -> Void
    let onSelectCamera: () -> Void
    let onSelectFile: () -> Void

    var body: some View {
        HStack(spacing: 20) {
            Button(action: onSelectImage) {
                VStack {
                    Image(systemName: "photo")
                        .font(.system(size: 24))
                    Text("Gallery")
                        .font(.caption)
                }
            }

            Button(action: onSelectCamera) {
                VStack {
                    Image(systemName: "camera")
                        .font(.system(size: 24))
                    Text("Camera")
                        .font(.caption)
                }
            }

            Button(action: onSelectFile) {
                VStack {
                    Image(systemName: "doc")
                        .font(.system(size: 24))
                    Text("File")
                        .font(.caption)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
    }
}



// MARK: - Conversation Row View
struct ConversationRowView: View {
    let conversation: Conversation
    let currentUserId: String
    
    var formattedTime: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        
        let timeAgo = formatter.localizedString(for: conversation.lastActivity, relativeTo: Date())
        
        // For today, just show the time
        if Calendar.current.isDateInToday(conversation.lastActivity) {
            let timeFormatter = DateFormatter()
            timeFormatter.timeStyle = .short
            return timeFormatter.string(from: conversation.lastActivity)
        }
        
        return timeAgo
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 50, height: 50)
                
                if conversation.isGroupChat {
                    Image(systemName: "person.3.fill")
                        .foregroundColor(.gray)
                } else {
                    Text(getInitials(from: conversation.displayName(currentUserId: currentUserId)))
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.gray)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(conversation.displayName(currentUserId: currentUserId))
                    .font(.headline)
                    .lineLimit(1)
                    .foregroundColor(conversation.unreadMessageCount > 0 ? .primary : .gray)
                
                Text(conversation.lastMessage?.text ?? "No messages yet")
                    .font(.subheadline)
                    .foregroundColor(conversation.unreadMessageCount > 0 ? .primary : .gray)
                    .lineLimit(1)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(formattedTime)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                if conversation.unreadMessageCount > 0 {
                    Text("\(conversation.unreadMessageCount)")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(6)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    private func getInitials(from name: String) -> String {
        let components = name.components(separatedBy: " ")
        if components.count > 1, let first = components.first?.first, let last = components.last?.first {
            return String(first) + String(last)
        } else if let first = components.first?.first {
            return String(first)
        } else {
            return "?"
        }
    }
}

// MARK: - Selected User Bubble
struct SelectedUserBubble: View {
    let user: UserForChat
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            if let displayName = user.displayName {
                Text(displayName)
                    .font(.subheadline)
            } else if let email = user.email {
                Text(email)
                    .font(.subheadline)
            }
            
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.gray.opacity(0.2))
        .clipShape(Capsule())
    }
}

// MARK: - User Row
struct UserRow: View {
    let user: UserForChat
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        HStack {
            // Avatar
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 40)
                
                if let _ = user.avatarUrl {
                    // In a real app, load the image from URL
                    // AsyncImage(url: user.avatarUrl) { ... }
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                } else {
                    Text(initials)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.gray)
                }
            }
            
            // User info
            VStack(alignment: .leading, spacing: 2) {
                Text(user.displayName ?? "Unknown User")
                    .font(.headline)
                
                if let email = user.email {
                    Text(email)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                if let role = user.role {
                    Text(role.rawValue.capitalized)
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            
            Spacer()
            
            // Selection indicator
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isSelected ? .accentColor : .gray)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onSelect()
        }
    }
    
    private var initials: String {
        guard let name = user.displayName, !name.isEmpty else {
            return "?"
        }
        
        let components = name.components(separatedBy: " ")
        if components.count > 1, let first = components.first?.first, let last = components.last?.first {
            return String(first) + String(last)
        } else if let first = components.first?.first {
            return String(first)
        } else {
            return "?"
        }
    }
}

// MARK: - Chat Detail View
struct ChatDetailView: View {
    let conversationId: String
    let conversationDisplayName: String
    let currentUserId: String
    
    @StateObject private var chatService = ChatService()
    @State private var messages: [Message] = []
    @State private var inputText: String = ""
    @State private var isTyping = false
    @State private var typingUsers: [String] = []
    @State private var showAttachmentOptions = false
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var showActionSheet = false
    
    // Timer for typing indicator
    @State private var typingTimer: Timer?
    
    var body: some View {
        VStack(spacing: 0) {
            // Messages list
            MessageListView(messages: messages, currentUserId: currentUserId)
            
            // Typing indicator
            if !typingUsers.isEmpty {
                HStack {
                    Text("\(typingUsersText) typing...")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 4)
            }
            
            // Input area
            VStack(spacing: 0) {
                if showAttachmentOptions {
                    AttachmentOptionsView(onSelectImage: {
                        showImagePicker = true
                    }, onSelectCamera: {
                        // Handle camera access
                    }, onSelectFile: {
                        // Handle file selection
                    })
                }
                
                ChatInputView(text: $inputText, onSend: sendMessage, onAttachment: {
                    showAttachmentOptions.toggle()
                })
                .onChange(of: inputText) { newValue in
                    handleTypingIndicator(isTyping: !newValue.isEmpty)
                }
            }
        }
        .navigationTitle(conversationDisplayName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showActionSheet = true
                }) {
                    Image(systemName: "ellipsis")
                }
            }
        }
        .onAppear {
            loadMessages()
            chatService.markConversationAsRead(conversationId: conversationId, userId: currentUserId)
            chatService.listenForTypingIndicators(conversationId: conversationId) { userIds in
                // Filter out current user
                self.typingUsers = userIds.filter { $0 != currentUserId }
            }
        }
        .onDisappear {
            // Clear typing indicator when leaving
            handleTypingIndicator(isTyping: false)
            typingTimer?.invalidate()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage, onImageSelected: { image in
                // Handle selected image
                sendImageMessage(image)
            })
        }
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(title: Text("Conversation Options"), buttons: [
                .default(Text("Search Messages")) {
                    // Handle search
                },
                .default(Text("View Media")) {
                    // Handle media view
                },
                .destructive(Text("Delete Conversation")) {
                    deleteConversation()
                },
                .cancel()
            ])
        }
    }
    
    private var typingUsersText: String {
        // Format typing users text
        if typingUsers.count == 1 {
            return "Someone is"
        } else if typingUsers.count > 1 {
            return "\(typingUsers.count) people are"
        }
        return ""
    }
    
    private func loadMessages() {
        chatService.fetchMessages(forConversationId: conversationId) { fetchedMessages in
            var updatedMessages = fetchedMessages
            
            // Mark messages as from current user
            for i in 0..<updatedMessages.count {
                if updatedMessages[i].senderId == currentUserId {
                    updatedMessages[i].isCurrentUser = true
                }
                
                // Mark messages as read if they're not from current user
                if updatedMessages[i].senderId != currentUserId && !(updatedMessages[i].readBy?.contains(currentUserId) ?? false) {
                    chatService.markMessageAsRead(conversationId: conversationId, messageId: updatedMessages[i].id ?? "", userId: currentUserId)
                }

            }
            
            self.messages = updatedMessages
        }
    }
    
    private func sendMessage() {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        let newMessage = Message(
            text: trimmed,
            senderId: currentUserId,
            timestamp: Date(),
            readBy: [currentUserId] // Mark as read by sender
        )
        
        chatService.sendMessage(newMessage, toConversationId: conversationId)
        inputText = ""
        
        // Add optimistically to UI
        var optimisticMessage = newMessage
        optimisticMessage.isCurrentUser = true
        messages.append(optimisticMessage)
        
        // Stop typing indicator
        handleTypingIndicator(isTyping: false)
    }
    
    private func sendImageMessage(_ image: UIImage) {
        // In a real app, you would upload the image to storage
        // and then create a message with the image URL
        
        // For now, we'll just create a text message indicating an image was sent
        let newMessage = Message(
            text: "[Image]",
            senderId: currentUserId,
            timestamp: Date(),
            readBy: [currentUserId]
        )
        
        chatService.sendMessage(newMessage, toConversationId: conversationId)
        
        // Add optimistically to UI
        var optimisticMessage = newMessage
        optimisticMessage.isCurrentUser = true
        messages.append(optimisticMessage)
    }
    
    private func handleTypingIndicator(isTyping: Bool) {
        // Update typing status in Firestore
        chatService.updateTypingStatus(conversationId: conversationId, userId: currentUserId, isTyping: isTyping)
        
        // Reset typing timer
        typingTimer?.invalidate()
        
        // If typing, set a timer to clear the indicator after 5 seconds of inactivity
        if isTyping {
            typingTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { _ in
                chatService.updateTypingStatus(conversationId: conversationId, userId: currentUserId, isTyping: false)
            }
        }
    }
    
    private func deleteConversation() {
        chatService.deleteConversation(conversationId: conversationId, userId: currentUserId) { success in
            if success {
                // Navigate back to conversation list
            }
        }
    }
}

// MARK: - Conversation List View
struct ConversationListView: View {
    @StateObject private var chatService = ChatService()
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showingFilter = false
    @State private var filterOption: FilterOption = .all
    @State private var searchText = ""
    @State private var isSearching = false
    
    var currentUserId: String {
        authViewModel.user?.id ?? ""
    }
    
    var filteredConversations: [Conversation] {
        var result = chatService.conversations
        
        // Apply search filter if needed
        if !searchText.isEmpty {
            result = result.filter { conversation in
                let nameMatch = conversation.displayName(currentUserId: currentUserId)
                    .lowercased()
                    .contains(searchText.lowercased())
                
                let messageMatch = conversation.lastMessage?.text
                    .lowercased()
                    .contains(searchText.lowercased()) ?? false
                
                return nameMatch || messageMatch
            }
        }
        
        // Apply conversation filter
        switch filterOption {
        case .all:
            return result
        case .unread:
            return result.filter { $0.unreadMessageCount > 0 }
        case .recent:
            // Last 24 hours
            let dayAgo = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
            return result.filter { $0.lastActivity > dayAgo }
        }
    }
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 0) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search conversations...", text: $searchText)
                        .autocapitalization(.none)
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                
                // Filter tabs
                HStack(spacing: 0) {
                    ForEach(FilterOption.allCases, id: \.self) { option in
                        Button(action: {
                            filterOption = option
                        }) {
                            Text(option.rawValue)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(filterOption == option ? Color.accentColor : Color.clear)
                                .foregroundColor(filterOption == option ? .white : .primary)
                                .cornerRadius(16)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal, 4)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                // Conversation list
                if filteredConversations.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "bubble.left.and.bubble.right")
                            .font(.system(size: 64))
                            .foregroundColor(.gray.opacity(0.5))
                        
                        Text(searchText.isEmpty ? "No conversations yet" : "No matching conversations")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        if searchText.isEmpty {
                            NavigationLink(destination: NewConversationView()) {
                                Text("Start a conversation")
                                    .fontWeight(.semibold)
                                    .padding()
                                    .background(Color.accentColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(filteredConversations) { conversation in
                            NavigationLink(
                                destination: ChatDetailView(
                                    conversationId: conversation.id ?? "",
                                    conversationDisplayName: conversation.displayName(currentUserId: currentUserId),
                                    currentUserId: currentUserId
                                )
                            ) {
                                ConversationRowView(conversation: conversation, currentUserId: currentUserId)
                            }
                            .swipeActions(edge: .leading) {
                                Button {
                                    markAsRead(conversation)
                                } label: {
                                    Label(conversation.unreadMessageCount > 0 ? "Read" : "Unread",
                                          systemImage: conversation.unreadMessageCount > 0 ? "envelope.open" : "envelope.badge")
                                }
                                .tint(.blue)
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    deleteConversation(conversation)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                
                                Button {
                                    archiveConversation(conversation)
                                } label: {
                                    Label("Archive", systemImage: "archivebox")
                                }
                                .tint(.orange)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Chats")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: NewConversationView()) {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
            .onAppear {
                if !currentUserId.isEmpty {
                    chatService.listenToConversations(forUserId: currentUserId)
                }
            }
            .onDisappear {
                chatService.stopListening()
            }
            .onChange(of: currentUserId) { newValue in
                if !newValue.isEmpty {
                    chatService.fetchConversations(forUserId: newValue)
                }
            }
        }
    }
    
    private func markAsRead(_ conversation: Conversation) {
        if conversation.unreadMessageCount > 0 {
            chatService.markConversationAsRead(conversationId: conversation.id ?? "", userId: currentUserId)
        } else {
            // Toggle to unread would go here if implemented
        }
    }
    
    private func archiveConversation(_ conversation: Conversation) {
        chatService.archiveConversation(conversationId: conversation.id ?? "", userId: currentUserId, archived: true)
    }
    
    private func deleteConversation(_ conversation: Conversation) {
        chatService.deleteConversation(conversationId: conversation.id ?? "", userId: currentUserId) { _ in
            // Refresh happens automatically via listener
        }
    }
}

// MARK: - New Conversation View
struct NewConversationView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var chatService = ChatService()
    
    @State private var searchText = ""
    @State private var selectedUsers: [UserForChat] = []
    @State private var searchResults: [UserForChat] = []
    @State private var isSearching = false
    @State private var isCreating = false
    @State private var newConversationId: String?
    @State private var errorMessage: String?
    
    // Current user
    private var currentUser: UserForChat? {
        if let user = authViewModel.user {
            return UserForChat(id: user.id, displayName: user.displayName, email: user.email)
        }
        return nil
    }
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 0) {
                // Selected users section
                if !selectedUsers.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(selectedUsers) { user in
                                SelectedUserBubble(user: user) {
                                    removeUser(user)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    }
                    .background(Color.gray.opacity(0.1))
                }
                
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search users...", text: $searchText)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .onChange(of: searchText) { _ in
                            if !searchText.isEmpty {
                                searchUsers()
                            } else {
                                searchResults = []
                            }
                        }
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                            searchResults = []
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                
                // Search results or instructions
                if isSearching {
                    ProgressView()
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if searchResults.isEmpty && !searchText.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "person.slash")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        Text("No users found")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if searchResults.isEmpty && searchText.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "person.3")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        Text("Search for users to start a conversation")
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(searchResults) { user in
                            UserRow(user: user, isSelected: selectedUsers.contains(where: { $0.id == user.id })) {
                                toggleUserSelection(user)
                            }
                        }
                    }
                }
                
                // Error message
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                // Create button
                Button(action: createConversation) {
                    HStack {
                        Spacer()
                        if isCreating {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Create Conversation")
                                .fontWeight(.semibold)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(selectedUsers.isEmpty ? Color.gray : Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
                }
                .disabled(selectedUsers.isEmpty || isCreating)
            }
            .navigationTitle("New Conversation")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .alert("Conversation Created", isPresented: Binding(
                get: { newConversationId != nil },
                set: { if !$0 { newConversationId = nil } }
            )) {
                Button("Open") {
                    // Handle navigation to the new conversation
                    dismiss()
                }
            }
        }
    }
    
    private func searchUsers() {
        guard !searchText.isEmpty else { return }
        isSearching = true
        
        // Simulate search delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // In a real app, this would be a Firestore query
            // For now, we'll simulate some results
            let mockUsers = [
                UserForChat(id: "user1", displayName: "John Trainer", email: "john@example.com", role: .trainer),
                UserForChat(id: "user2", displayName: "Sarah Client", email: "sarah@example.com", role: .trainee),
                UserForChat(id: "user3", displayName: "Mike Fitness", email: "mike@example.com", role: .trainer),
                UserForChat(id: "user4", displayName: "Lisa Health", email: "lisa@example.com", role: .trainee)
            ]
            
            searchResults = mockUsers.filter { user in
                let nameMatch = user.displayName?.lowercased().contains(searchText.lowercased()) ?? false
                let emailMatch = user.email?.lowercased().contains(searchText.lowercased()) ?? false
                return nameMatch || emailMatch
            }
            
            // Remove current user from results
            if let currentUserId = currentUser?.id {
                searchResults = searchResults.filter { $0.id != currentUserId }
            }
            
            isSearching = false
        }
    }
    
    private func toggleUserSelection(_ user: UserForChat) {
        if let index = selectedUsers.firstIndex(where: { $0.id == user.id }) {
            selectedUsers.remove(at: index)
        } else {
            selectedUsers.append(user)
        }
    }
    
    private func removeUser(_ user: UserForChat) {
        if let index = selectedUsers.firstIndex(where: { $0.id == user.id }) {
            selectedUsers.remove(at: index)
        }
    }
    
    private func createConversation() {
        guard !selectedUsers.isEmpty, let currentUser = currentUser else {
            errorMessage = "Please select at least one user"
            return
        }
        
        isCreating = true
        errorMessage = nil
        
        // Include current user in participants
        let allParticipants = selectedUsers + [currentUser]
        
        chatService.createConversation(participants: allParticipants) { docId in
            DispatchQueue.main.async {
                isCreating = false
                if let id = docId {
                    newConversationId = id
                } else {
                    errorMessage = "Failed to create conversation. Please try again."
                }
            }
        }
    }
}

// MARK: - Chat Coordinator
class ChatCoordinator: ObservableObject {
    @Published var activeChatId: String?
    @Published var isShowingChatList = false
    
    func showConversationList() {
        isShowingChatList = true
    }
    
    func openChat(conversationId: String) {
        activeChatId = conversationId
    }
}
