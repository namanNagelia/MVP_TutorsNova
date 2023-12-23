// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let uMDCourses = try? JSONDecoder().decode(UMDCourses.self, from: jsonData)

import Foundation

// MARK: - UMDCourse
struct UMDCourse: Identifiable, Decodable {
    var id: String {
        self.courseID
    }
    let courseID, semester, name: String
    let deptID: DeptID
    let department: Department
    let credits, description: String
    let gradingMethod: [GradingMethod]
    let genEd: [[GenEd]]
    let core: [String]
    let relationships: Relationships
    let sections: [String]

    enum CodingKeys: String, CodingKey {
        case courseID = "course_id"
        case semester, name
        case deptID = "dept_id"
        case department, credits, description
        case gradingMethod = "grading_method"
        case genEd = "gen_ed"
        case core, relationships, sections
    }
}

enum Department: String, Codable {
    case africanAmericanStudies = "African American Studies"
}

enum DeptID: String, Codable {
    case aasp = "AASP"
}

enum GenEd: String, Codable {
    case dshs = "DSHS"
    case dshu = "DSHU"
    case dvup = "DVUP"
    case scis = "SCIS"
}

enum GradingMethod: String, Codable {
    case audit = "Audit"
    case passFail = "Pass-Fail"
    case regular = "Regular"
}

// MARK: - Relationships
struct Relationships: Codable {
    let coreqs: JSONNull?
    let prereqs, formerly, restrictions, additionalInfo: String?
    let alsoOfferedAs: JSONNull?
    let creditGrantedFor: String?

    enum CodingKeys: String, CodingKey {
        case coreqs, prereqs, formerly, restrictions
        case additionalInfo = "additional_info"
        case alsoOfferedAs = "also_offered_as"
        case creditGrantedFor = "credit_granted_for"
    }
}

typealias UMDCourses = [UMDCourse]

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

