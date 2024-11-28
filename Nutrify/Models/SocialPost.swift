//
//  SocialPost.swift
//  Nutrify
//
//  Created by Jackie Lin on 11/28/24.
//

import Foundation
import FirebaseDatabase

struct SocialPost : Identifiable {
    let id: String
    let user: User
    let imageUrl: String
    let description: String
    let createdAt: String
    let likes: [String]
    
    init?(snapshot: DataSnapshot) async throws {
        guard
            let value = snapshot.value as? [String: Any],
            let id = value["id"] as? String,
            let userId = value["userId"] as? String,
            let imageUrl = value["imageUrl"] as? String,
            let description = value["description"] as? String,
            let createdAt = value["createdAt"] as? String,
            let likesObj = value["likes"] as? [String: Bool]?
        else {
            return nil
        }
        
        if let likesObj = likesObj {
            self.likes = Array(likesObj.keys)
        }
        else {
            self.likes = [String]()
        }

        self.id = id
        
        let userService = UserService()
        guard let userObj = try await userService.getUser(id: userId) else {
            throw NSError(domain: "User does not exist", code: 400)
        }
        
        self.user = userObj
        self.imageUrl = imageUrl
        self.description = description
        self.createdAt = createdAt
    }
    
    init(id: String, user: User, imageUrl: String, description: String, createdAt: String, likes: [String]) {
        self.id = id
        self.user = user
        self.imageUrl = imageUrl
        self.description = description
        self.createdAt = createdAt
        self.likes = likes
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "id": self.id,
            "userId": self.user.id,
            "imageUrl": self.imageUrl,
            "description": self.description,
            "createdAt": self.createdAt,
            "likes": self.likes
        ]
    }
    
    func isLiked(userSession: UserSession) -> Bool {
        guard let currentUser = userSession.currentUser else { return false }
        return self.likes.contains(currentUser.id)
    }
}
