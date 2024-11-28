//
//  SettingsView.swift
//  Nutrify
//
//  Created by Cyrus Yik on 27/11/2024.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userSession: UserSession
    @State private var daysSinceJoined: Int = 0
    
    let settings = [
        "Profile",
        "Sharing & Privacy",
        "Goal Setting",
        "Push Notifications",
    ]
    
    var body: some View {
        VStack{
            Text("Settings").fontWeight(.bold)
            Divider()
            HStack{
                VStack{
                    Text("Joined").font(.headline)
                    Text(String(daysSinceJoined)).font(.title).fontWeight(.bold)
                    Text(daysSinceJoined == 1 ? "day" : "days")
                        .font(.caption)
                }
                Spacer()
                VStack {
                    ProfilePicture(profilePictureUrl: userSession.currentUser?.profilePictureUrl, size: 70)
                    Text(userSession.currentUser?.username ?? "").fontWeight(.heavy)
                }
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                Spacer()
                VStack {
                    Text("Progress").font(.headline)
                    Text("0 kg").font(.title).fontWeight(.bold)
                    Text("changed").font(.caption)
                }
            }.padding(.horizontal, 50.0)
            NavigationView{
                List{
                    ForEach(settings, id:\.self) {
                        setting in NavigationLink(destination: Text(setting)){
                            Text(setting)
                        }.padding(20).listRowInsets(EdgeInsets())
                    }
                    Button("Log Out") {
                        let authService = AuthService()
                        do {
                            try authService.logout()
                        }
                        catch let error {
                            print(error.localizedDescription)
                        }
                    }
                    .foregroundColor(.red)
                    .padding(20)
                    .listRowInsets(EdgeInsets())
                }
                .listStyle(.insetGrouped)
                .padding(EdgeInsets(top: -30, leading: -20, bottom: 0, trailing: -20))
                .scrollDisabled(true)
            }
        }.task {
            daysSinceJoined = getDaysSince(date: userSession.currentUser?.createdAt) ?? 0
        }
    }
    
    private func getDaysSince(date: String?) -> Int? {
        guard let date else { return nil }
        
        let isoFormatter = ISO8601DateFormatter()
            
        guard let createdAtDate = isoFormatter.date(from: date) else {
            return nil
        }
        
        let now = Date()
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: createdAtDate, to: now)
        
        return components.day
    }
}

#Preview {
    let userSession = UserSession()
    userSession.currentUser = User(id: "1", username: "exampleusername", email: "example@example.com", height: 160, weight: 50, age: 20, createdAt: "2024-11-24T08:36:40Z")
    return SettingsView().environmentObject(userSession)
}
