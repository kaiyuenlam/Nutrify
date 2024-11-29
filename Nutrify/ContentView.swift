//
//  ContentView.swift
//  Nutrify
//
//  Created by Kelvin Lam on 8/11/2024.
//

import SwiftUI
import CoreData
import FirebaseCore

struct ContentView: View {
    @EnvironmentObject var userSession: UserSession
    @EnvironmentObject var todayRecordViewModel: TodayRecordViewModel
    @Environment(\.managedObjectContext) private var context
    
    var nutritionDataModel = NutritionDataModel() // Dummy model for user goal
    
    var body: some View {
        if userSession.currentUser != nil {
            NavigationStack {
                TabView {
                    NavigationView {
                        HomeView(nutritionData: nutritionDataModel)
                            .navigationTitle("Home")
                    }
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                    
                    NavigationView {
                        LogView()
                            .environmentObject(TodayRecordViewModel(context: context))
                            .navigationTitle("Log")
                    }
                    .tabItem {
                        Image(systemName: "plus.circle")
                        Text("Log")
                    }
                    
                    NavigationView {
                        GoalView()
                            .navigationTitle("Goals")
                    }
                    .tabItem {
                        Image(systemName: "target")
                        Text("Goal")
                    }
                    
                    NavigationView {
                        SocialView()
                    }
                    .tabItem {
                        Image(systemName: "person.3.fill")
                        Text("Social")
                    }
                    
                    NavigationView {
                        SettingsView()
                    }
                        .tabItem {
                            Image(systemName: "gearshape.fill")
                            Text("Settings")
                        }
                }
                .accentColor(.blue)
            }
        }
        else {
            LoginView()
        }
        
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        let userSession = UserSession()
//        userSession.currentUser = User(id: "1", username: "exampleusername", email: "example@example.com", height: 160, weight: 50, age: 20, createdAt: "2024-11-27T08:36:40Z")
//        return ContentView().environmentObject(userSession)
//    }
//}
