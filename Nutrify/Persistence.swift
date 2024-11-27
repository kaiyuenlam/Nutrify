//
//  Persistence.swift
//  Nutrify
//
//  Created by Kelvin Lam on 8/11/2024.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    // Preview instance with preloaded dummy data
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Populate with sample data
        let sampleDates = [
            Date().addingTimeInterval(-86400 * 360), // 360 days ago
            Date().addingTimeInterval(-86400 * 200), // 20 days ago
            Date().addingTimeInterval(-86400 * 100), // 100 days ago
            Date().addingTimeInterval(-86400 * 50), // 50 days ago
            Date().addingTimeInterval(-86400 * 40),  // 40 days ago
            Date().addingTimeInterval(-86400 * 30),  // 30 days ago
            Date().addingTimeInterval(-86400 * 20),  // 20 days ago
            Date().addingTimeInterval(-86400 * 14),  // 14 days ago
            Date().addingTimeInterval(-86400 * 13),
            Date().addingTimeInterval(-86400 * 12),
            Date().addingTimeInterval(-86400 * 11),
            Date().addingTimeInterval(-86400 * 10),
            Date().addingTimeInterval(-86400 * 9),
            Date().addingTimeInterval(-86400 * 8),
            Date().addingTimeInterval(-86400 * 7),
            Date().addingTimeInterval(-86400 * 6),
            Date().addingTimeInterval(-86400 * 5),
            Date(),                                 // Today
        ]
        
        for date in sampleDates {
            let newRecord = Record(context: viewContext)
            newRecord.date = date
            newRecord.weight = Double.random(in: 60.0...80.0)
            newRecord.calories = Double.random(in: 2000...3000)
            newRecord.fat = Double.random(in: 40.0...70.0)
            newRecord.protein = Double.random(in: 100.0...150.0)
            newRecord.carbs = Double.random(in: 200.0...350.0)
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Nutrify")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
