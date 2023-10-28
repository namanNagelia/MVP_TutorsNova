import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import PhotosUI
import SwiftUI

class appUser: ObservableObject{
    @Published var userid: String = ""
    @Published var profileImgString: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
}

struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var isAuthenticated: Bool
    @State private var isEditMode: Bool = true
    @State private var renderingMode: SymbolRenderingMode = .hierarchical
    @State private var user: User?
    @State private var colors: [Color] = [.accentColor, Color(.systemTeal), Color(red: 248.0 / 255.0, green: 218.0 / 255.0, blue: 174.0 / 255.0)]
    @State private var themeColor: Color = .accentColor
    @State var shouldShowImagePicker = false
    @State var image: UIImage?
    @ObservedObject var appUserInstance: appUser

    
    let size: CGFloat = 220
    var body: some View {
        VStack {
            if let user = $user.wrappedValue {
                Button {
                    shouldShowImagePicker.toggle()
                } label: {
                    VStack {
                        if let image = self.image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 128, height: 128)
                                .cornerRadius(64)
                        } else {
                            Image(systemName: "person.fill")
                                .font(.system(size: 64))
                                .padding()
                                .foregroundColor(Color(.label))
                        }
                    }
                    .overlay(RoundedRectangle(cornerRadius: 64)
                        .stroke(Color.black, lineWidth: 3)
                    )
                }
                
                Text(user.displayName ?? "Display Name")
                    .font(.title)
                
                Button("Save Changes") {
                    persistImageToStorage()
                    fetchUserData()
                }
                .frame(maxWidth: 100)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
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
            } else {
                Text(String("Is Authenticated: " + String(isAuthenticated)))
            }
        }
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
        }
        .onAppear {
            fetchUserData()
        }
    }
    
    public func fetchUserData() {
        if let currentUser = FirebaseManager.shared.auth.currentUser {
            user = currentUser
        }
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            return
        }
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("Failed to fetch current use: ", error)
                return
            }
            
            guard let data = snapshot?.data() else {
                print("No data found")
                return
            }
            print(data)
            
            appUserInstance.profileImgString = data["profileImageUrl"] as? String ?? ""
            appUserInstance.userid = data["uid"] as? String ?? ""
            appUserInstance.firstName = data["firstName"] as? String ?? ""
            appUserInstance.lastName = data["lastName"] as? String ?? ""
            appUserInstance.email = data["email"] as? String ?? ""
            
            if let url = URL(string: appUserInstance.profileImgString) {
                URLSession.shared.dataTask(with: url) { data, _, error in
                    if let error = error {
                        print("Failed to load image data: \(error)")
                        return
                    }
                    
                    if let data = data, let uiImage = UIImage(data: data) {
                        print("Yes")
                        DispatchQueue.main.async {
                            self.$image.wrappedValue = uiImage
                        }
                    }
                }.resume()
            }
        }
    }
    
    private func persistImageToStorage() {
        // checks if logged in user has a UID
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid
        else { print("No current user - persistImageToStorage()"); return }
        
        // create pointer to a new storage object
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        
        // check if we have a profileImage, if so convert it to JPEG data
        guard let imageData = image?.jpegData(compressionQuality: 0.5) else { return }
        
        // upload data to our pointer
        ref.putData(imageData, metadata: nil) { _, err in
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
                
                updateUserInformation(imageProfileUrl: url) // adds it to FireStore
            }
        }
    }
    
    private func updateUserInformation(imageProfileUrl: URL) {
        // Checks if logged in user has UID
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            print("No current user - updateUserInformation()")
            return
        }
        
        // Define the data you want to update
        let updatedData = ["profileImageUrl": imageProfileUrl.absoluteString]
        
        // Reference the document for the user using their UID
        let userDocumentReference = FirebaseManager.shared.firestore.collection("users").document(uid)
        
        // Use the updateData method to update the specific fields in the document
        userDocumentReference.updateData(updatedData) { error in
            if let error = error {
                print("Error updating user information: \(error)")
                return
            }
            
            print("User information updated successfully")
        }
    }
    
    init(isAuthenticated: Binding<Bool>, appUserInstance: appUser) {
            self._isAuthenticated = isAuthenticated
            self.appUserInstance = appUserInstance
        }

}
