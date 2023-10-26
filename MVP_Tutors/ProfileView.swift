import SwiftUI
import PhotosUI
import Firebase
import FirebaseAuth
import FirebaseStorage
import PhotoSelectAndCrop

class FirebaseManager: NSObject {
    let auth: Auth
    let storage: Storage
    
    static let shared = FirebaseManager()
    
    override init() {
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        
        super.init()
    }
}
struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var isAuthenticated: Bool
    @State private var isEditMode: Bool = true
    @StateObject private var image = ImageAttributes(withSFSymbol: "person.crop.circle.fill")
    @State private var renderingMode: SymbolRenderingMode = .hierarchical
    @State private var user: User?
    @State private var colors: [Color] = [.accentColor, Color(.systemTeal), Color.init(red: 248.0 / 255.0, green: 218.0 / 255.0, blue: 174.0 / 255.0)]
    @State private var themeColor: Color = Color.accentColor

    
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
                        // We need to convert image.image from a Image type to a UIImage type so we can represent it as jpeg data
                        let uiImage = ImageRenderer(content: image.image).uiImage
                        if let uiImage = uiImage {
                            persistImageToStorage(profileImage: uiImage)
                        }
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
    
    private func persistImageToStorage(profileImage: UIImage) {
        let filename = UUID().uuidString
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid
            else { return }
        
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        
        guard let imageData = profileImage.jpegData(compressionQuality: 0.5) else { return }
        
        ref.putData(imageData, metadata: nil) { metadata, err in
            if let err = err {
                print("Failed to push image to Storage: \(err)")
                return
            }
            
            ref.downloadURL { url, err in
                if let err = err {
                    print("Failed to retrieve downloadURL: \(err)")
                    return
                }
                
                print("successfully storeed image with url: \(url?.absoluteString ?? "")")
            }
        }
    }
    
    init(isAuthenticated: Binding<Bool>) {
        self._isAuthenticated = isAuthenticated
    }
}

#Preview{
    ProfileView(isAuthenticated: .constant(true))
}
