import SwiftUI
import Firebase

struct ChatLogView: View {
    class ChatLogViewModel: ObservableObject {
        @Published var chatText = ""
        @Published var errorMessage = ""
        
        let appUser: AppUser?
        
        init(appUser: AppUser?) {
            self.appUser = appUser
        }

        func handleSend(text: String) {
            chatText = text
            print(text)
            guard let fromID = FirebaseManager.shared.auth.currentUser?.uid else {return}
            
            guard let toID = appUser?.userid else {return}
            
            let document =
            FirebaseManager.shared.firestore
                .collection("messages")
                .document(fromID)
                .collection(toID)
                .document()
            
            let messageData = ["fromID": fromID, "toID": toID, "text": self.chatText, "timestamp": Timestamp()] as [String : Any]
            
            document.setData(messageData) { error in
                if let error = error{
                    self.errorMessage = "Failed to save message:  \(error)"
                }}
        }
    }

    @Environment(\.presentationMode) var presentationMode
    let appUser: AppUser?

    init(appUser: AppUser?) {
        self.appUser = appUser
        self.vm = .init(appUser: appUser)
    }

    
    @State private var messageText = ""
    @ObservedObject var vm: ChatLogViewModel

    var body: some View {
        NavigationView {
            VStack {
                // Chat Messages
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(0..<10) { num in
                            HStack {
                                Spacer()

                                // Logic to display current messages
                                Text("Fake Message")
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color.blue)
                                    .cornerRadius(15)
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    .padding(.top, 10)
                    .onTapGesture {
                        // Hide keyboard when tapped outside the TextField
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }
                .background(Color(.lightGray))

                // Bottom Bar with Chat and Send Message UI
                HStack {
                    Button(action: {
                        // Implement your logic for adding an image
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                    }
                    .padding()

                    TextField("Type a message...", text: $messageText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(8)
                        .cornerRadius(15) // Rounder corners
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.blue, lineWidth: 1)
                        )

                    Button(action: {
                        vm.handleSend(text: self.messageText)
                    }) {
                        Image(systemName: "arrow.right.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                    }
                    .padding()
                }
            }
            .navigationBarTitle(appUser?.email ?? "", displayMode: .inline)
        }
    }
}

struct ChatsLogView_preview: PreviewProvider {
    static var previews: some View {
        ChatLogView(appUser: nil)
    }
}
