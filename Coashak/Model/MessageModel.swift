
//
//  Models.swift
//  Coashak
//
//  Created by Mohamed Magdy on 17/05/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreCombineSwift

// MARK: - User Model
struct UserForChat: Identifiable, Codable, Equatable {
    var id: String
    var displayName: String?
    var email: String?
    var avatarUrl: URL?
    var role: UserRole?
    
    enum UserRole: String, Codable {
        case trainer
        case trainee
    }
    
    init(id: String, displayName: String? = nil, email: String? = nil, avatarUrl: URL? = nil, role: UserRole? = nil) {
        self.id = id
        self.displayName = displayName
        self.email = email
        self.avatarUrl = avatarUrl
        self.role = role
    }
}

// MARK: - Message Model
struct Message: Codable, Equatable, Identifiable {
    @DocumentID var id: String? // Firestore doc ID might be nil locally
    let text: String
    let senderId: String
    let timestamp: Date
    var readBy: [String]?
    var mediaUrl: URL?
    var mediaType: MediaType?

    var isCurrentUser: Bool = false

    // Computed property to guarantee a non-nil id for SwiftUI
    var nonOptionalId: String {
        id ?? UUID().uuidString
    }

    enum CodingKeys: String, CodingKey {
        case id, text, senderId, timestamp, readBy, mediaUrl, mediaType
    }

    init(id: String? = nil,
         text: String,
         senderId: String,
         timestamp: Date = Date(),
         readBy: [String] = [],
         mediaUrl: URL? = nil,
         mediaType: MediaType? = nil) {
        self.id = id
        self.text = text
        self.senderId = senderId
        self.timestamp = timestamp
        self.readBy = readBy
        self.mediaUrl = mediaUrl
        self.mediaType = mediaType
    }

    enum MediaType: String, Codable {
        case image, video, audio, file
    }
}


// MARK: - Conversation Model
struct Conversation: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    var participantIds: [String]
    var participantNames: [String]
    var lastMessage: Message?
    var unreadMessageCount: Int
    var lastActivity: Date
    var readBy: [String] = []
    
    var isGroupChat: Bool {
        return participantIds.count > 2
    }
    
    // Initializer for local creation
    init(id: String? = nil,
         participantIds: [String],
         participantNames: [String],
         lastMessage: Message? = nil,
         unreadMessageCount: Int = 0,
         lastActivity: Date = Date(),
         readBy: [String] = []) {
        self.id = id
        self.participantIds = participantIds
        self.participantNames = participantNames
        self.lastMessage = lastMessage
        self.unreadMessageCount = unreadMessageCount
        self.lastActivity = lastActivity
        self.readBy = readBy
    }
    
    func displayName(currentUserId: String) -> String {
        // Get names of other participants
        let others = participantNames.enumerated()
            .filter { participantIds[$0.offset] != currentUserId }
            .map { $0.element }
        
        if others.isEmpty {
            return "Just you"
        } else if others.count == 1 {
            return others[0]
        } else if others.count <= 3 {
            return others.joined(separator: ", ")
        } else {
            return "\(others[0]), \(others[1]), and \(others.count - 2) others"
        }
    }
    
    func isRead(by userId: String) -> Bool {
        return readBy.contains(userId)
    }
}

// MARK: - Voice Call Models

enum CallStatus: String, Codable {
    case connecting
    case ringing
    case active
    case ended
    case failed
    case declined
    case missed
}

struct CallParticipant: Identifiable, Equatable {
    let id: String // User ID
    var displayName: String
    var avatarUrl: URL?
    var isMuted: Bool = false
    // Add other relevant participant states
}

struct CallSession: Identifiable {
    let id: UUID
    var participants: [CallParticipant]
    var status: CallStatus
    var startTime: Date?
    var endTime: Date?
    var isVideoCall: Bool // Differentiate between voice and video if needed in future
    var isCaller: Bool // True if the current user initiated the call

    // Example initializer
    init(id: UUID = UUID(), participants: [CallParticipant], status: CallStatus, startTime: Date? = nil, endTime: Date? = nil, isVideoCall: Bool = false, isCaller: Bool) {
        self.id = id
        self.participants = participants
        self.status = status
        self.startTime = startTime
        self.endTime = endTime
        self.isVideoCall = isVideoCall
        self.isCaller = isCaller
    }
}
