import SwiftUI
import PhotosUI
import Firebase
import FirebaseAuth
//Note: Fix Logout so that it exits out into the login view
struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var isAuthenticated: Bool
    @State private var selection: PhotosPickerItem?
    @State private var user: User?
    
    var body: some View {
        VStack {
            if let user = $user.wrappedValue {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                
                PhotosPicker(
                    selection: $selection,
                    matching: .images
                ) {
                    Text("Edit Avatar")
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                }
                
                
                
                Text(user.displayName ?? "Display Name")
                    .font(.title)
                
                
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
                .frame(maxWidth: 100)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            } else{
                Text(String("Is Authenticated: " + String(isAuthenticated)))
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

#Preview{
    ProfileView(isAuthenticated: .constant(true))
}
