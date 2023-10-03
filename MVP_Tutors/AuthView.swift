import SwiftUI

struct AuthView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var school = "University of Maryland"
    @State private var isRegistering = false
    @State private var showAlert = false

    var body: some View {
        NavigationView {
            VStack {
                Text(isRegistering ? "Create an Account" : "Log In")
                    .font(.largeTitle)
                    .padding(.bottom, 20)

                // First Name input field
                TextField("First Name", text: $firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                // Last Name input field
                TextField("Last Name", text: $lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                // Email input field
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                // Password input field
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                // School dropdown
                VStack {
                    Picker("School", selection: $school) {
                        Text("University of Maryland").tag("University of Maryland")
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                }
                .background(Color(.black))
                .cornerRadius(10)
                .padding()
                .pickerStyle(MenuPickerStyle())
                .padding(.leading, -22.0)

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
        }
    }

    func toggleRegister() {
        isRegistering.toggle()
    }

    func login() {
        // Implement login logic using Firebase here
    }

    func register() {
        // Implement registration logic using Firebase here
        // After successful registration, set showAlert = true
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
