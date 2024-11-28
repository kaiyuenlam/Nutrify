//
//  NutrifyApp.swift
//  Nutrify
//
//  Created by Kelvin Lam on 8/11/2024.
//

import SwiftUI
import FirebaseCore
import CoreData

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()

        // Preload data
        preloadData()
          
        return true
    }
    
    func preloadData() {
        let context = PersistenceController.shared.container.viewContext
        
        let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()
        do {
            let count = try context.count(for: fetchRequest)
            if count == 0 { // Only preload if there's no data
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy/MM/dd"

                // Dates for records
                let dates = [
                    "2023/01/01", "2023/02/01", "2023/03/01", "2023/04/01",
                    "2023/05/01", "2023/06/01", "2023/07/01", "2023/08/01",
                    "2023/09/01", "2023/10/01", "2023/11/01", "2023/12/01",
                    "2024/01/01", "2024/02/01", "2024/03/01", "2024/04/01",
                    "2024/05/01", "2024/06/01", "2024/07/01", "2024/08/01"
                ]

                // Generating records for each date
                for dateString in dates {
                    if let date = dateFormatter.date(from: dateString) {
                        let record = Record(context: context)
                        record.date = date
                        record.weight = Double.random(in: 60.0...80.0)
                        record.calories = Double.random(in: 2000...3000)
                        record.fat = Double.random(in: 40.0...70.0)
                        record.protein = Double.random(in: 100.0...150.0)
                        record.carbs = Double.random(in: 200.0...350.0)
                    }
                }

                // Save the context
                try context.save()
            }
        } catch {
            print("Error preloading data: \(error)")
        }
    }

}


@main
struct NutrifyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var userSession = UserSession()
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            
            if userSession.currentUser != nil {
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environmentObject(userSession)
            } else {
                LogView()
                    .environmentObject(userSession)
            }
            
            
        }
    }
}
