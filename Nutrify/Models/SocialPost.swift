//
//  SocialPost.swift
//  Nutrify
//
//  Created by Jackie Lin on 11/28/24.
//

import Foundation
import FirebaseDatabase

struct SocialPostComment {
    let id: String
    let userId: String
    let description: String
    let createdAt: String
    
    init(id: String, userId: String, description: String, createdAt: String) {
        self.id = id
        self.userId = userId
        self.description = description
        self.createdAt = createdAt
    }
}

struct SocialPost : Identifiable {
    let id: String
    let user: User
    let imageUrl: String
    let description: String
    let createdAt: String
    let likes: [String]
    var comments: [SocialPostComment]
    
    init?(snapshot: DataSnapshot) async throws {
        guard
            let value = snapshot.value as? [String: Any],
            let id = value["id"] as? String,
            let userId = value["userId"] as? String,
            let imageUrl = value["imageUrl"] as? String,
            let description = value["description"] as? String,
            let createdAt = value["createdAt"] as? String,
            let likesObj = value["likes"] as? [String: Bool]?,
            let commentsObj = value["comments"] as? [String: Any]?
        else {
            return nil
        }
        
        if let likesObj = likesObj {
            self.likes = Array(likesObj.keys)
        }
        else {
            self.likes = [String]()
        }
        
        self.comments = [SocialPostComment]()
        if let commentsObj = commentsObj {
            for (_, value) in commentsObj {
                if let commentDict = value as? [String: Any] {
                   guard let id = commentDict["id"] as? String,
                         let userId = commentDict["userId"] as? String,
                         let description = commentDict["description"] as? String,
                         let createdAt = commentDict["createdAt"] as? String else {
                       continue
                   }
                   
                   let socialPostComment = SocialPostComment(
                       id: id,
                       userId: userId,
                       description: description,
                       createdAt: createdAt
                   )
                   
                   self.comments.append(socialPostComment)
                }
            }
        }
        else {
            self.comments = [SocialPostComment]()
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
    
    init(id: String, user: User, imageUrl: String, description: String, createdAt: String, likes: [String], comments: [SocialPostComment]) {
        self.id = id
        self.user = user
        self.imageUrl = imageUrl
        self.description = description
        self.createdAt = createdAt
        self.likes = likes
        self.comments = comments
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "id": self.id,
            "userId": self.user.id,
            "imageUrl": self.imageUrl,
            "description": self.description,
            "createdAt": self.createdAt,
            "likes": self.likes,
            "comments": self.comments
        ]
    }
    
    func isLiked(userSession: UserSession) -> Bool {
        guard let currentUser = userSession.currentUser else { return false }
        return self.likes.contains(currentUser.id)
    }
}
