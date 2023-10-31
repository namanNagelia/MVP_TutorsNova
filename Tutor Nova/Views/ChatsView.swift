
import FirebaseAuth
import SwiftUI
import Firebase
import FirebaseFirestore

struct ChatsView: View {
    
    @State var shouldShowLogOutOptions = false
    @EnvironmentObject var appUser: AppUser
    
    private var customNavBar: some View {
        HStack(spacing: 16) {
            //Fix loading and make it the default, and fix resizing. If, person.fill, else...
            AsyncImage(url: URL(string: "\(appUser.profileImgString )")){
                image in
                image.resizable()
            } placeholder:{
                ProgressView()
            }
            .frame(width:50, height:50)
            .cornerRadius(44)
            .overlay(RoundedRectangle(cornerRadius: 44)
                .stroke(Color(.label), lineWidth: 1)
            )

            
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
            ForEach(0..<10, id: \.self) { num in
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
    
    private var newMessageButton: some View {
        Button {
            
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
    }
}


#Preview {
    ChatsView()
}

