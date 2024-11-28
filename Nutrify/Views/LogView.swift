//
//  LogView.swift
//  Nutrify
//
//  Created by Kelvin Lam on 8/11/2024.
//

import SwiftUI

struct LogView: View {
    @ObservedObject var nutritionData: NutritionDataModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("What do you want to log?")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                // Log Meal Button
                NavigationLink(destination: LogPageView(nutritionData: NutritionDataModel())) {
                    Text("Log Meal")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                
                // Log Exercise Button
                NavigationLink(destination:  ExerciseLogView(nutritionData: NutritionDataModel())) {
                    Text("Log Exercise")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
            .navigationTitle("Log")
        }
    }
}

// MARK: - Preview
struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        LogView(nutritionData: NutritionDataModel())
    }
}


#Preview {
    let nutritionData = NutritionDataModel()
    return LogView(nutritionData: nutritionData)
}
