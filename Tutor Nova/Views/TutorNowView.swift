import SwiftUI

struct TutorNowView: View {
    @ObservedObject var appUserInstance: appUser  // Assuming you have an @ObservedObject for your appUser

    var body: some View {
        VStack {
            Text("Tutoring Page")
                .font(.largeTitle)
                .padding()

            if !appUserInstance.userid.isEmpty {
                Text("User ID: \(appUserInstance.userid)")
            }
            else{
                Text("No Image")
            }

            if !appUserInstance.profileImgString.isEmpty {
                Text("Profile Image URL: \(appUserInstance.profileImgString)")
            }
            else{
                Text("No Image")
            }
        }
    }
}
