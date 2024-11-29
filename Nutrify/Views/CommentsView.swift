//
//  CommentsView.swift
//  Nutrify
//
//  Created by Jackie Lin on 11/29/24.
//

import SwiftUI

struct CommentsView: View {
    var postId: String
    @State var comments = [Comment]()
    @EnvironmentObject var userSession: UserSession
    @State private var comment: String = ""
    
    var body: some View {
        VStack {
            Capsule()
                .frame(width: 36, height: 5)
                .foregroundStyle(.secondary)
            ForEach(comments.sorted { comment1, comment2 in
                guard let date1 = ISO8601DateFormatter().date(from: comment1.createdAt),
                      let date2 = ISO8601DateFormatter().date(from: comment2.createdAt) else {
                    return false
                }
                return date1 > date2
            }) { comment in
                HStack {
                    ProfilePicture(profilePictureUrl: comment.user.profilePictureUrl)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(comment.user.username)
                            .font(.headline)
                        Text(comment.description)
                            .font(.body)
                    }
                    Spacer()
                }
            }
            Spacer()
            HStack {
                InputField(label: "Comment", value: $comment)
                Button(action: {
                    guard let currentUser = userSession.currentUser else { return }
                    let socialService = SocialService()
                    
                    Task {
                        do {
                            comments.append(Comment(id: UUID().uuidString, user: currentUser, description: comment, createdAt: ISO8601DateFormatter().string(from: Date())))
                            let newComment = comment
                            comment = ""
                            try await socialService.createComment(userId: currentUser.id, postId: postId, description: newComment)
                            
                            
                        }
                        catch let error {
                            print(error.localizedDescription)
                        }
                        
                    }
                }) {
                    Text("Post")
                        .padding(.vertical, 8)
                        .padding(.horizontal, 8)
                        .background(Color.blue)
                }
                .cornerRadius(8)
                .foregroundColor(.white)
            }
        }.task {
            await fetchData()
        }
        .padding()
    }
    
    func fetchData() async {
        let socialService = SocialService()
        
        do {
            comments = try await socialService.getComments(postId: postId)
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
}

//#Preview {
//    CommentsView()
//}
