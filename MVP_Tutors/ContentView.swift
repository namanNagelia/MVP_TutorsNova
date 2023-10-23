import SwiftUI
struct ContentView: View {
    @State private var selectedTab = 1
    @Environment(\.colorScheme) var colorScheme
    @State private var isProfileView = false
    @State private var isAuthenticated = false

    var body: some View {
        VStack {
            HStack {
                Button(action: {}) {
                    Image(systemName: "gear")
                        .resizable()
                        .frame(width: 30.0, height: 30.0)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                }
                Spacer()

                Button(action: {}) {
                    Image(systemName: "bell.fill")
                        .resizable()
                        .frame(width: 30.0, height: 30.0)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                }

                Button(action: { isProfileView = true }) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding(.trailing, 16)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                }
            }
            .padding(.leading, 15.0)
            .frame(height: 30.0)

            .sheet(isPresented: $isProfileView) {
                ProfileView(isAuthenticated: $isAuthenticated)
            }

            // tabs
            TabView(selection: $selectedTab) {
                TutorNowView()
                    .tabItem {
                        Image(systemName: "graduationcap.fill")
                        Text("Tutoring")
                    }.tag(0)

                ListingsView()
                    .tabItem {
                        Image(systemName: "list.bullet")
                        Text("Listings")
                    }.tag(1)

                ChatsView()
                    .tabItem {
                        Image(systemName: "message.fill")
                        Text("Chats")
                    }.tag(2)
            }
            .onAppear {
                selectedTab = 1
            }
        }
    }
}

#Preview {
    ContentView()
}
