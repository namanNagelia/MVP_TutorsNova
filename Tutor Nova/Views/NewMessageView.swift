import SwiftUI

class createNewMessagesViewModel: ObservableObject {
    @Published var users = [AppUser]()

    init() {
        fetchAllUsers()
    }

    private func fetchAllUsers() {
        FirebaseManager.shared.firestore.collection("users").getDocuments { docSnapshot, error in
            if let error = error {
                print("failed to fetch user: \(error)")
                return
            }

            if let documents = docSnapshot?.documents {
                self.users = documents.compactMap { snapshot in
                    let data = snapshot.data()

                    let user = AppUser()
                    user.userid = data["uid"] as? String ?? ""
                    user.profileImgString = data["profileImageUrl"] as? String ?? ""
                    user.firstName = data["firstName"] as? String ?? ""
                    user.lastName = data["lastName"] as? String ?? ""
                    user.email = data["email"] as? String ?? ""

                    return user
                }
            }
        }
    }
}

struct NewMessageView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm = createNewMessagesViewModel()
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            VStack {
                SearchBar(text: $searchText)

                ScrollView {
                    ForEach(filteredUsers) { user in
                        UserCardView(user: user)
                            .padding(.vertical, 16)
                    }
                }
            }
            .padding(.horizontal)
            .navigationTitle("New Message")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
        }
    }

    private var filteredUsers: [AppUser] {
        if searchText.isEmpty {
            return vm.users
        } else {
            return vm.users.filter { user in
                user.email.lowercased().contains(searchText.lowercased()) ||
                user.firstName.lowercased().contains(searchText.lowercased()) ||
                user.lastName.lowercased().contains(searchText.lowercased())
            }
        }
    }
}

struct UserCardView: View {
    let user: AppUser

    var body: some View {
        HStack(spacing: 16) {
            if user.profileImgString.isEmpty {
                Image(systemName: "person.fill")
                    .frame(width: 50, height: 50)
                    .cornerRadius(44)
                    .overlay(RoundedRectangle(cornerRadius: 44)
                        .stroke(Color(.label), lineWidth: 1))
            } else {
                AsyncImage(url: URL(string: "\(user.profileImgString)")) { image in
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

            VStack(alignment: .leading) {
                Text("\(user.firstName) \(user.lastName)")
                    .font(.system(size: 16, weight: .bold))

                Text(user.email)
                    .font(.system(size: 14))
                    .foregroundColor(Color(.secondaryLabel))
            }
            Spacer()
        }
    }
}

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Search users", text: $text)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 8)

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 8)
            }
        }
    }
}

#Preview{
    NewMessageView()
}
