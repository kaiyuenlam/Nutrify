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
                let userService = UserService()
                let userObj = try await userService.getUser(id: user.uid)
                DispatchQueue.main.async {
                    self.currentUser = userObj
                }
            }
        }
    }
}
