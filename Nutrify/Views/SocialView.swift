//
//  SocialView.swift
//  Nutrify
//
//  Created by Kelvin Lam on 8/11/2024.
//

import SwiftUI

struct SocialView: View {
    let posts: [SocialPost] = [
        SocialPost(username: "Rebecca", profileImage: "person.circle", timeAgo: "30 minutes ago",
                   content: "Homemade ramen for today’s meal! Packed with flavor and balanced nutrition.", image: "image", weightProgress: 72.4, fatReduction: 21),
        SocialPost(username: "James", profileImage: "person.circle.fill", timeAgo: "30 minutes ago",
                   content: "Huge milestone reached! I've achieved a 21% reduction in body fat, and it feels amazing!", image: "image",
                   weightProgress: 72.4, fatReduction: 21),
        SocialPost(username: "Rebecca", profileImage: "person.circle", timeAgo: "30 minutes ago",
                   content: "Homemade ramen for today’s meal! Packed with flavor and balanced nutrition.",
                   image: "image" ,weightProgress: 72.4, fatReduction: 21)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(posts) { post in
                        PostView(post: post)
                            .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Social")
            .navigationBarTitleDisplayMode(.inline)
        }
        .tabItem {
            Label("Social", systemImage: "person.3")
        }
    }
}

// MARK: - Post View
struct PostView: View {
    let post: SocialPost
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // User Info
            HStack {
                Image(systemName: post.profileImage)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                VStack(alignment: .leading) {
                    Text(post.username)
                        .font(.headline)
                    Text(post.timeAgo)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(systemName: "ellipsis")
                    .foregroundColor(.gray)
            }
            
            // Post Content
            if let image = post.image {
                Image(image)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else if let weightProgress = post.weightProgress {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Weight")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    HStack {
                        Text("\(String(format: "%.1f", weightProgress)) Kg")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    ProgressView(value: post.fatReduction ?? 0, total: 100)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .frame(height: 10)
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
            }
            
            // Post Text
            Text(post.content)
                .font(.body)
            
            // Post Actions
            HStack(spacing: 20) {
                Button(action: {}) {
                    HStack {
                        Image(systemName: "heart")
                        Text("Like")
                    }
                }
                .foregroundColor(.red)
                
                Button(action: {}) {
                    HStack {
                        Image(systemName: "bubble.right")
                        Text("Comment")
                    }
                }
                .foregroundColor(.blue)
            }
            .padding(.top, 5)
            Divider()
        }
    }
}

// MARK: - Social Post Model
struct SocialPost: Identifiable {
    let id = UUID()
    let username: String
    let profileImage: String
    let timeAgo: String
    let content: String
    let image: String?
    let weightProgress: Double?
    let fatReduction: Double?
}

// MARK: - Preview
struct SocialPageView_Previews: PreviewProvider {
    static var previews: some View {
        SocialView()
    }
}
