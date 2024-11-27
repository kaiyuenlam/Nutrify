//
//  SettingsView.swift
//  Nutrify
//
//  Created by Kelvin Lam on 8/11/2024.
//

import SwiftUI

struct SettingsView: View {
    let authService = AuthService()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Example Settings Options
            Toggle("Enable Notifications", isOn: .constant(true))
            
            Toggle("Dark Mode", isOn: .constant(false))
            
            Button("Log Out") {
                do {
                    try authService.logout()
                }
                catch let error {
                    print(error.localizedDescription)
                }
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
