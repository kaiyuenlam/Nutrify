//
//  MetricChart.swift
//  Nutrify
//
//  Created by Kelvin Lam on 29/11/2024.
//

import SwiftUI

struct MetricChart: View {
    var records: [Record]
    var metric: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(metric.capitalized)
                .font(.headline)
                .padding(.bottom, 5)

            Chart(records) { record in
                LineMark(
                    x: .value("Date", record.date ?? Date()),
                    y: .value(metric.capitalized, value(for: metric, in: record))
                )
                .interpolationMethod(.catmullRom)
            }
            .frame(height: 200)
            .chartXAxis {
                AxisMarks(values: .stride(by: .day, count: xAxisStride(for: records.count))) {
                    AxisValueLabel(format: .dateTime.day().month(.abbreviated))
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
        }
    }

    // Helper to extract the correct value based on the metric
    func value(for metric: String, in record: Record) -> Double {
        switch metric {
        case "weight":
            return record.weight
        case "calories":
            return record.calories
        case "fat":
            return record.fat
        case "protein":
            return record.protein
        case "carbs":
            return record.carbs
        default:
            return 0.0
        }
    }

    // Helper to calculate stride for x-axis labels
    func xAxisStride(for recordCount: Int) -> Int {
        if recordCount > 30 {
            return 7  // Show a label every week for large datasets
        } else if recordCount > 7 {
            return 2  // Show a label every 2 days for medium datasets
        } else {
            return 1  // Show a label for every day
        }
    }
}

