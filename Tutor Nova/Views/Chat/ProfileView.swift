import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import PhotosUI
import SwiftUI

struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var isAuthenticated: Bool
    @State private var isEditMode: Bool = true
    @State private var renderingMode: SymbolRenderingMode = .hierarchical
    @State private var colors: [Color] = [.accentColor, Color(.systemTeal), Color(red: 248.0 / 255.0, green: 218.0 / 255.0, blue: 174.0 / 255.0)]
    @State private var themeColor: Color = .accentColor
    @State var shouldShowImagePicker = false
    @EnvironmentObject var appUser: AppUser
    
    let size: CGFloat = 220
    var body: some View {
        VStack {
            if let user = appUser.user {
                Button {
                    shouldShowImagePicker.toggle()
                } label: {
                    VStack {
                        if appUser.image != nil {
                            Image(uiImage: appUser.image!)
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
                    appUser.persistImageToStorage()
                    // appUser.fetchUserImageData()
                    // appUser.fetchUserData()
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
            ImagePicker(image: $appUser.image)
        }
        .onAppear {
            appUser.fetchUserImageData()
        }
    }
    
    init(isAuthenticated: Binding<Bool>) {
            self._isAuthenticated = isAuthenticated
        }

}
