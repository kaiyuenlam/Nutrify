//
//  SocialService.swift
//  Nutrify
//
//  Created by Jackie Lin on 11/28/24.
//

import Foundation
import FirebaseDatabase

class SocialService {
    func getPosts() async throws -> [SocialPost] {
        let ref = Database.database().reference()
        let postsSnapshot = try await ref.child("posts").getData()
        
        var posts = [SocialPost]()
        for child in postsSnapshot.children {
            guard let childSnapshot = child as? DataSnapshot else {
                continue
            }
            guard let post = try await SocialPost(snapshot: childSnapshot) else {
                continue
            }

            posts.append(post)
        }
        
        return posts
    }
    
    func createPost(userId: String, imageUrl: String, description: String) async throws {
        let ref = Database.database().reference()
        guard let key = ref.child("posts").childByAutoId().key else { return }
        
        try await ref.child("posts").child(key).setValue([
            "id": key,
            "userId": userId,
            "imageUrl": imageUrl,
            "description": description,
            "createdAt": ISO8601DateFormatter().string(from: Date()),
            "likes": [String](),
            "comments": [SocialPostComment]()
        ])
    }
    
    func likePost(userId: String, postId: String) async throws {
        let ref = Database.database().reference()
        
        try await ref.child("posts").child(postId).child("likes").child(userId).setValue(true)
    }
    
    func unlikePost(userId: String, postId: String) async throws {
        let ref = Database.database().reference()
        
        try await ref.child("posts").child(postId).child("likes").child(userId).setValue(nil)
    }
    
    func createComment(userId: String, postId: String, description: String) async throws {
        let ref = Database.database().reference()
        guard let key = ref.child("posts").childByAutoId().key else { return }
        
        try await ref.child("posts").child(postId).child("comments").child(key).setValue([
            "id": key,
            "userId": userId,
            "description": description,
            "createdAt": ISO8601DateFormatter().string(from: Date()),
        ])
    }
    
    func getComments(postId: String) async throws -> [Comment] {
        let ref = Database.database().reference()
        
        let commentsSnapshot = try await ref.child("posts").child(postId).child("comments").getData()
        
        var comments = [Comment]()
        for child in commentsSnapshot.children {
            guard let childSnapshot = child as? DataSnapshot else {
                continue
            }
            guard let comment = try await Comment(snapshot: childSnapshot) else {
                continue
            }

            comments.append(comment)
        }
        return comments
    }
}
