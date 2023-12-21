
import Firebase
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

struct recentMessage: Identifiable {
    var id: String { documentID }
    let documentID: String
    let text, fromID, toID, email, profileImageURL: String
    let timeStamp: Firebase.Timestamp
    
    init(documentID: String, data: [String: Any]) {
        self.documentID = documentID
        self.text = data["text"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.toID = data["toID"] as? String ?? ""
        self.fromID = data["fromID"] as? String ?? ""
        self.profileImageURL = data["pfpURL"] as? String ?? ""
        self.timeStamp = data["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}

class messagesViewModel: ObservableObject {
    @Published var appUser: AppUser?
    @Published var recentMessages = [recentMessage]()
    
    init() {
        fetchUser()
        fetchRecentMessages()
    }
    
    func fetchUser() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            print("Could not find UID")
            return
        }
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("Could not get document: \(error)")
                return
            }
            
            guard let data = snapshot?.data() else {
                print("Could not retrieve data")
                return
            }
            // self.appUser = .init(data: data)
        }
    }
    
    func fetchRecentMessages() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
            
        FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if error != nil {
                    print("failed")
                    return
                }
                    
                querySnapshot?.documentChanges.forEach { change in
                    let docID = change.document.documentID
                        
                    if let index = self.recentMessages.firstIndex(where: { rm in
                        rm.documentID == docID
                    }) {
                        self.recentMessages.remove(at: index)
                    }
                        
                    self.recentMessages.insert(.init(documentID: docID, data: change.document.data()), at: 0)
                }
            }
    }
}

struct ChatsView: View {
    @State var shouldShowLogOutOptions = false
    @EnvironmentObject var appUser: AppUser
    @State var shouldNavigatetoChatLog = false
    @ObservedObject var vm = messagesViewModel()

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
        NavigationStack {
            VStack {
                customNavBar
                messagesView
                
                // NavigationLink("", isActive: $shouldNavigatetoChatLog) {
                // ChatLogView(appUser: self.chatUser)
                
                // }
            }
            .overlay(newMessageButton, alignment: .bottom)
            .navigationDestination(isPresented: $shouldNavigatetoChatLog) {
                ChatLogView(appUser: self.chatUser)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text(self.chatUser?.email ?? "")
                                .font(.headline) // Set the desired font size
                        }
                    }
            }
        }.background(Color(.white))
    }
    private func timeAgoString(from timestamp: Timestamp) -> String {
        let calendar = Calendar.current
        let now = Date()
        let messageDate = timestamp.dateValue()

        if calendar.isDateInToday(messageDate) {
            let components = calendar.dateComponents([.minute], from: messageDate, to: now)
            if let minutes = components.minute, minutes < 60 {
                return "\(minutes) min ago"
            } else {
                return "Today"
            }
        } else if calendar.isDateInYesterday(messageDate) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            return formatter.string(from: messageDate)
        }
    }


    
    private var messagesView: some View {
        ScrollView {
            ForEach(vm.recentMessages) { recentMessage in
                VStack {
                    NavigationLink {} label: {
                        HStack(spacing: 16) {
                            // fix this
                            
                            if recentMessage.profileImageURL.isEmpty {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 32))
                                    .padding(8)
                                    .overlay(RoundedRectangle(cornerRadius: 44)
                                                   .stroke(Color.black, lineWidth: 1))
                                               .accentColor(.black) // Set the accent color for the image

                            }
                            else {
                                AsyncImage(url: URL(string: "\(recentMessage.profileImageURL)")) {
                                    image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                
                                //resize to same as top
                                .frame(width: 50, height: 50) // Match the size dynamically
                                        .cornerRadius(44)
                                        .overlay(RoundedRectangle(cornerRadius: 44)
                                            .stroke(Color(.label), lineWidth: 1))
                            }

                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(recentMessage.email)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color(.label))
                                Text(recentMessage.text)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(.lightGray))
                                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/ .leading/*@END_MENU_TOKEN@*/)
                            }
                            Spacer()
                            
                            Text(timeAgoString(from: recentMessage.timeStamp))
                                                        .font(.system(size: 14, weight: .semibold))

                        }
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
        .fullScreenCover(isPresented: $newMessageScreen) {
            NewMessageView(didSelectNewUser: { user in
                print(user.email)
                self.shouldNavigatetoChatLog.toggle()
                self.chatUser = user
                
            }, currentUser: appUser)
        }
    }
    
    @State var chatUser: AppUser?
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
