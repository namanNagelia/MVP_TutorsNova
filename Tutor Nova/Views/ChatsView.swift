
import Firebase
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

struct ChatsView: View {
    @State var shouldShowLogOutOptions = false
    @EnvironmentObject var appUser: AppUser
    
    private var customNavBar: some View {
        HStack(spacing: 16) {
            if appUser.profileImgString.isEmpty {
                Image(systemName: "person.fill")
                    .font(.system(size: 34, weight: .heavy))
            }
            else {
                AsyncImage(url: URL(string: "\(appUser.profileImgString)")) {
                    image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 50, height: 50)
                .cornerRadius(44)
                .overlay(RoundedRectangle(cornerRadius: 44)
                    .stroke(Color(.label), lineWidth: 1)
                )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(appUser.firstName) \(appUser.lastName)")
                    .font(.system(size: 24, weight: .bold))
                
                HStack {
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 14, height: 14)
                    Text("online")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.lightGray))
                }
            }
            
            Spacer()
        }
        .padding()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                customNavBar
                messagesView
            }
            .overlay(
                newMessageButton, alignment: .bottom)
            .navigationBarHidden(true)
        }
    }
    
    private var messagesView: some View {
        ScrollView {
            ForEach(0 ..< 10, id: \.self) { _ in
                VStack {
                    HStack(spacing: 16) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 32))
                            .padding(8)
                            .overlay(RoundedRectangle(cornerRadius: 44)
                                .stroke(Color(.label), lineWidth: 1)
                            )
                        
                        VStack(alignment: .leading) {
                            Text("Username")
                                .font(.system(size: 16, weight: .bold))
                            Text("Message sent to user")
                                .font(.system(size: 14))
                                .foregroundColor(Color(.lightGray))
                        }
                        Spacer()
                        
                        Text("22d")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    Divider()
                        .padding(.vertical, 8)
                }.padding(.horizontal)
                
            }.padding(.bottom, 50)
        }
    }
    
    @State var newMessageScreen = false
    private var newMessageButton: some View {
        Button {
            newMessageScreen.toggle()
        } label: {
            HStack {
                Spacer()
                Text("+ New Message")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.vertical)
            .background(Color.blue)
            .cornerRadius(32)
            .padding(.horizontal)
            .shadow(radius: 15)
        }
        .fullScreenCover(isPresented: $newMessageScreen){
            NewMessageView()
        }
    }
}

struct ChatsView_Previews: PreviewProvider {
    static var previews: some View {
        // Create an instance of AppUser
        let appUser = AppUser()
        
        
        // Return your ChatsView with the AppUser set as an environment object
        return ChatsView()
            .environmentObject(appUser)
    }
}

