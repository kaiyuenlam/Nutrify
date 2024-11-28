//
//  NutritionDataModel.swift
//  Nutrify
//
//  Created by Michelle Chan on 26/11/2024.
//

import Foundation
import Combine

class NutritionDataModel: ObservableObject {
    // Target intake goals
    @Published var calorieGoal: Int = 2700
    @Published var proteinGoal: Double = 100.0
    @Published var fatGoal: Double = 70.0
    @Published var carbGoal: Double = 300.0
    @Published var weightToLose: Double = 5.0
    @Published var exerciseCalories: Double = 500

    
    @Published var calorieProgress: Double = 0.0
    @Published var proteinProgress: Double = 0.0
    @Published var fatProgress: Double = 0.0
    @Published var carbProgress: Double = 0.0

    func updateProgress(from record: Record) {
        // Calculate progress percentages based on actual intake vs. goals
        calorieProgress = Double(record.calories) / Double(calorieGoal)
        proteinProgress = record.protein / proteinGoal
        fatProgress = record.fat / fatGoal
        carbProgress = record.carbs / carbGoal
    }
}
