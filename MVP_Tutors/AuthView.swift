import SwiftUI
import Firebase

struct AuthView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isRegistering = false
    @State private var showAlert = false
    @Binding var isAuthenticated: Bool // Add binding for authentication state
    
    @State private var loginError = ""
    @State private var isLoginErrorAlertPresented = false

    init(isAuthenticated: Binding<Bool>) {
        self._isAuthenticated = isAuthenticated
    }

    var body: some View {
        NavigationView {
            VStack {
                Text(isRegistering ? "Create an Account" : "Log In")
                    .font(.largeTitle)
                    .padding(.bottom, 20)

                if isRegistering {
                    // First Name input field (shown only when registering)
                    TextField("First Name", text: $firstName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    // Last Name input field (shown only when registering)
                    TextField("Last Name", text: $lastName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }

                // Email input field (shown when logging in or registering)
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                // Password input field (shown when logging in or registering)
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: isRegistering ? register : login) {
                    Text(isRegistering ? "Register" : "Login")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }

                Button(action: toggleRegister) {
                    Text(isRegistering ? "Already have an account? Log in" : "Don't have an account? Create one")
                        .foregroundColor(.blue)
                        .padding()
                }

                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Registration Successful"),
                    message: Text("A confirmation email has been sent to your email address. Please verify your email to proceed."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .alert(isPresented: $isLoginErrorAlertPresented) {
                Alert(
                    title: Text("Login Error"),
                    message: Text(loginError),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

    func toggleRegister() {
        isRegistering.toggle()
    }

    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                loginError = "Login failed. Please check your email and password."
                isLoginErrorAlertPresented = true
            } else {
                print("Login successful")
                isAuthenticated = true
            }
        }
    }

    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Registration error: \(error.localizedDescription)")
            } else {
                print("Registration successful")
                showAlert = true
                // Clear input fields
                firstName = ""
                lastName = ""
                email = ""
                password = ""
            }
        }
    }
}

//To Do: Password Reset, Check if account already exists, after register, renavigate 


struct AuthView_Previews: PreviewProvider {
    @State static var isAuthenticated = true

    static var previews: some View {
        AuthView(isAuthenticated: $isAuthenticated)
    }
}

