import Foundation

struct Workout: Identifiable {
    var id: UUID
    var name: String
    var date: Date
    var exercises: [Exercise]

    init(id: UUID = UUID(), name: String, date: Date, exercises: [Exercise] = []) {
        self.id = id
        self.name = name
        self.date = date
        self.exercises = exercises
    }
}
