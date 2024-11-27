//
//  UserSession.swift
//  Nutrify
//
//  Created by Jackie Lin on 11/27/24.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class UserSession : ObservableObject {
    @Published var currentUser: User? = nil
    
    init() {
        Auth.auth().addStateDidChangeListener { _, user in
            
            guard let user = user else {
                self.currentUser = nil
                return
            }
            
            Task {
                let userObj = try await self.getUser(id: user.uid)
                DispatchQueue.main.async {
                    self.currentUser = userObj
                }
            }
        }
    }
    
    private func getUser(id: String) async throws -> User? {
        let ref = Database.database().reference()
        let userSnapshot = try await ref.child("users").child(id).getData()
        
        return User(snapshot: userSnapshot)
    }
}
