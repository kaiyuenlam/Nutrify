//
//  SettingsView.swift
//  Nutrify
//
//  Created by Kelvin Lam on 8/11/2024.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Example Settings Options
            Toggle("Enable Notifications", isOn: .constant(true))
            
            Toggle("Dark Mode", isOn: .constant(false))
            
            Button("Log Out") {
                // Add log out functionality here
                print("Logging out...")
            }
            .foregroundColor(.red)
            
            Spacer()
        }
        .padding()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}


#Preview {
    SettingsView()
}
