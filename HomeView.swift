//
//  HomeView.swift
//  Nutrify
//
//  Created by Kelvin Lam on 8/11/2024.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var nutritionData: NutritionDataModel

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                // User Info
                Text("[User Name]")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Today’s Progress")
                    .font(.headline)
                
                // Progress Stats
                HStack(spacing: 30) {
                    VStack(alignment: .leading) {
                        Text("\(nutritionData.calorieGoal - nutritionData.calorieIntake) calories to go")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                        Text("Goal: \(nutritionData.calorieGoal)")
                        Text("Intake: \(nutritionData.calorieIntake)")
                        Text("Exercise: \(nutritionData.exerciseCalories)")
                    }
                    
                    Spacer()
                }
                
                // Circular Progress Bars
                HStack(spacing: 20) {
                    ProgressRingView(progress: nutritionData.weightToLose / 10, color: .red, label: "\(nutritionData.weightToLose) kg to go")
                    ProgressRingView(progress: nutritionData.fatPercentage / 100, color: .yellow, label: "Fat \(Int(nutritionData.fatPercentage))%")
                    ProgressRingView(progress: nutritionData.proteinPercentage / 100, color: .blue, label: "Protein \(Int(nutritionData.proteinPercentage))%")
                    ProgressRingView(progress: nutritionData.carbPercentage / 100, color: .pink, label: "Carbs \(Int(nutritionData.carbPercentage))%")
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Home")
/*            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    TabBarView()
                }
                
            }*/
        }
    }
}

// Progress Ring Component
struct ProgressRingView: View {
    var progress: Double
    var color: Color
    var label: String

    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 10)
                    .opacity(0.3)
                    .foregroundColor(color)
                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .foregroundColor(color)
                    .rotationEffect(Angle(degrees: -90))
                Text("\(Int(progress * 100))%")
                    .font(.headline)
                    .fontWeight(.bold)
            }
            Text(label)
                .font(.caption)
                .multilineTextAlignment(.center)
        }
    }
}


// Preview
struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(nutritionData: NutritionDataModel())
    }
}

