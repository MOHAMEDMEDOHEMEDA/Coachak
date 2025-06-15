//
//  TrainerCertificate.swift
//  Coashak
//
//  Created by Mohamed Magdy on 14/06/2025.
//


import Foundation

struct TrainerCertificate: Codable, Identifiable {
    let id: String
    let credintialId: String
    let name: String
    let imageURL: String?  // Optional now
    let url: String?       // Optional now
    let issuingOrganization: String
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case credintialId
        case name
        case imageURL
        case url
        case issuingOrganization
        case createdAt
        case updatedAt
    }
}

struct TrainerCertificateResponse: Codable {
    let messsage: String
    let certificate: [TrainerCertificate]
}
