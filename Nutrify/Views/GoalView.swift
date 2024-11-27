//
//  GoalView.swift
//  Nutrify
//
//  Created by Kelvin Lam on 8/11/2024.
//

import SwiftUI
import CoreData

struct GoalView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: Record.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Record.date, ascending: true)]
    ) var records: FetchedResults<Record>  // Fetch all records from Core Data

    @State private var selectedPeriod: String = "1W" // Default to 1 week
    let periods = ["1W", "2W", "1M", "3M", "6M", "1Y", "ALL"]
    let metrics = ["weight", "calories", "fat", "protein", "carbs"]

    var body: some View {
        VStack {
            // Fixed period selection bar at the top
            Picker("Select Period", selection: $selectedPeriod) {
                ForEach(periods, id: \.self) { period in
                    Text(period).tag(period)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .background(Color(.systemBackground)) // Ensures the background matches the theme

            // Scrollable charts for each metric
            ScrollView(.vertical, showsIndicators: true) {
                VStack {
                    ForEach(metrics, id: \.self) { metric in
                        ChartView(
                            records: filteredRecords(for: selectedPeriod),  // Pass filtered records based on the period
                            metric: metric,
                            selectedPeriod: selectedPeriod  // Pass selected period for proper x-axis formatting
                        )
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        .onChange(of: selectedPeriod) {
        }
    }

    // Filter records based on the selected period
    func filteredRecords(for period: String) -> [Record] {
        let calendar = Calendar.current
        var dateFrom: Date?
        
        switch period {
        case "1W":
            dateFrom = calendar.date(byAdding: .weekOfYear, value: -1, to: Date())
        case "2W":
            dateFrom = calendar.date(byAdding: .weekOfYear, value: -2, to: Date())
        case "1M":
            dateFrom = calendar.date(byAdding: .month, value: -1, to: Date())
        case "3M":
            dateFrom = calendar.date(byAdding: .month, value: -3, to: Date())
        case "6M":
            dateFrom = calendar.date(byAdding: .month, value: -6, to: Date())
        case "1Y":
            dateFrom = calendar.date(byAdding: .year, value: -1, to: Date())
        case "ALL":
            dateFrom = nil  // No filter for ALL
        default:
            break
        }

        // Filter records based on the selected period
        if let dateFrom = dateFrom {
            return records.filter { $0.date ?? Date() >= dateFrom }
        } else {
            return Array(records)  // If no period is selected, return all records
        }
    }
}

// Preview for GoalView using actual data from PersistenceController
struct GoalView_Previews: PreviewProvider {
    static var previews: some View {
        GoalView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
