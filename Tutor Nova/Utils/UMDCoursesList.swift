// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let uMDCoursesList = try? JSONDecoder().decode(UMDCoursesList.self, from: jsonData)

import Foundation

// MARK: - UMDCoursesListElement
struct UMDCoursesListElement: Identifiable, Codable {
    var id: String {
        self.courseID
    }
    let courseID, name: String

    enum CodingKeys: String, CodingKey {
        case courseID = "course_id"
        case name
    }
}

typealias UMDCoursesList = [UMDCoursesListElement]
