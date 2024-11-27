//
//  GoalView.swift
//  Nutrify
//
//  Created by Kelvin Lam on 8/11/2024.
//

import SwiftUI

struct GoalView: View {
    var body: some View {
        VStack {
            Text("Your Goals")
                .font(.title)
                .padding()
            
            // Example: Line chart for progress
            Text("Goal: 2500 Calories")
                .font(.headline)
                .padding()
            
            // Button to edit goal
            Button(action: {
                // Navigate to goal settings
            }) {
                Text("Edit Goal")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}


#Preview {
    GoalView()
}
