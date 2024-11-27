//
//  HomeView.swift
//  Nutrify
//
//  Created by Kelvin Lam on 8/11/2024.
//

import SwiftUI

struct HomeView: View {
//    @ObservedObject var nutritionData: NutritionDataModel
        
    var body: some View {
        Text("hello")
    }
//        NavigationView {
//            VStack(alignment: .leading, spacing: 20) {
//                // User Info
//                Text("[User Name]")
//                    .font(.title)
//                    .fontWeight(.bold)
//                
//                Text("Today’s Progress")
//                    .font(.headline)
//                
//                // Progress Stats
//                HStack(spacing: 30) {
//                    VStack(alignment: .leading) {
//                        Text("\(nutritionData.calorieGoal - nutritionData.calorieIntake) calories to go")
//                            .font(.largeTitle)
//                            .fontWeight(.bold)
//                            .foregroundColor(.blue)
//                        Text("Goal: \(nutritionData.calorieGoal)")
//                        Text("Intake: \(nutritionData.calorieIntake)")
//                        Text("Exercise: \(nutritionData.exerciseCalories)")
//                    }
//                    
//                    Spacer()
//                }
//                
//                // Circular Progress Bars
//                HStack(spacing: 20) {
//                    ProgressRingView(progress: nutritionData.weightToLose / 10, color: .red, label: "\(nutritionData.weightToLose) kg to go")
//                    ProgressRingView(progress: nutritionData.fatPercentage / 100, color: .yellow, label: "Fat \(Int(nutritionData.fatPercentage))%")
//                    ProgressRingView(progress: nutritionData.proteinPercentage / 100, color: .blue, label: "Protein \(Int(nutritionData.proteinPercentage))%")
//                    ProgressRingView(progress: nutritionData.carbPercentage / 100, color: .pink, label: "Carbs \(Int(nutritionData.carbPercentage))%")
//                }
//                
//                Spacer()
//            }
//            .padding()
//            .navigationTitle("Home")
///*            .toolbar {
//                ToolbarItem(placement: .bottomBar) {
//                    TabBarView()
//                }
//                
//            }*/
//        }
//    }
//}
//
//// Progress Ring Component
//struct ProgressRingView: View {
//    var progress: Double
//    var color: Color
//    var label: String
//
//    var body: some View {
//        VStack {
//            ZStack {
//                Circle()
//                    .stroke(lineWidth: 10)
//                    .opacity(0.3)
//                    .foregroundColor(color)
//                Circle()
//                    .trim(from: 0.0, to: progress)
//                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
//                    .foregroundColor(color)
//                    .rotationEffect(Angle(degrees: -90))
//                Text("\(Int(progress * 100))%")
//                    .font(.headline)
//                    .fontWeight(.bold)
//            }
//            Text(label)
//                .font(.caption)
//                .multilineTextAlignment(.center)
//        }
//    }
}


// Preview
//struct HomePageView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView(nutritionData: NutritionDataModel())
//    }
//}


/*
// updated for UI design
import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 20) {
            // User Info and Add Log
            HStack {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                Spacer()
            }
            .padding()

            // Progress Section
            VStack {
                Text("Today's Progress")
                    .font(.title2)
                    .bold()

                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 10)
                        .frame(width: 150, height: 150)

                    Circle()
                        .trim(from: 0, to: 0.55) // Adjust this to match progress
                        .stroke(Color.purple, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 150, height: 150)

                    VStack {
                        Text("1,200")
                            .font(.largeTitle)
                            .bold()
                        Text("calories to go")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }

                // Goal, Intake, and Exercise Info
                HStack {
                    VStack {
                        Text("Goal")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("2,700")
                            .font(.headline)
                    }
                    Spacer()
                    VStack {
                        Text("Intake")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("1,700")
                            .font(.headline)
                    }
                    Spacer()
                    VStack {
                        Text("Exercise")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("500")
                            .font(.headline)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 10)
            }

            // Nutrient Breakdown Section
            HStack(spacing: 20) {
                NutrientCircle(color: .red, label: "5 kg", description: "to go")
                NutrientCircle(color: .yellow, label: "29g", description: "Fat")
                NutrientCircle(color: .blue, label: "65g", description: "Protein")
                NutrientCircle(color: .pink, label: "85g", description: "Carb")
            }
            .padding(.horizontal)

            // Water Intake Section
            VStack(alignment: .leading) {
                HStack {
                    Text("Water Intake")
                        .font(.headline)
                    Spacer()
                    .font(.subheadline)
                    .foregroundColor(.blue)
                }
                HStack(spacing: 10) {
                    ForEach(0..<6) { index in
                        Circle()
                            .fill(index < 4 ? Color.blue : Color.gray.opacity(0.3))
                            .frame(width: 20, height: 20)
                    }
                }
                HStack(spacing: 10) {
                    Text("Goal: 6 cups ")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                    Text("2 cups left")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: .gray.opacity(0.2), radius: 5)
            .padding(.horizontal)

            Spacer()
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
}

struct NutrientCircle: View {
    var color: Color
    var label: String
    var description: String

    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(color, lineWidth: 5)
                    .frame(width: 50, height: 50)
                
                Text(label)
                    .font(.headline)
            }
                Text(description)
                    .font(.caption)
                    .foregroundColor(.gray)
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

*/
