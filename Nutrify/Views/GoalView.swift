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
 .background(Color(.systemBackground))
 
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
 
 if let dateFrom = dateFrom {
 return records.filter { $0.date ?? Date() >= dateFrom }
 } else {
 return Array(records)
 }
 }
 }
 
 struct GoalView_Previews: PreviewProvider {
 static var previews: some View {
 GoalView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
 }
 }
 
 /*

import SwiftUI
import Charts
import CoreData

struct GoalView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: Record.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Record.date, ascending: true)]
    ) var records: FetchedResults<Record>  // Fetch all records from Core Data

    @State private var selectedPeriod: String = "1W" // Default to 1 week
    let periods = ["1W", "1M", "3M", "6M", "1Y", "ALL"]
    let metrics = ["weight", "calories", "fat", "protein", "carbs"]

    var body: some View {
        VStack {
            // Period selection picker
            Picker("Select Period", selection: $selectedPeriod) {
                ForEach(periods, id: \.self) { period in
                    Text(period).tag(period)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            // Scrollable charts for each metric
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ForEach(metrics, id: \.self) { metric in
                        ScrollView(.horizontal, showsIndicators: false) {
                            MetricChart(
                                records: filteredRecords(for: selectedPeriod),
                                metric: metric,
                                selectedPeriod: selectedPeriod
                            )
                            .padding(.horizontal)
                            .padding(.bottom, 20)
                            .frame(minWidth: UIScreen.main.bounds.width) // Ensure chart fills available space
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                }
            }
        }
    }

    // Filter records based on the selected period
    func filteredRecords(for period: String) -> [Record] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var startDate: Date?

        switch period {
        case "1W":
            startDate = calendar.date(byAdding: .day, value: -7, to: today)
        case "1M":
            startDate = calendar.date(byAdding: .month, value: -1, to: today)
        case "3M":
            startDate = calendar.date(byAdding: .month, value: -3, to: today)
        case "6M":
            startDate = calendar.date(byAdding: .month, value: -6, to: today)
        case "1Y":
            startDate = calendar.date(byAdding: .year, value: -1, to: today)
        case "ALL":
            startDate = nil  // No filter for ALL
        default:
            break
        }

        if let startDate = startDate {
            return records.filter { ($0.date ?? Date()) >= startDate }
        } else {
            return Array(records)  // Return all records for "ALL"
        }
    }
}

struct MetricChart: View {
    var records: [Record]
    var metric: String
    var selectedPeriod: String // Determines the x-axis label format

    var body: some View {
        VStack(alignment: .leading) {
            Text(metric.capitalized)
                .font(.headline)
                .padding(.bottom, 5)

            Chart {
                ForEach(filledData(for: metric), id: \.date) { dataPoint in
                    LineMark(
                        x: .value("Date", dataPoint.date),
                        y: .value(metric.capitalized, dataPoint.value)
                    )
                }
            }
            .frame(height: 200)
            .chartXAxis {
                AxisMarks(values: evenlySpacedDates(for: filledData(for: metric))) { value in
                    AxisValueLabel {
                        if let date = value.as(Date.self) {
                            Text(formatDate(date, for: selectedPeriod))
                                .rotationEffect(.degrees(-45)) // Rotate for better fit
                                .font(.caption)
                        }
                    }
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
        }
    }

    // Fill missing dates with the nearest past data
    func filledData(for metric: String) -> [DataPoint] {
        let allDates = generateDateRange() // Full range of dates for the selected period
        let dataMap = records.reduce(into: [Date: Double]()) { result, record in
            if let date = record.date {
                result[date] = value(for: metric, in: record)
            }
        }

        // Carry forward the nearest past value
        var lastValue: Double = 0.0
        return allDates.map { date in
            if let value = dataMap[date] {
                lastValue = value // Update last known value
            }
            return DataPoint(date: date, value: lastValue) // Use last known value
        }
    }

    // Extract metric value from a record
    func value(for metric: String, in record: Record) -> Double {
        switch metric {
        case "weight": return record.weight
        case "calories": return record.calories
        case "fat": return record.fat
        case "protein": return record.protein
        case "carbs": return record.carbs
        default: return 0.0
        }
    }

    // Generate the full date range for the selected period
    func generateDateRange() -> [Date] {
        guard let firstDate = records.first?.date, let lastDate = records.last?.date else {
            return []
        }

        let calendar = Calendar.current
        var dates = [Date]()
        var currentDate = calendar.startOfDay(for: firstDate)

        while currentDate <= lastDate {
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }

        return dates
    }

    // Calculate evenly spaced x-axis labels (max 6 labels)
    func evenlySpacedDates(for data: [DataPoint]) -> [Date] {
        let maxLabels = 6
        let stride = max(1, data.count / maxLabels)

        return data.enumerated()
            .compactMap { index, dataPoint in
                index % stride == 0 ? dataPoint.date : nil
            }
    }

    // Format date based on the selected period
    func formatDate(_ date: Date, for period: String) -> String {
        switch period {
        case "1W":
            return date.formatted(.dateTime.weekday(.narrow)) // Show only day (e.g., "M", "T")
        case "1M", "3M":
            return date.formatted(.dateTime.day().month(.abbreviated)) // Show day and month (e.g., "10 Nov")
        case "6M", "1Y", "ALL":
            return date.formatted(.dateTime.month(.abbreviated).year()) // Show month and year (e.g., "Nov 2024")
        default:
            return date.formatted(.dateTime.day().month(.abbreviated)) // Default to day and month
        }
    }
}

// Data model for each point on the chart
struct DataPoint {
    let date: Date
    let value: Double
}

// Preview for GoalView
struct GoalView_Previews: PreviewProvider {
    static var previews: some View {
        GoalView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}*/

