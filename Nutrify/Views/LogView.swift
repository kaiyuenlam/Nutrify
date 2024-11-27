//
//  LogView.swift
//  Nutrify
//
//  Created by Kelvin Lam on 8/11/2024.
//

import SwiftUI

struct LogView: View {
    var body: some View {
        VStack {
            Text("Log Your Meal or Exercise")
                .font(.title)
                .padding()
            
            Button(action: {
                // Log meal
            }) {
                Text("Log Meal")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            Button(action: {
                // Log exercise
            }) {
                Text("Log Exercise")
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}


#Preview {
    LogView()
}
