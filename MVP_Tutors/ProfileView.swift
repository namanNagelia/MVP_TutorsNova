import SwiftUI
import PhotosUI
import Firebase
import FirebaseAuth

struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var isAuthenticated: Bool
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedPhotoData: Data?
    @State private var user: User?
    
    var body: some View {
        VStack {
            if let user = $user.wrappedValue {
                
                if let selectedPhotoData,
                   let image = UIImage(data: selectedPhotoData) {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                }
                
                
                
                PhotosPicker(
                    selection: $selectedPhoto,
                    matching: .images
                ) {
                    Text("Edit Avatar")
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                }.onChange(of: selectedPhoto) { // onChange runs each time selectedPhoto is changed
                    // Runs async task
                    Task {
                        // Runs asyncronous function of converting the image to data
                        if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                            selectedPhotoData = data
                        }
                    }
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
