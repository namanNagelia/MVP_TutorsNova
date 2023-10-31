//
//  AppUser.swift
//  Tutor Nova
//
//  Created by Manas Nagelia on 10/30/23.
//

import SwiftUI
import Firebase

class AppUser: ObservableObject{
    @Published var userid: String = ""
    @Published var profileImgString: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var image: UIImage?
    @Published var user: User?
    
    public func fetchUserData() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            print("Could not fetch user data. User is not logged in")
            return
        }
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("Failed to fetch current user: ", error)
                return
            }
            
            guard let data = snapshot?.data() else {
                print("No data found while fetching for user's data")
                return
            }
            
            print(data)
            
            self.profileImgString = data["profileImageUrl"] as? String ?? ""
            self.userid = data["uid"] as? String ?? ""
            self.firstName = data["firstName"] as? String ?? ""
            self.lastName = data["lastName"] as? String ?? ""
            self.email = data["email"] as? String ?? ""
            
            if let url = URL(string: self.profileImgString) {
                URLSession.shared.dataTask(with: url) { data, _, error in
                    if let error = error {
                        print("Failed to load image data: \(error)")
                        return
                    }
                }.resume()
            }
        }
    }
    
    public func fetchUserImageData() {
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
            
            self.profileImgString = data["profileImageUrl"] as? String ?? ""
            
            if let url = URL(string: self.profileImgString) {
                URLSession.shared.dataTask(with: url) { data, _, error in
                    if let error = error {
                        print("Failed to load image data: \(error)")
                        return
                    }
                    
                    if let data = data, let uiImage = UIImage(data: data) {
                        print("Yes")
                        DispatchQueue.main.async {
                            self.image = uiImage
                        }
                    }
                }.resume()
            }
        }
    }
    
    public func persistImageToStorage() {
        // checks if logged in user has a UID
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid
        else { print("Cannot persist image in storage due to user not being logged in"); return }
        
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
                
                self.updateUserProfileUrl(imageProfileUrl: url) // adds it to FireStore
                self.profileImgString = url.absoluteString
            }
        }
    }
    
    private func updateUserProfileUrl(imageProfileUrl: URL) {
        // Checks if logged in user has UID
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            print("Cannot update user's profile URL in database due to no logged in user")
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

}
