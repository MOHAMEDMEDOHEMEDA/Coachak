//
//  CertificateModel.swift
//  Coashak
//
//  Created by Mohamed Magdy on 09/06/2025.
//



import Foundation

struct CertificateModel: Identifiable, Codable {
    var id: String?  // Make optional since it's generated server-side
    let name: String
    let issuingOrganization: String
    
    // Add coding keys to match API expectations
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case issuingOrganization = "issuingRegulation"  // Match API's expected field name
    }
    
    // For creating new certificates (without ID)
    init(name: String, issuingOrganization: String) {
        self.name = name
        self.issuingOrganization = issuingOrganization
    }
}

struct CertificateAddingResponse: Codable{
    let message: String
    let certificate: Certificate

    enum CodingKeys: String, CodingKey {
        case message = "messsage" // handle typo from API
        case certificate
    }
}
// MARK: - Certificate Response
struct CertificateResponse: Codable {
    let message: String
    let certificates: [Certificate]

    enum CodingKeys: String, CodingKey {
        case message = "messsage" // handle typo from API
        case certificates
    }
}

// MARK: - Certificate
struct Certificate: Codable, Identifiable {
    let id: String
    let credintialId: String
    let name: String
    let issuingOrganization: String
    let createdAt: String
    let updatedAt: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case credintialId
        case name
        case issuingOrganization
        case createdAt
        case updatedAt
        case v = "__v"
    }
}
