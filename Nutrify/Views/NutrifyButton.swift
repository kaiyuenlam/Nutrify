//
//  NutrifyButton.swift
//  Nutrify
//
//  Created by Jackie Lin on 11/27/24.
//

import SwiftUI

struct NutrifyButton: View {
    @Binding var isLoading: Bool
    var action: () -> Void
    var title: String
    
    var body: some View {
        Button(action: {
            action()
        }) {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .tint(.white)
            }
            else {
                Text(title)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
            }
        }
            .disabled(isLoading)
            .cornerRadius(8)
            .foregroundColor(.white)    
    }
}
