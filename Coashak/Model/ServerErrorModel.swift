//
//  ServerErrorModel.swift
//  Coashak
//
//  Created by Mohamed Magdy on 16/01/2025.
//

import Foundation

struct ServerErrorResponse: Decodable {
    let detail: String?
    let errors: [String: [String]]?
}
