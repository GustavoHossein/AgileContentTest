//
//  Model.swift
//  Agile Content Test
//
//  Created by Gustavo Hossein on 2/8/25.
//

import Foundation

// MARK: - Repository Model
struct Repo: Codable {
    let name: String
    let language: String?
}

// MARK: - User Profile Template
struct UserProfile: Codable {
    let login: String
    let avatar_url: String
    let repos_url: String
}
