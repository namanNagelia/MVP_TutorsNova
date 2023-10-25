import SwiftUI
import PhotosUI
import Firebase
import FirebaseAuth
import FirebaseStorage
import PhotoSelectAndCrop


struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var isAuthenticated: Bool
    @State private var isEditMode: Bool = true
    @StateObject private var image = ImageAttributes(withSFSymbol: "person.crop.circle.fill")
    @State private var renderingMode: SymbolRenderingMode = .hierarchical
    @State private var user: User?
    @State private var colors: [Color] = [.accentColor, Color(.systemTeal), Color.init(red: 248.0 / 255.0, green: 218.0 / 255.0, blue: 174.0 / 255.0)]
    @State private var themeColor: Color = Color.accentColor
    
    let storage = Storage.storage()
    var storageRef: StorageReference

    
    let size: CGFloat = 220
    var body: some View {
        VStack {
            if let user = $user.wrappedValue {
                
                ImagePane(image: image,
                          isEditMode: $isEditMode,
                          renderingMode: renderingMode,
                          colors: colors)
                    .frame(width: size, height: size)
                    .foregroundColor(themeColor)
                    .onChange(of: image.image) {
                        print(image.image)
                    }

                
                
                
                /*
                Text(user.displayName ?? "Display Name")
                    .font(.title)
                */

                
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
        self.storageRef = storage.reference()
    }
}

#Preview{
    ProfileView(isAuthenticated: .constant(true))
}
