import Foundation
import SwiftUI
import Combine

class CustomWorkoutViewModel: ObservableObject {
    @Published var workout : Workout
    
    // Publisher to signal
    let workoutSaved = PassthroughSubject<Void, Never>()
    
    init(){
        print("CustomWorkoutViewModel being initialized")
        workout = Workout(name: "New Workout", type: "custom", date: Date(), exercises: [])
    }
    
    func modifyTitle(_ title : String) {
        workout.name = title
        print("Title modified: ", workout.name)
    }
    
    func addExercise(_ exercise : Exercise) {
        workout.exercises.append(exercise)
        print("Exercise added: ", workout.exercises.last)
    }
    
    func removeExercise(_ exercise : Exercise) {
        // remove by exercise id
        // way to do this in O(1)?
    }
    
    func saveWorkout() {
        print("CustomWorkoutViewModel saveWorkout func")
        print("CustomWorkoutViewModel - exercises", workout.exercises)

        if let workoutIdString = SQLiteDatabase.shared.insertWorkout(workout),
           let workoutId = UUID(uuidString: workoutIdString) {
            for exercise in workout.exercises {
                _ = SQLiteDatabase.shared.insertExercise(exercise, forWorkoutId: workoutId)
            }
        }
        workoutSaved.send()
        print("CustomWorkoutViewModel sent workoutSaved.send()")
    }
}

