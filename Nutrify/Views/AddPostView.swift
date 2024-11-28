//
//  AddPostView.swift
//  Nutrify
//
//  Created by Kelvin Lam on 29/11/2024.
//

import SwiftUI
import PhotosUI

struct AddPostView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var userSession: UserSession
    @State private var photo: PhotosPickerItem?
    @State private var data: String?
    @State private var uiImage: UIImage?
    @State private var description: String = ""
    @State private var isLoading: Bool = false
    
    var body: some View {
        VStack(spacing: 25) {
            if let unwrappedUIImage = uiImage {
                ZStack(alignment: .topTrailing) {
                    Image(uiImage: unwrappedUIImage)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    Button(action: {
                        photo = nil
                        data = nil
                        uiImage = nil
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .padding()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.white)
                            
                    }
                }
            }
            else {
                VStack {
                    PhotosPicker("Select photo", selection: $photo, matching: .images)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            
            
            InputField(label: "Description", axis: .vertical, value: $description)
            
            NutrifyButton(isLoading: $isLoading, action: {
                guard let currentUser = userSession.currentUser else { return }
                
                guard let data else { return }
                
                Task {
                    isLoading = true
                    do {
                        let socialService = SocialService()
                        try await socialService.createPost(userId: currentUser.id, imageUrl: data, description: description)
                        dismiss()
                    }
                    catch let error {
                        print(error.localizedDescription)
                    }
                    isLoading = false
                }
            }, title: "Post")
            
        }.padding()
            .navigationTitle("Add Post")
            .onChange(of: photo) {
                Task {
                    do {
                        let load = try await photo?.loadTransferable(type: Data.self)
                        
                        if let load {
                            data = load.base64EncodedString()
                            
                            uiImage = UIImage(data: load)
                        }
                    }
                    catch let error {
                        print(error.localizedDescription)
                    }
                }
            }
    }
}

#Preview {
    let userSession = UserSession()
    userSession.currentUser = User(id: "1", username: "exampleusername", email: "example@example.com", height: 160, weight: 50, age: 20, createdAt: "2024-11-27T08:36:40Z")
    return AddPostView().environmentObject(userSession)
}
