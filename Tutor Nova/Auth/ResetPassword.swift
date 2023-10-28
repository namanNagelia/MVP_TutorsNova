//
//  ResetPassword.swift
//  MVP_Tutors
//
//  Created by Naman Nagelia on 10/10/23.
//
import Firebase
import SwiftUI

struct ResetPassword: View {
    @Binding var isResetPasswordViewPresented: Bool
    @State private var email = ""
    @State private var resetPasswordError = ""
    @State private var isPasswordResetAlertPresented = false

    var body: some View {
        VStack {
            Text("Reset Password")
                .font(.largeTitle)
                .padding(.bottom, 20)

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: resetPassword) {
                Text("Send Reset Link")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }

            Spacer()
        }
        .padding()
        .alert(isPresented: $isPasswordResetAlertPresented) {
            Alert(
                title: Text("Password Reset"),
                message: Text(resetPasswordError),
                dismissButton: .default(Text("OK")) {
                    // Dismiss the reset password view
                    isResetPasswordViewPresented = false
                }
            )
        }
    }

    func resetPassword() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                resetPasswordError = "Password reset failed. \(error.localizedDescription)"
            } else {
                resetPasswordError = "A password reset email has been sent to your email address."
            }
            isPasswordResetAlertPresented = true
        }
    }
}



