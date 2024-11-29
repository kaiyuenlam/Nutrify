//
//  TodayRecordViewModel.swift
//  Nutrify
//
//  Created by Kelvin Lam on 29/11/2024.
//

import Foundation
import CoreData
import Combine

class TodayRecordViewModel: ObservableObject {
    @Published var todayRecord: Record?
    private var currentDate: Date?
    private var context: NSManagedObjectContext
    private var cancellables = Set<AnyCancellable>()
    @Published var forceRefresh = false

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchOrCreateTodayRecord()
        subscribeToCoreDataChanges()
    }

    func fetchOrCreateTodayRecord() {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())

        // Check if already initialized for today
        if let currentDate = currentDate, calendar.isDate(currentDate, inSameDayAs: startOfDay) {
            return
        }

        currentDate = startOfDay

        let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)

        do {
            let records = try context.fetch(fetchRequest)
            if let existingRecord = records.first {
                self.todayRecord = existingRecord
                print("fetched new data")
            } else {
                // Create a new record for today
                let newRecord = Record(context: context)
                newRecord.date = startOfDay
                newRecord.calories = 0.0
                newRecord.carbs = 0.0
                newRecord.fat = 0.0
                newRecord.protein = 0.0
                newRecord.weight = 0.0
                newRecord.exerciseCalories = 0.0
                try context.save()
                self.todayRecord = newRecord
                print("create a new record")
            }
        } catch {
            print("Failed to fetch or create today's record: \(error)")
        }
    }

    private func subscribeToCoreDataChanges() {
        NotificationCenter.default.publisher(for: .NSManagedObjectContextObjectsDidChange, object: context)
            .sink { [weak self] notification in
                print("Core Data changes detected.")
                self?.fetchOrCreateTodayRecord()
            }
            .store(in: &cancellables)
    }
    
    private func triggerUIRefresh() {
        DispatchQueue.main.async {
            self.forceRefresh.toggle()
        }
    }
}


