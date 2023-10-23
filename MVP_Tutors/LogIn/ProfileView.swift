import SwiftUI
import Firebase
import FirebaseAuth
//Note: Fix Logout so that it exits out into the login view
struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var isAuthenticated: Bool
    @State private var user: User?

    var body: some View {
        VStack {
            if let user = $user.wrappedValue {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .padding()

                Text(user.displayName ?? "Display Name")
                    .font(.title)

                Text(user.email ?? "Email Address")
                    .font(.subheadline)
                    .padding()

                Button("Logout") {
                    do {
                        try Auth.auth().signOut()
                        isAuthenticated = false
                        print(isAuthenticated)
                        print("Logout Successful")
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        print("Error signing out: \(error.localizedDescription)")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            } else{
                Text(String("Is Autheticated: " + String(isAuthenticated)))
            }
        }
        .onAppear {
            fetchUserData()
        }
    }

    func fetchUserData() {
        if let currentUser = Auth.auth().currentUser {
            user = currentUser
        }
    }

    init(isAuthenticated: Binding<Bool>) {
        self._isAuthenticated = isAuthenticated
    }
}
