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
    @State private var errorMessage: AlertMessage?
    @EnvironmentObject var userSession: UserSession
    
    let authService = AuthService()

    var body: some View {
        if !userSession.isLoading {
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
                        handleRegistration()
                    }, title: "Create an Account")
                    
                } else {
                    // Login Fields
                    InputField(label: "Email Address", value: $email)
                        .keyboardType(.emailAddress)
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    NutrifyButton(isLoading: $isLoading, action: {
                        handleLogin()
                    }, title: "Login")
                }
                
                Spacer()
            }
            .padding()
            .disabled(isLoading)
            .alert(item: $errorMessage) { alert in
                Alert(title: Text("Error"), message: Text(alert.message), dismissButton: .default(Text("OK")))
            }
        }
        else {
            ProgressView()
        }
    }
    
    private func handleRegistration() {
        isLoading = true
        errorMessage = nil
        
        guard !username.isEmpty else {
            errorMessage = AlertMessage(message: "Username is required.")
            isLoading = false
            return
        }
        
        guard isValidEmail(email) else {
            errorMessage = AlertMessage(message: "Please enter a valid email address.")
            isLoading = false
            return
        }
        
        guard let heightValue = Double(height), heightValue > 0 else {
            errorMessage = AlertMessage(message: "Please enter a valid height.")
            isLoading = false
            return
        }
        
        guard let weightValue = Double(weight), weightValue > 0 else {
            errorMessage = AlertMessage(message: "Please enter a valid weight.")
            isLoading = false
            return
        }
        
        guard let ageValue = Int(age), ageValue > 0 else {
            errorMessage = AlertMessage(message: "Please enter a valid age.")
            isLoading = false
            return
        }
        
        Task {
            do {
                try await authService.register(email: email, password: password, username: username, height: heightValue, weight: weightValue, age: ageValue)
            } catch {
                errorMessage = AlertMessage(message: error.localizedDescription)
            }
            isLoading = false
        }
    }
    
    private func handleLogin() {
        isLoading = true
        errorMessage = nil
        
        guard isValidEmail(email) else {
            errorMessage = AlertMessage(message: "Please enter a valid email address.")
            isLoading = false
            return
        }
        
        guard !password.isEmpty else {
            errorMessage = AlertMessage(message: "Password is required.")
            isLoading = false
            return
        }
        
        Task {
            do {
                try await authService.login(email: email, password: password)
            } catch {
                errorMessage = AlertMessage(message: error.localizedDescription)
            }
            isLoading = false
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
}

struct AlertMessage: Identifiable {
    let id = UUID() // Ensures uniqueness
    let message: String
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let userSession = UserSession()
        userSession.currentUser = User(id: "1", username: "haha", email: "wow", height: 4, weight: 4, age: 8, createdAt: "no")
        userSession.isLoading = false
        return LoginView().environmentObject(userSession)
    }
}

