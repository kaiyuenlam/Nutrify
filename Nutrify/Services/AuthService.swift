//
//  AuthService.swift
//  Nutrify
//
//  Created by Jackie Lin on 11/27/24.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class AuthService {
    func login(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    func logout() throws {
        try Auth.auth().signOut()
    }
    
    func register(email: String, password: String, username: String, height: Double, weight: Double, age: Int) async throws {

        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)

        let currentDate = ISO8601DateFormatter().string(from: Date())
        
        let user = User(id: authResult.user.uid, username: username, email: email, height: height, weight: weight, age: age, createdAt: currentDate)
        
        let ref = Database.database().reference()
        try await ref.child("users").child(user.id).setValue(user.toDictionary())
    }
}
