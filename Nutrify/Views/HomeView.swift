//
//  HomeView.swift
//  Nutrify
//
//  Created by Kelvin Lam on 8/11/2024.
//

import SwiftUI

/*
struct HomeView: View {
    @FetchRequest(
        entity: Record.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(format: "date >= %@ AND date < %@", Calendar.current.startOfDay(for: Date()) as NSDate, Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: Date()))! as NSDate)
    ) var fetchedRecords: FetchedResults<Record>
    
    @State private var refreshTrigger = false
    
    @ObservedObject var nutritionData: NutritionDataModel
    @EnvironmentObject var userSession: UserSession
    @EnvironmentObject var todayRecordViewModel: TodayRecordViewModel
    @Environment(\.managedObjectContext) private var context

    // Inline calculation for progress
    private func calculateProgress(current: Double, goal: Double) -> CGFloat {
        return goal > 0 ? CGFloat(current / goal) : 0
    }

    var body: some View {
        VStack {
            // Today's Progress Title
            Text("Today's Progress")
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
            
            // Main Progress Bar Section
            HStack {
                CircularProgressBar(
                    progress: calculateProgress(
                        current: todayRecordViewModel.todayRecord?.calories ?? 0,
                        goal: Double(nutritionData.calorieGoal)
                    ),
                    color: .purple,
                    boldText: "\(nutritionData.calorieGoal - Int(todayRecordViewModel.todayRecord?.calories ?? 0))",
                    subText: "calories to go",
                    boldTextFont: .largeTitle
                )
                .frame(width: 180, height: 180, alignment: .leading)
                .padding(10)
                
                // Goal, Intake, and Exercise Summary
                VStack(alignment: .leading, spacing: 30) {
                    HStack {
                        Image(systemName: "target")
                        Text("Goal \(nutritionData.calorieGoal)")
                    }
                    HStack {
                        Image(systemName: "fork.knife")
                        Text("Intake \(Int(todayRecordViewModel.todayRecord?.calories ?? 0))")
                    }
                    HStack {
                        Image(systemName: "flame")
                        Text("Exercise \(Int(nutritionData.exerciseCalories))")
                    }
                }
                .font(.title3)
            }
            
            // Macronutrient Progress Bars
            HStack {
                CircularProgressBar(
                    progress: calculateProgress(
                        current: todayRecordViewModel.todayRecord?.weight ?? 0,
                        goal: nutritionData.weightToLose
                    ),
                    lineWidth: 8,
                    color: .red,
                    boldText: "\(String(format: "%.1f", nutritionData.weightToLose)) kg",
                    subText: "to go"
                )
                .frame(width: 80, height: 80)
                .padding(5)
                
                CircularProgressBar(
                    progress: calculateProgress(
                        current: todayRecordViewModel.todayRecord?.fat ?? 0,
                        goal: nutritionData.fatGoal
                    ),
                    lineWidth: 8,
                    color: .orange,
                    boldText: "\(Int(calculateProgress(current: todayRecordViewModel.todayRecord?.fat ?? 0, goal: nutritionData.fatGoal) * 100)) %",
                    subText: "Fat"
                )
                .frame(width: 80, height: 80)
                .padding(5)
                
                CircularProgressBar(
                    progress: calculateProgress(
                        current: todayRecordViewModel.todayRecord?.protein ?? 0,
                        goal: nutritionData.proteinGoal
                    ),
                    lineWidth: 8,
                    color: .blue,
                    boldText: "\(Int(calculateProgress(current: todayRecordViewModel.todayRecord?.protein ?? 0, goal: nutritionData.proteinGoal) * 100)) %",
                    subText: "Protein"
                )
                .frame(width: 80, height: 80)
                .padding(5)
                
                CircularProgressBar(
                    progress: calculateProgress(
                        current: todayRecordViewModel.todayRecord?.carbs ?? 0,
                        goal: nutritionData.carbGoal
                    ),
                    lineWidth: 8,
                    color: .pink,
                    boldText: "\(Int(calculateProgress(current: todayRecordViewModel.todayRecord?.carbs ?? 0, goal: nutritionData.carbGoal) * 100)) %",
                    subText: "Carb"
                )
                .frame(width: 80, height: 80)
                .padding(5)
            }
            .padding(20)
            
            // Water Intake Section
            WaterIntakeView()
            
            // Refresh Button
            Button("Refresh") {
                refreshTrigger.toggle()
            }
            .padding()
            .background(Color.blue)
            .cornerRadius(8)
            .foregroundColor(.white)
        }
        .frame(alignment: .top)
        .padding(20)
        .onAppear {
            // Ensure today's record is loaded
            todayRecordViewModel.fetchOrCreateTodayRecord()
        }
        .onChange(of: todayRecordViewModel.forceRefresh) {
            // Force to refresh the UI
            print("Home View refresh")
            refreshTrigger.toggle()
        }
        .id(refreshTrigger)
    }
}
 */
import SwiftUI

