//
//  Comment.swift
//  Nutrify
//
//  Created by Jackie Lin on 11/29/24.
//

import Foundation
import FirebaseDatabase

struct Comment : Identifiable {
    let id: String
    let user: User
    let description: String
    let createdAt: String
    
    init(id: String, user: User, description: String, createdAt: String) {
        self.id = id
        self.user = user
        self.description = description
        self.createdAt = createdAt
    }
    
    init?(snapshot: DataSnapshot) async throws {
        guard
            let value = snapshot.value as? [String: Any],
            let id = value["id"] as? String,
            let userId = value["userId"] as? String,
            let description = value["description"] as? String,
            let createdAt = value["createdAt"] as? String
        else {
            return nil
        }
        self.id = id
        
        let userService = UserService()
        guard let userObj = try await userService.getUser(id: userId) else { throw NSError(domain: "User does not exist", code: 400) }
        
        self.user = userObj
        
        self.description = description
        self.createdAt = createdAt
    }
}
