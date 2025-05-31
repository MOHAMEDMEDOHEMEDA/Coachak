//
//  User.swift
//  Coashak
//
//  Created by Mohamed Magdy on 17/05/2025.
//

import Foundation
import FirebaseFirestoreCombineSwift

// Unified User Model that combines UserForChat and UserModel
struct User: Identifiable, Codable, Equatable {
    @DocumentID var id: String?  // Firebase user uid
    var displayName: String?
    var email: String?
    var avatarUrl: URL?
    
    // Additional fields from UserModel (add as needed)
    var phoneNumber: String?
    var role: UserRole?
    var createdAt: Date?
    var lastActive: Date?
    
    init(id: String? = nil, 
         displayName: String? = nil, 
         email: String? = nil, 
         avatarUrl: URL? = nil,
         phoneNumber: String? = nil,
         role: UserRole? = nil,
         createdAt: Date? = Date(),
         lastActive: Date? = Date()) {
        self.id = id
        self.displayName = displayName
        self.email = email
        self.avatarUrl = avatarUrl
        self.phoneNumber = phoneNumber
        self.role = role
        self.createdAt = createdAt
        self.lastActive = lastActive
    }
}

// User role enum
enum UserRole: String, Codable {
    case trainee
    case trainer
    case admin
}

// Chat-specific extension
extension User {
    // Convert from legacy UserForChat
    static func fromUserForChat(_ userForChat: UserForChat) -> User {
        return User(
            id: userForChat.id,
            displayName: userForChat.displayName,
            email: userForChat.email,
            avatarUrl: userForChat.avatarUrl
        )
    }
    
    // Helper for chat display name
    var chatDisplayName: String {
        return displayName ?? email ?? "Unknown User"
    }
}
