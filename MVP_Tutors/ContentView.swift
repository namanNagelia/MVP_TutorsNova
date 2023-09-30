import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 1
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        //Top Navigator test
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
                    
                    Button(action: {}) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding(.trailing, 16)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                }
                .padding(.leading, 15.0)
                .frame(height: 30.0)
        Spacer()

        
        //tabs
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
            selectedTab=1
        }
        
       

    }
}



#Preview{
    ContentView()
}
