//
//  User.swift
//  Nutrify
//
//  Created by Jackie Lin on 11/27/24.
//

import Foundation
import FirebaseDatabase

struct User {
    let id: String
    let username: String
    let profilePictureUrl: String?
    let email: String
    let height: Double
    let weight: Double
    let age: Int
    let createdAt: String
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: Any],
            let id = value["id"] as? String,
            let username = value["username"] as? String,
            let profilePictureUrl = value["profilePictureUrl"] as? String?,
            let email = value["email"] as? String,
            let height = value["height"] as? Double,
            let weight = value["weight"] as? Double,
            let age = value["age"] as? Int,
            let createdAt = value["createdAt"] as? String
        else {
            return nil
        }
        
        self.id = id
        self.username = username
        self.profilePictureUrl = profilePictureUrl
        self.email = email
        self.height = height
        self.weight = weight
        self.age = age
        self.createdAt = createdAt
    }
    
    init(id: String, username: String, profilePictureUrl: String? = nil, email: String, height: Double, weight: Double, age: Int, createdAt: String) {
        self.id = id
        self.username = username
        self.profilePictureUrl = profilePictureUrl
        self.email = email
        self.height = height
        self.weight = weight
        self.age = age
        self.createdAt = createdAt
    }
    
    func toDictionary() -> [String: Any?] {
        let dict: [String: Any?] = [
            "id": self.id,
            "username": self.username,
            "profilePictureUrl": self.profilePictureUrl,
            "email": self.email,
            "height": self.height,
            "weight": self.weight,
            "age": self.age,
            "createdAt": self.createdAt
        ]
        
        return dict.compactMapValues{ $0 }
    }
}
