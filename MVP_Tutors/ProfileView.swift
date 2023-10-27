import SwiftUI
import PhotosUI
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import PhotoSelectAndCrop

class FirebaseManager: NSObject {
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    
    static let shared = FirebaseManager()
    
    override init() {
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        
        super.init()
    }
}
struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var isAuthenticated: Bool
    @State private var isEditMode: Bool = true
    @StateObject private var image: ImageAttributes
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
    
    private func fetchUserData() {
        if let currentUser = FirebaseManager.shared.auth.currentUser {
            user = currentUser
        }
    
    }
    
    private func persistImageToStorage(profileImage: UIImage) {
        // checks if logged in user has a UID
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid
            else { return }
        
        // create pointer to a new storage object
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        
        // check if we have a profileImage, if so convert it to JPEG data
        guard let imageData = profileImage.jpegData(compressionQuality: 0.5) else { return }
        
        // upload data to our pointer
        ref.putData(imageData, metadata: nil) { metadata, err in
            // if we have an error...
            if let err = err {
                print("Failed to push image to Storage: \(err)")
                return
            }
            
            // retrieve the URL of the downloaded image
            ref.downloadURL { url, err in
                // if we have an error...
                if let err = err {
                    print("Failed to retrieve downloadURL: \(err)")
                    return
                }
                
                print("successfully storeed image with url: \(url?.absoluteString ?? "")")
                
                // checks if we have a url
                guard let url = url else { return }
                
                storeUserInformation(imageProfileUrl: url) // adds it to FireStore
            }
        }
    }
    
    private func storeUserInformation(imageProfileUrl: URL) {
        // Checks if logged in user has UID
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            return
        }
        
        // Checks if logged in user has email
        guard let email = FirebaseManager.shared.auth.currentUser?.email else {
            return
        }
        
        // document data
        let userData = ["email": email, "uid": uid, "profileImageUrl": imageProfileUrl.absoluteString]
        
        FirebaseManager.shared.firestore.collection("users").document(uid).setData(userData, completion: { err in
            if let err = err {
                print(err)
                return
            }
            
            print("Successfully created user")
        })
    }
    
    init(isAuthenticated: Binding<Bool>) {
        self._isAuthenticated = isAuthenticated
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            return
        }
        
        let profileImg = FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error -> Any in
            if let error = error {
                print("Failed to fetch current use: ", error)
                return ""
            }
            
            guard let data = snapshot?.data() else {
                return ""
            }
            
            return data["profileImageUrl"]
        }
        
        if profileImg != "" {
            
            self._image = StateObject(wrappedValue: new ImageAttributes(image: profileImg)
        } else {
            self._image = StateObject(wrappedValue: ImageAttributes(withSFSymbol: "person.crop.circle.fill"))
        }
        
    
        
    }
}

#Preview{
    ProfileView(isAuthenticated: .constant(true))
}
