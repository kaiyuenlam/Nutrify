//
//  SocialView.swift
//  Nutrify
//
//  Created by Kelvin Lam on 8/11/2024.
//

import SwiftUI

struct SocialView: View {
    @State private var isLoading = true
    @State private var posts = [SocialPost]()
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            }
            else {
                ScrollView {
                    VStack(spacing: 20) {
                        HStack {
                            Text("Social").font(.largeTitle).bold()
                            Spacer()
                            NavigationLink(destination: AddPostView()) {
                                HStack {
                                    Text("Add Post")
                                    ZStack {
                                        Circle()
                                            .fill(.blue)
                                            .frame(width: 30, height: 30)
                                        
                                        Image(systemName: "plus")
                                            .foregroundColor(.white)
                                            .font(.system(size: 20))
                                    }
                                }
                            }.foregroundColor(.blue)
                        }.padding()
                        ForEach(posts.sorted { post1, post2 in
                            guard let date1 = ISO8601DateFormatter().date(from: post1.createdAt),
                                  let date2 = ISO8601DateFormatter().date(from: post2.createdAt) else {
                                return false
                            }
                            return date1 > date2
                        }) { post in
                            PostView(post: post)
                                .padding(.horizontal)
                        }
                    }
                }
                .refreshable {
                    await fetchData()
                }
                .padding(.top, 1)
            }
        }.task {
            isLoading = true
            await fetchData()
            isLoading = false
        }
    }
    
    func fetchData() async {
        let socialService = SocialService()
        
        do {
            posts = try await socialService.getPosts()
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
}

// MARK: - Post View
struct PostView: View {
    @EnvironmentObject var userSession: UserSession
    var post: SocialPost
    @State var isLiked: Bool = false
    @State var likesCount: Int = 0
    @State var isModalShown: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // User Info
            HStack {
                ProfilePicture(profilePictureUrl: post.user.profilePictureUrl)
                VStack(alignment: .leading) {
                    Text(post.user.username)
                        .font(.headline)
                    Text(timeAgo(date: post.createdAt))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(systemName: "ellipsis")
                    .foregroundColor(.gray)
            }
            
            // Post Content
            
            AsyncImage(url: URL(string: post.imageUrl)) {
                result in result.image?
                    .resizable()
            }
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: 200)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            if let uiImage = UIImage(data: Data(base64Encoded: post.imageUrl) ?? Data()) {
                
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            // Post Text
            Text(post.description)
                .font(.body)
            
            // Post Actions
            HStack(spacing: 20) {
                Button(action: {
                    guard let currentUser = userSession.currentUser else { return }
                    
                    let socialService = SocialService()
                    
                    Task {
                        do {
                            if isLiked {
                                isLiked = false
                                likesCount -= 1
                                try await socialService.unlikePost(userId: currentUser.id, postId: post.id)
                            }
                            else {
                                isLiked = true
                                likesCount += 1
                                try await socialService.likePost(userId: currentUser.id, postId: post.id)
                            }
                        }
                        catch let error {
                            print(error.localizedDescription)
                        }
                    }
                }) {
                    HStack {
                        if isLiked {
                            Image(systemName: "heart.fill")
                        }
                        else {
                            Image(systemName: "heart")
                        }
                        Text("\(likesCount) \(likesCount == 1 ? "Like" : "Likes")")
                    }
                }
                .foregroundColor(.red)
                
                Button(action: {
                    isModalShown = true
                }) {
                    HStack {
                        Image(systemName: "bubble.right")
                        Text("\(post.comments.count) \(post.comments.count == 1 ? "Comment" : "Comments")")
                    }
                }
                .foregroundColor(.blue)
            }
            .padding(.top, 5)
            Divider()
        }.task {
            isLiked = post.isLiked(userSession: userSession)
            likesCount = post.likes.count
        }.sheet(isPresented: $isModalShown, content: {
            CommentsView(postId: post.id)
        })
    }
    
    func timeAgo(date: String) -> String {
        guard let date = ISO8601DateFormatter().date(from: date) else {
            return "Invalid date"
        }
        let calendar = Calendar.current
        let now = Date()
        
        // Calculate the time difference between now and the given date
        let components = calendar.dateComponents([.minute, .hour, .day], from: date, to: now)
        
        if let days = components.day, days > 0 {
            return days == 1 ? "1 day ago" : "\(days) days ago"
        } else if let hours = components.hour, hours > 0 {
            return hours == 1 ? "1 hour ago" : "\(hours) hours ago"
        } else if let minutes = components.minute, minutes > 0 {
            return minutes == 1 ? "1 minute ago" : "\(minutes) minutes ago"
        } else {
            return "Just now"
        }
    }
}

// MARK: - Preview
struct SocialPageView_Previews: PreviewProvider {
    static var previews: some View {
        let userSession = UserSession()
        userSession.currentUser = User(id: "1", username: "exampleusername", email: "example@example.com", height: 160, weight: 50, age: 20, createdAt: "2024-11-27T08:36:40Z")
        return SocialView().environmentObject(userSession)
    }
}
