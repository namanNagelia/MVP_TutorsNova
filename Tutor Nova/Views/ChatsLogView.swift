import SwiftUI

struct ChatLogView: View {
    @Environment(\.presentationMode) var presentationMode
    let appUser: AppUser?
    @State private var messageText = ""

    var body: some View {
        NavigationView {
            VStack {
                // Custom Top Bar
                HStack {
                    Text(appUser?.email ?? "")
                        .font(.headline)
                        .padding(.trailing, 10)
                }
                .padding()
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                .zIndex(1) // Ensure the shadow is above other views

                // Chat Messages
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(0..<10) { num in
                            HStack {
                                    Spacer()
                                
                                //Logic to display current messages
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
                        // Implement your logic to send a message
                    }) {
                        Image(systemName: "arrow.right.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ChatsLogView_preview: PreviewProvider {
    static var previews: some View {
        ChatLogView(appUser: nil)
    }
}
