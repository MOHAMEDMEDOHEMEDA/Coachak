//
//  UserModel.swift
//  Coashak
//
//  Created by Mohamed Magdy on 16/12/2024.
//

import Foundation

struct User: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    let dateOfBirth: String
    let phoneNumber: String
    let isVerified: Bool
    let pendingPasswordChange: Bool
    let profilePhoto: String
    let role: String
    let createdAt: String
    let updatedAt: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstName, lastName, email, password, dateOfBirth, phoneNumber, isVerified, pendingPasswordChange, profilePhoto, role, createdAt, updatedAt
        case v = "__v"
    }
}
