import SwiftUI

struct Course {
    let course_id: String
    let semester: String
    let name: String
    let dept_id: String
    let department: String
    let credits: String
    let description: String
}

struct ListingsView: View {
    @State private var searchText = ""
    @EnvironmentObject var appUser: AppUser
    
    var filteredCourses: UMDCourses {
        if searchText.isEmpty {
            return appUser.courses
        } else {
            return appUser.courses.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        
    }
    
    func fetchDataFromAPI() {
        
    }
    
    func fetchCourses() {
        
    }
    
    
    var body: some View {
        VStack {
            // Search Bar
            TextField("Search", text: $searchText)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
            
            // List of Course Panels
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(filteredCourses) { course in
                        CoursePanel(course: course)
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .navigationBarTitle("Course Listings", displayMode: .inline)
    }
}

struct CoursePanel: View {
    @State private var isExpanded = false
    let course: UMDCourse
    
    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(course.name)
                        .font(.title)
                        .foregroundColor(.primary)
                        .padding(.trailing, 10) // Add padding to the right of the course name
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                        .font(.system(size: 20)) // Reduce the size of the arrow
                        .foregroundColor(.white)
                }
                .padding(10) // Add padding around the button
            }
            
            if isExpanded {
                /*
                 ForEach(course.tutors, id: \.self) { tutor in
                 HStack {
                 Text("Tutor: \(tutor)")
                 .padding(.leading, 10.0)
                 // Add action later
                 Spacer()
                 Button(action: {}) {
                 Image(systemName: "person.circle.fill").foregroundColor(.gray)
                 }
                 Button(action: {}) {
                 Image(systemName: "message.fill").foregroundColor(.gray)
                 }
                 }
                 }
                 */
            }
        }.background(Color(.systemGray6))
            .cornerRadius(15) // Increase the corner radius for a more rounded look
            .padding(10)
    }
    
    
}

#Preview {
    ContentView()
}
