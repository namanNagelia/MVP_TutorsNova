import Firebase
import SwiftUI

// Fix UI
// Fix default PFP to show in new UI
// Fix default in main screen and new message screen
// Fix email color (probably in chat log view)
// MAIN PRIORITY: If someone sends you a message, the message shows up on their end too, and see chatlog when you tap a card
struct FirebaseConstants {
    static let fromID = "fromID"
    static let toID = "toID"
    static let text = "text"
    static let timestamp = "timestamp"
    static let pfpURL = "pfpURL"
    static let email = "email"
    static let firstName = "firstName"
    static let lastName = "lastName"
}

struct ChatMessage: Identifiable {
    var id: String { documentID
    }

    let documentID: String
    let fromID, toID, text: String

    init(documentID: String, data: [String: Any]) {
        self.documentID = documentID
        self.fromID = data[FirebaseConstants.fromID] as? String ?? ""
        self.toID = data[FirebaseConstants.toID] as? String ?? ""
        self.text = data[FirebaseConstants.text] as? String ?? ""
    }
}

struct ChatLogView: View {
    class ChatLogViewModel: ObservableObject {
        @Published var chatText = ""
        @Published var errorMessage = ""
        
        @Published var chatMessages = [ChatMessage]()
        
        let appUser: AppUser?
        
        init(appUser: AppUser?) {
            self.appUser = appUser
            fetchMessages()
        }
        
        func fetchMessages() {
            guard let fromID = FirebaseManager.shared.auth.currentUser?.uid
            else { return }
            guard let toID = appUser?.userid else { return }
            
            FirebaseManager.shared.firestore
                .collection("messages").document(fromID)
                .collection(toID)
                .order(by: "timestamp")
                .addSnapshotListener { querySnapshot, error in
                    if let error = error {
                        print("Failed to listen to messages: \(error)")
                    }
                    querySnapshot?.documentChanges.forEach { change in
                        if change.type == .added {
                            let data = change.document.data()
                            let chatMessageAdder = ChatMessage(documentID: change.document.documentID, data: data)
                            self.chatMessages.append(chatMessageAdder)
                        }
                    }
                    self.count += 1
                }
        }
        
        func handleSend(text: String) {
            chatText = text
            print(text)
            guard let fromID = FirebaseManager.shared.auth.currentUser?.uid else { return }
            
            guard let toID = appUser?.userid else { return }
            
            let document =
                FirebaseManager.shared.firestore
                    .collection("messages")
                    .document(fromID)
                    .collection(toID)
                    .document()
            
            let messageData = [FirebaseConstants.fromID: fromID, FirebaseConstants.toID: toID, FirebaseConstants.text: chatText, "timestamp": Timestamp()] as [String: Any]
            
            document.setData(messageData) { error in
                if let error = error {
                    self.errorMessage = "Failed to save message:  \(error)"
                }
                
                self.persistRecentMessage()
                print("sender Saved")
                self.count += 1
                self.chatText = ""
            }
            let recipientDocument =
                FirebaseManager.shared.firestore
                    .collection("messages")
                    .document(toID)
                    .collection(fromID)
                    .document()
            recipientDocument.setData(messageData) { error in
                if let error = error {
                    self.errorMessage = "Failed to save message:  \(error)"
                }
                print("Recipient saved")
            }
        }
        
        private func persistRecentMessage() {
            //1, If there is no conversation, the recipient will not have a document. We need to add KMP
            
            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
                return
            }
            guard let toID = appUser?.userid else { return }
            
            let document_sender = FirebaseManager.shared.firestore.collection("recent_messages")
                .document(uid)
                .collection("messages")
                .document(toID)
            
            let textMessage = chatText
            
            var data: [String: Any] = [
                FirebaseConstants.timestamp: Timestamp(),
                FirebaseConstants.text: chatText,
                FirebaseConstants.fromID: uid,
                FirebaseConstants.toID: toID,
                FirebaseConstants.pfpURL: appUser?.profileImgString ?? "",
                FirebaseConstants.email: appUser?.email ?? "",
                FirebaseConstants.firstName: appUser?.firstName ?? "",
                FirebaseConstants.lastName: appUser?.lastName ?? ""
            ]
            
            // Check if chatText is not empty before adding it to the data dictionary
            
            document_sender.setData(data) { error in
                if let error = error {
                    print("Failed to save \(error)")
                    return
                }
            }

            
        }
        
        @Published var count = 0
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
                // Header with background
                // Chat Messages
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ScrollViewReader { scrollViewProxy in
                            VStack {
                                ForEach(vm.chatMessages) { message in
                                    MessageView(message: message)
                                }
                                
                                HStack { Spacer() }
                                    .id("Empty")
                            }
                            .onReceive(vm.$count) { _ in
                                withAnimation(.easeOut(duration: 0.5)) {
                                    scrollViewProxy.scrollTo("Empty", anchor:
                                        .bottom)
                                }
                            }
                        }
                    }
                    .padding(.top, 10)
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }
                .background(Color(.white))
                
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
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                    
                    Button(action: {
                        vm.handleSend(text: self.messageText)
                        
                        // Clear the text box after sending
                        self.messageText = ""
                        
                    }) {
                        Image(systemName: "arrow.right.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                    }
                    .padding()
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(leading: EmptyView(), trailing: EmptyView())
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5)
            }
        }
    }
}

struct MessageView: View {
    let message: ChatMessage
    var body: some View {
        VStack {
            if message.fromID == FirebaseManager.shared.auth.currentUser?.uid {
                HStack {
                    Spacer()
                    Text(message.text)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.blue)
                        .cornerRadius(15)
                        .frame(maxWidth: .infinity, alignment: message.fromID == FirebaseManager.shared.auth.currentUser?.uid ? .trailing : .leading)
                }
                .padding(.horizontal, 16)
            } else {
                HStack {
                    Text(message.text)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.gray)
                        .cornerRadius(15)
                        .frame(maxWidth: .infinity, alignment: message.fromID == FirebaseManager.shared.auth.currentUser?.uid ? .trailing : .leading)
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

struct ChatsLogView_preview: PreviewProvider {
    static var previews: some View {
        ChatLogView(appUser: nil)
    }
}
