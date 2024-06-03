import Foundation

struct Exercise: Identifiable {
    var id: UUID
    var name: String
    var sets: Int
    var reps: String
    var weight: Int

    init(id: UUID = UUID(), name: String, sets: Int, reps: String, weight: Int) {
        self.id = id
        self.name = name
        self.sets = sets
        self.reps = reps
        self.weight = weight
    }
}
