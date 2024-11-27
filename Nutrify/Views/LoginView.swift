import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var username = ""
    @State private var height = ""
    @State private var weight = ""
    @State private var age = ""
    @State private var isRegistering = false
    @State private var isLoading = false
    @EnvironmentObject var userSession: UserSession
    
    let authService = AuthService()

    var body: some View {
        VStack(spacing: 20) {
            // App Logo and Title
            Text("NUTRIFY")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .padding(.top, 40)
            
            Text("Welcome to Your Personal Nutrition Companion")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Toggle between Login and Register
            HStack {
                Button(action: { isRegistering = false }) {
                    Text("Login")
                        .fontWeight(isRegistering ? .regular : .bold)
                        .foregroundColor(isRegistering ? .gray : .blue)
                }
                
                Button(action: { isRegistering = true }) {
                    Text("Get Started")
                        .fontWeight(isRegistering ? .bold : .regular)
                        .foregroundColor(isRegistering ? .blue : .gray)
                }
            }
            
            Divider()
            
            // Dynamic Input Fields
            if isRegistering {
                // Registration Fields
                InputField(label: "User Name", value: $username)
                InputField(label: "Email Address", value: $email)
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                InputField(label: "Height (cm)", value: $height)
                    .keyboardType(.decimalPad)
                InputField(label: "Weight (kg)", value: $weight)
                    .keyboardType(.decimalPad)
                InputField(label: "Age", value: $age)
                    .keyboardType(.numberPad)
                
                NutrifyButton(isLoading: $isLoading, action: {
                    isLoading = true
                    guard let heightValue = Double(height) else {
                        isLoading = false
                        return
                    }
                    
                    guard let weightValue = Double(weight) else {
                        isLoading = false
                        return
                    }
                    
                    guard let ageValue = Int(age) else {
                        isLoading = false
                        return
                    }
   
                    Task {
                        do {
                            try await authService.register(email: email, password: password, username: username, height: heightValue, weight: weightValue, age: ageValue)
                        }
                        catch let error {
                            print(error.localizedDescription)
                        }
                        isLoading = false
                    }
                }, title: "Create an Account")
            } else {
                // Login Fields
                InputField(label: "Email Address", value: $email)
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                NutrifyButton(isLoading: $isLoading, action: {
                    isLoading = true
                    Task {
                        do {
                            try await authService.login(email: email, password: password)
                        }
                        catch let error {
                            print(error.localizedDescription)
                        }
                        isLoading = false
                    }}, title: "Login")
            }
            
            Spacer()
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let userSession = UserSession()
        userSession.currentUser = User(id: "1", username: "haha", email: "wow", height: 4, weight: 4, age: 8, createdAt: "no")
        return LoginView().environmentObject(userSession)
    }
}

