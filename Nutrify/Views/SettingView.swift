//
//  ContentView.swift
//  projectapp
//
//  Created by Cyrus Yik on 27/11/2024.
//

import SwiftUI
import CoreData

struct SettingView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    let settings = [
        "Profile",
        "Sharing & Privacy",
        "Goal Setting",
        "Push Notifications",
        "Logout"
    ]
    var body: some View {
        VStack{
            Text("Settings").fontWeight(.bold)
            Divider()
            HStack{
                VStack{
                    Text("Joined").font(.headline)
                    Text("1").font(.title).fontWeight(.bold)
                    Text("day")
                        .font(.caption)
                }
                Spacer()
                VStack {
                    Image(systemName: "person.crop.circle").font(.system(size: 70)).foregroundColor(Color.black).fontWeight(.light)
                    Text("Username").fontWeight(.heavy)
                }.padding(.top,20)
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
                }.listStyle(.insetGrouped).padding(EdgeInsets(top: -40, leading: -20, bottom: 0, trailing:-20))
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    SettingView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
