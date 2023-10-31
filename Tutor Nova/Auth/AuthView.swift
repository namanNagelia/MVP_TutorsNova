import Firebase
import FirebaseAuth
import SwiftUI
// To Do: Popups for error handling, and send emails
// Pop up if account already exists
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
    @State private var registerErr = ""
    // Reset password stuff
    @State private var resetEmail = ""
    @State private var isPasswordResetAlertPresented = false
    @State private var passwordResetError = ""
    @State private var isResetPasswordViewPresented = false
    
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
                Group{
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                .padding(8)
                
                
                Button(action: isRegistering ? register : login) {
                    Text(isRegistering ? "Register" : "Login")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                if !isRegistering {
                    Button(action: {
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
                    message: Text(registerErr),
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
            .sheet(isPresented: $isResetPasswordViewPresented) {
                ResetPassword(isResetPasswordViewPresented: $isResetPasswordViewPresented)
            }
        }
    }
    
    private func toggleRegister() {
        isRegistering.toggle()
    }
    
    private func login() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                loginError = "Login failed. Please check your email and password."
                isLoginErrorAlertPresented = true
            } else {
                print("Successfully log in user: \(result?.user.uid ?? "")")
                isAuthenticated = true
            }
        }
    }
    
    private func register() {
        print("running register..")
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Register error: \(error.localizedDescription)")
                registerErr = "Registration Failed. \(error.localizedDescription)"
                isRegisterAlertPresented = true
            } else if let user = authResult?.user {
                // Set the user's display name
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = "\(firstName) \(lastName)"
                changeRequest.commitChanges { error in
                    if let error = error {
                        print("Error setting display name: \(error.localizedDescription)")
                    } else {
                        DispatchQueue.main.async {
                            print("Registration successful")
                            showAlert = true
                            login()
                            storeUserInformation()
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
        
        
    }
    
    private func storeUserInformation() {
        
        print("Running store...")
        // Checks if logged in user has UID
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            return
        }
        
        // Checks if logged in user has email
        guard let email = FirebaseManager.shared.auth.currentUser?.email else {
            return
        }
        
        // document data
        let userData = ["email": email, "uid": uid, "profileImageUrl": "", "firstName": firstName, "lastName": lastName]
        
        FirebaseManager.shared.firestore.collection("users").document(uid).setData(userData, completion: { err in
            if let err = err {
                print(err)
                return
            }
            
            print("Successfully created user")
        })
    }
}

#Preview {
    AuthView(isAuthenticated: .constant(false))
}
