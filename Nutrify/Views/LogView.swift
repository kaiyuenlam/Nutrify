//
//  LogView.swift
//  Nutrify
//
//  Created by Kelvin Lam on 8/11/2024.
//

import SwiftUI

struct LogView: View {
    @EnvironmentObject var todayRecordViewModel: TodayRecordViewModel

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("What do you want to log?")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                // Log Meal Button
                NavigationLink(destination: LogPageView()) {
                    Text("Log Meal")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                
                // Log Exercise Button
                NavigationLink(destination: ExerciseLogView()) {
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
        let todayRecordViewModel = TodayRecordViewModel(context: PersistenceController.shared.container.viewContext)
        return LogView().environmentObject(todayRecordViewModel)
    }
}

