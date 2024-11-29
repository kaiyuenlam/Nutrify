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
    @Published var currentUser: User? = nil // Nil when logged out
    @Published var isLoading: Bool = true
    
    init() {
        Auth.auth().addStateDidChangeListener { _, user in
            
            guard let user = user else {
                self.currentUser = nil
                self.isLoading = false
                return
            }
            
            Task {
                let userService = UserService()
                do {
                    let userObj = try await userService.getUser(id: user.uid)
                    DispatchQueue.main.async {
                        self.currentUser = userObj
                    }
                } catch let error {
                    print("Error fetching user: \(error.localizedDescription)")
                }
                self.isLoading = false
            }
        }
    }
}
