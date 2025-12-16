//
//  User.swift
//  FriendFace
//
//  Created by Shivansh omer on 30/04/25.
//

import Foundation

struct Friend: Codable, Identifiable {
    let id: String
    let name: String
}

struct User: Codable, Identifiable {
    let id: String
    let isActive: Bool
    let name: String
    let age: Int
    let company: String
    let email: String
    let address: String
    let about: String
    let registered: Date
    let tags: [String]
    let friends: [Friend]
}
