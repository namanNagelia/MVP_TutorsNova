import SwiftUI

struct ListingsView: View {
    @State private var searchText = ""

    var body: some View {
        VStack {
            // Search Bar
            TextField("Search", text: $searchText)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
            
            // Display search results or content below the search bar
            Text("You searched for: \(searchText)")
                .padding()
            
            Spacer()
        }
        .navigationBarTitle("Search Example", displayMode: .inline)
    }
}

struct ListingsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