struct HomeView: View {
    @FetchRequest(
        entity: Record.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(format: "date >= %@ AND date < %@", Calendar.current.startOfDay(for: Date()) as NSDate, Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: Date()))! as NSDate)
    ) var fetchedRecords: FetchedResults<Record>
    
    @ObservedObject var nutritionData: NutritionDataModel
    @EnvironmentObject var userSession: UserSession
    @EnvironmentObject var todayRecordViewModel: TodayRecordViewModel
    @Environment(\.managedObjectContext) private var context

    var body: some View {
        VStack {
            // Title
            Text("Today's Progress")
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
            
            if let todayRecord = fetchedRecords.first {
                // Main Progress Bar Section
                HStack {
                    CircularProgressBar(
                        progress: calculateProgress(
                            current: todayRecord.calories,
                            goal: Double(nutritionData.calorieGoal)
                        ),
                        color: .purple,
                        boldText: "\(nutritionData.calorieGoal - Int(todayRecord.calories))",
                        subText: "calories to go",
                        boldTextFont: .largeTitle
                    )
                    .frame(width: 180, height: 180, alignment: .leading)
                    .padding(10)
                    
                    // Goal, Intake, and Exercise Summary
                    VStack(alignment: .leading, spacing: 30) {
                        HStack {
                            Image(systemName: "target")
                            Text("Goal \(nutritionData.calorieGoal)")
                        }
                        HStack {
                            Image(systemName: "fork.knife")
                            Text("Intake \(Int(todayRecord.calories))")
                        }
                        HStack {
                            Image(systemName: "flame")
                            Text("Exercise \(Int(nutritionData.exerciseCalories))")
                        }
                    }
                    .font(.title3)
                }
                
                // Macronutrient Progress Bars
                HStack {
                    CircularProgressBar(
                        progress: calculateProgress(
                            current: todayRecord.weight,
                            goal: nutritionData.weightToLose
                        ),
                        lineWidth: 8,
                        color: .red,
                        boldText: "\(String(format: "%.1f", nutritionData.weightToLose)) kg",
                        subText: "to go"
                    )
                    .frame(width: 80, height: 80)
                    .padding(5)
                    
                    CircularProgressBar(
                        progress: calculateProgress(
                            current: todayRecord.fat,
                            goal: nutritionData.fatGoal
                        ),
                        lineWidth: 8,
                        color: .orange,
                        boldText: "\(Int(calculateProgress(current: todayRecord.fat, goal: nutritionData.fatGoal) * 100)) %",
                        subText: "Fat"
                    )
                    .frame(width: 80, height: 80)
                    .padding(5)
                    
                    CircularProgressBar(
                        progress: calculateProgress(
                            current: todayRecord.protein,
                            goal: nutritionData.proteinGoal
                        ),
                        lineWidth: 8,
                        color: .blue,
                        boldText: "\(Int(calculateProgress(current: todayRecord.protein, goal: nutritionData.proteinGoal) * 100)) %",
                        subText: "Protein"
                    )
                    .frame(width: 80, height: 80)
                    .padding(5)
                    
                    CircularProgressBar(
                        progress: calculateProgress(
                            current: todayRecord.carbs,
                            goal: nutritionData.carbGoal
                        ),
                        lineWidth: 8,
                        color: .pink,
                        boldText: "\(Int(calculateProgress(current: todayRecord.carbs, goal: nutritionData.carbGoal) * 100)) %",
                        subText: "Carb"
                    )
                    .frame(width: 80, height: 80)
                    .padding(5)
                }
                .padding(20)
                
                // Water Intake Section
                WaterIntakeView()
            } else {
                // Placeholder while loading or creating today's record
                Text("No data for today. Initializing...")
                    .onAppear {
                        todayRecordViewModel.fetchOrCreateTodayRecord()
                    }
            }
        }
        .padding(20)
    }
    
    private func calculateProgress(current: Double, goal: Double) -> CGFloat {
        return goal > 0 ? CGFloat(current / goal) : 0
    }
}



struct CircularProgressBar: View {
    var progress: CGFloat
    var lineWidth: CGFloat = 10
    var color: Color
    var boldText: String
    var subText: String
    var boldTextFont: Font = .headline
    var subTextFont: Font = .subheadline

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: lineWidth) 
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90)) // Start at top
                .animation(.easeOut, value: progress)

            VStack {
                Text(boldText)
                    .font(boldTextFont)
                    .bold()
                Text(subText)
                    .font(subTextFont)
                    .foregroundColor(.gray)
            }
            
            
        }
    }
}

struct WaterIntakeView: View {
    // Dummy data
    let goal = 6
    let consumed = 4

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Title row
            HStack {
                Text("Water Intake")
                    .font(.headline)
                Spacer()
                Text("View More")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }

            // Water drops row
            HStack(spacing: 10) {
                ForEach(0..<goal, id: \.self) { index in
                    if index < consumed {
                        // Filled water drop
                        Image(systemName: "drop.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                    } else {
                        // Outlined water drop
                        Image(systemName: "drop")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                    }
                }
            }

            // Footer row
            HStack {
                Text("Goal: \(goal) cups")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
                Text("\(goal - consumed) cups left")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        )
        .padding(.horizontal)
    }
}




