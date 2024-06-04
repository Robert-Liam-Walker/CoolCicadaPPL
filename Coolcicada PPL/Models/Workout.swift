import Foundation

struct Workout: Identifiable {
    var id: UUID
    var name: String
    var type: String // default, custom, or history
    var date: Date
    var exercises: [Exercise]

    init(id: UUID = UUID(), name: String, type: String = "default", date: Date, exercises: [Exercise] = []) {
        self.id = id
        self.name = name
        self.type = type
        self.date = date
        self.exercises = exercises
    }
}
