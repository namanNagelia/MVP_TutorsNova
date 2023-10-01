import SwiftUI

struct Course: Identifiable {
    let id = UUID()
    let name: String
    var isExpanded = false
    var tutors: [String]
}

struct ListingsView: View {
    @State private var searchText = ""
    @State private var courses: [Course] = [
        Course(name: "BMGT110", tutors: ["Tutor1", "Tutor2", "Tutor3"]),
        Course(name: "MATH140", tutors: ["Tutor4", "Tutor5"]),
        Course(name: "MATH120", tutors: ["Tutor6"]),
        Course(name: "MATH340", tutors: ["Tutor7", "Tutor8"]),
        Course(name: "CMSC132", tutors: ["Tutor9", "Tutor10"]),
        // Connect to UMD and get all courses
    ]

    var filteredCourses: [Course] {
        if searchText.isEmpty {
            return courses
        } else {
            return courses.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
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
    let course: Course

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
                        .foregroundColor(.blue)
                }
                .padding(10) // Add padding around the button
            }
            
            if isExpanded {
                ForEach(course.tutors, id: \.self) { tutor in
                    Text("Tutor: \(tutor)")
                        .padding(.leading, 20) // Adjust the leading padding for tutors
                }
            }
        }
        .background(Color(.systemGray6))
        .cornerRadius(15) // Increase the corner radius for a more rounded look
        .padding(10) // Add padding around the entire panel
    }
}

#Preview{
    ContentView()
}
