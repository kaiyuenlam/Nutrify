import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var username = ""
    @State private var height = ""
    @State private var weight = ""
    @State private var age = ""
    @State private var isRegistering = false
    
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
                InputField(label: "Age", value: $age)
                Button(action: {
                    guard let heightValue = Double(height) else { return }
                    
                    guard let weightValue = Double(weight) else { return }
                    
                    guard let ageValue = Int(age) else { return }
   
                    Task {
                        do {
                            let user = try await authService.register(email: email, password: password, username: username, height: heightValue, weight: weightValue, age: ageValue)
                        }
                        catch let error {
                            print(error.localizedDescription)
                        }
                        
                    }
                }) {
                    Text("Create an Account")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            } else {
                // Login Fields
                TextField("Email Address", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    // Login button action here
                }) {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            
            // Continue with Google
            HStack {
                Spacer()
                Text("or use Google to Login")
                    .font(.footnote)
                    .foregroundColor(.gray)
                Spacer()
            }
            
            Button(action: {
                // Google login action here
            }) {
                HStack {
                    Image(systemName: "globe")
                        .foregroundColor(.gray)
                    Text("Continue with Google")
                        .foregroundColor(.gray)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
            }
            
            Spacer()
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

