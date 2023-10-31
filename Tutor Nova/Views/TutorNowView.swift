import SwiftUI

struct TutorNowView: View {
    @EnvironmentObject var appUser: AppUser
    
    var body: some View {
        VStack {
            Text("Tutoring Page")
                .font(.largeTitle)
                .padding()

            if !appUser.userid.isEmpty {
                Text("User ID: \(appUser.userid)")
                Text("\(appUser.firstName) \(appUser.lastName)")
            }
            else{
                Text("No Image")
            }

            if !appUser.profileImgString.isEmpty {
                Text("Profile Image URL: \(appUser.profileImgString)")
            }
            else{
                Text("No Image")
            }
        }
    }
}
