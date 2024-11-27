//
//  ChartView.swift
//  Nutrify
//
//  Created by Kelvin Lam on 27/11/2024.
//

import SwiftUI
import CoreData

struct ChartView: View {
    var records: [Record]  // Core Data records
    var metric: String
    var selectedPeriod: String  // To format the x-axis labels correctly

    var body: some View {
        VStack {
            Text("\(metric.capitalized) Over Time")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 10)

            GeometryReader { geometry in
                HStack(alignment: .top) {
                    // Y-axis labels
                    VStack(alignment: .trailing) {
                        ForEach(yAxisLabels(for: metric), id: \.self) { label in
                            Text(label)
                                .font(.caption)
                                .frame(maxHeight: .infinity, alignment: .center)
                        }
                    }
                    .frame(width: 40)  // Ensure space for y-axis

                    // Chart area
                    VStack {
                        ZStack {
                            // Background grid
                            GridBackground()

                            // Line chart clipped within the grid
                            LineChartPath(data: chartPoints(for: metric, frame: geometry.size))
                                .stroke(Color.blue, lineWidth: 2)
                                .clipShape(Rectangle())
                        }

                        // X-axis labels
                        HStack {
                            ForEach(xAxisLabels(), id: \.self) { label in
                                Text(label)
                                    .font(.caption)
                                    .lineLimit(1)  // Prevents splitting into multiple lines
                                    .minimumScaleFactor(0.5)  // Shrinks the text if necessary
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.horizontal, 2)  // Add some padding for spacing
                            }
                        }
                    }
                }
            }
            .frame(height: 250)
        }
        .padding()
    }

    private func chartPoints(for metric: String, frame: CGSize) -> [(x: CGFloat, y: CGFloat)] {
        let values = self.values(for: metric)
        guard !values.isEmpty else { return [] }

        let maxValue = values.max() ?? 1
        let minValue = values.min() ?? 0
        let range = maxValue - minValue

        // Adjust the x-axis width to leave space for the y-axis
        let xStep = (frame.width - 40) / CGFloat(values.count - 1)  // Adjusted width for y-axis space

        return values.enumerated().map { index, value in
            (
                x: CGFloat(index) * xStep,
                y: frame.height - ((CGFloat(value - minValue) / CGFloat(range)) * frame.height)  // Inverted y-axis
            )
        }
    }

    private func values(for metric: String) -> [Double] {
        switch metric {
        case "weight":
            return records.map { $0.weight }
        case "calories":
            return records.map { $0.calories }
        case "fat":
            return records.map { $0.fat }
        case "protein":
            return records.map { $0.protein }
        case "carbs":
            return records.map { $0.carbs }
        default:
            return []
        }
    }

    private func yAxisLabels(for metric: String) -> [String] {
        guard let max = values(for: metric).max(),
              let min = values(for: metric).min() else { return [] }

        let step = (max - min) / 5
        return (0...5).map { i in
            String(format: "%.1f", min + (step * Double(i)))
        }
    }

    // Generate x-axis labels based on the selected period
    private func xAxisLabels() -> [String] {
        var limitedRecords: [Record] = []
        let calendar = Calendar.current
        let currentDate = Date()

        // Calculate the start date based on the selected period
        let startDate: Date?

        switch selectedPeriod {
        case "1W":
            limitedRecords = records.filter { calendar.isDate($0.date ?? Date(), equalTo: currentDate, toGranularity: .weekOfYear) }
        case "2W":
            limitedRecords = records.filter { calendar.isDate($0.date ?? Date(), equalTo: currentDate, toGranularity: .weekOfYear) }
        case "1M":
            limitedRecords = records.filter { calendar.isDate($0.date ?? Date(), equalTo: currentDate, toGranularity: .month) }
        case "3M":
            startDate = calendar.date(byAdding: .month, value: -3, to: currentDate)
            limitedRecords = records.filter { ($0.date ?? Date()) >= startDate! }

            // Ensure there are 6 data points for the last 3 months
            limitedRecords = adjustDataForPeriod(records: limitedRecords, period: "3M")
        case "6M":
            startDate = calendar.date(byAdding: .month, value: -6, to: currentDate)
            limitedRecords = records.filter { ($0.date ?? Date()) >= startDate! }

            // Ensure there are 6 data points for the last 6 months
            limitedRecords = adjustDataForPeriod(records: limitedRecords, period: "6M")
        case "1Y":
            startDate = calendar.date(byAdding: .year, value: -1, to: currentDate)
            limitedRecords = records.filter { ($0.date ?? Date()) >= startDate! }

            // Ensure there are 6 data points for the last year
            limitedRecords = adjustDataForPeriod(records: limitedRecords, period: "1Y")
        case "ALL":
            limitedRecords = records
        default:
            break
        }

        // Limit to exactly 6 data points
        limitedRecords = Array(limitedRecords.prefix(6))

        let formatter = DateFormatter()

        // Format the x-axis labels depending on the selected period
        switch selectedPeriod {
        case "1W", "2W", "1M":
            // Show the date for 1W, 2W, and 1M
            formatter.dateFormat = "MMM dd"
            return limitedRecords.map { formatter.string(from: $0.date ?? Date()) }

        case "3M", "6M", "1Y":
            // Show only the month for 3M, 6M, and 1Y
            formatter.dateFormat = "MMM"
            return limitedRecords.map { formatter.string(from: $0.date ?? Date()) }

        case "ALL":
            // Show the month and year for ALL
            formatter.dateFormat = "MMM yyyy"
            return limitedRecords.map { formatter.string(from: $0.date ?? Date()) }

        default:
            return []
        }
    }

    // Adjust data to ensure exactly 6 data points for each period
    private func adjustDataForPeriod(records: [Record], period: String) -> [Record] {
        var adjustedRecords: [Record] = []
        let calendar = Calendar.current

        // For 3M, 6M, 1Y we need to select records based on the period
        switch period {
        case "3M":
            // Select 2 data points per month (total of 6 points for 3 months)
            for i in 0..<3 {
                let monthRecords = records.filter {
                    let components = calendar.dateComponents([.month, .year], from: $0.date ?? Date())
                    return components.month == (calendar.component(.month, from: Date()) - i) % 12
                }
                adjustedRecords.append(contentsOf: monthRecords.prefix(2))  // Get first and last record of the month
            }

        case "6M":
            // Select 1 data point per month (total of 6 points for 6 months)
            for i in 0..<6 {
                let monthRecords = records.filter {
                    let components = calendar.dateComponents([.month, .year], from: $0.date ?? Date())
                    return components.month == (calendar.component(.month, from: Date()) - i) % 12
                }
                adjustedRecords.append(contentsOf: monthRecords.prefix(1))  // Get a single record for each month
            }

        case "1Y":
            // Select 1 data point every 2 months (total of 6 points for 12 months)
            for i in stride(from: 0, to: 12, by: 2) {
                let monthRecords = records.filter {
                    let components = calendar.dateComponents([.month, .year], from: $0.date ?? Date())
                    return components.month == (calendar.component(.month, from: Date()) - i) % 12
                }
                adjustedRecords.append(contentsOf: monthRecords.prefix(1))  // Get a single record every 2 months
            }

        default:
            break
        }

        return adjustedRecords
    }
}

// Grid Background with Y-Axis Lines
struct GridBackground: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let yStep = geometry.size.height / 5
                for i in 0..<5 {
                    let y = CGFloat(i) * yStep
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: geometry.size.width - 40, y: y))  // Adjust to ensure no overlap with y-axis
                }
            }
            .stroke(Color.gray.opacity(0.2))
        }
    }
}

// Line Chart Path
struct LineChartPath: Shape {
    var data: [(x: CGFloat, y: CGFloat)]

    func path(in rect: CGRect) -> Path {
        guard data.count > 1 else { return Path() }

        return Path { path in
            path.move(to: CGPoint(x: data[0].x, y: data[0].y))
            for point in data.dropFirst() {
                path.addLine(to: CGPoint(x: point.x, y: point.y))
            }
        }
    }
}
