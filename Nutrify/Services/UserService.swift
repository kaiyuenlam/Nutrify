//
//  UserService.swift
//  Nutrify
//
//  Created by Jackie Lin on 11/28/24.
//

import Foundation
import FirebaseDatabase

class UserService {
    func getUser(id: String) async throws -> User? {
        let ref = Database.database().reference()
        let userSnapshot = try await ref.child("users").child(id).getData()
        
        return User(snapshot: userSnapshot)
    }
    
    func createUser(user: User) async throws {
        let ref = Database.database().reference()
        try await ref.child("users").child(user.id).setValue(user.toDictionary())
    }
}
