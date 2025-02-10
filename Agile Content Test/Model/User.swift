//
//  User.swift
//  Agile Content Test
//
//  Created by Gustavo Hossein on 2/10/25.
//

import Foundation

// MARK: - User Model
struct User: Decodable {
    // MARK: - Properties
    let login: String
    let avatarUrl: String
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
    }
}
