import Firebase
import SwiftUI
import FirebaseAuth
//To Do: Popups for error handling, and send emails 
struct AuthView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isRegistering = false
    @State private var showAlert = false
    @Binding var isAuthenticated: Bool
    @State private var loginError = ""
    @State private var isLoginErrorAlertPresented = false
    @State private var isRegisterAlertPresented = false
    @State private var RegisterError = ""
    // Reset password stuff
    @State private var resetEmail = ""
    @State private var isPasswordResetAlertPresented = false
    @State private var passwordResetError = ""
    @State private var isResetPasswordViewPresented = false // Control reset password view

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
                    TextField("First Name", text: $firstName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    TextField("Last Name", text: $lastName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

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

                if !isRegistering {
                    // Password reset button and field (shown when logging in)
                    Button(action: {
                        // Show the reset password view
                        isResetPasswordViewPresented = true
                    }) {
                        Text("Forgot Password?")
                            .foregroundColor(.blue)
                            .padding()
                    }
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
            .alert(isPresented: $isRegisterAlertPresented) {
                Alert(
                    title: Text("Registration Unsuccessful"),
                    message: Text(RegisterError),
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
            // Present the reset password view as a popup
            .sheet(isPresented: $isResetPasswordViewPresented) {
                ResetPassword(isResetPasswordViewPresented: $isResetPasswordViewPresented)
            }
        }
    }

    func toggleRegister() {
        isRegistering.toggle()
    }

    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
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
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if let error = error as? NSError {
                if error.code == AuthErrorCode.emailAlreadyInUse.rawValue {
                    DispatchQueue.main.async {
                        isRegisterAlertPresented = true
                        RegisterError = "Registration Failed. Email is already in use."
                    }
                } else {
                    DispatchQueue.main.async {
                        isRegisterAlertPresented = true
                        RegisterError = "Registration Failed. \(error.localizedDescription)"
                    }
                    print("Registration error: \(error.localizedDescription)")
                }
            } else {
                DispatchQueue.main.async {
                    print("Registration successful")
                    showAlert = true
                    login()
                    // Clear input fields
                    firstName = ""
                    lastName = ""
                    email = ""
                    password = ""
                }
            }
        }
    }

}

struct AuthView_Previews: PreviewProvider {
    @State static var isAuthenticated = true

    static var previews: some View {
        AuthView(isAuthenticated: $isAuthenticated)
    }
}
