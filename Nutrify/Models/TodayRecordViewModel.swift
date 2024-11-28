//
//  TodayRecordViewModel.swift
//  Nutrify
//
//  Created by Kelvin Lam on 29/11/2024.
//

import CoreData
import Foundation

class TodayRecordViewModel: ObservableObject {
    @Published var todayRecord: Record?

    init(context: NSManagedObjectContext) {
        fetchOrCreateTodayRecord(context: context)
    }

    func fetchOrCreateTodayRecord(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()

        // Define the start and end of today
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        // Filter for today's record
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)

        do {
            let records = try context.fetch(fetchRequest)
            if let todayRecord = records.first {
                self.todayRecord = todayRecord
            } else {
                // Create a new record if none exists
                let newRecord = createNewRecord(for: startOfDay, context: context)
                self.todayRecord = newRecord
            }
        } catch {
            print("Failed to fetch or create today's record: \(error)")
        }
    }

    private func createNewRecord(for date: Date, context: NSManagedObjectContext) -> Record {
        let record = Record(context: context)
        record.date = date
        record.calories = 0.0
        record.carbs = 0.0
        record.fat = 0.0
        record.protein = 0.0
        record.weight = 0.0
        do {
            try context.save()
        } catch {
            print("Failed to save new record: \(error)")
        }
        return record
    }
}

