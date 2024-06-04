import Foundation
import SwiftUI
/*
class CustomWorkoutViewModel: ObservableObject {
    @Published var workout : Workout
    
    init(){
        workout.date = Date()
        workout.name = "New Workout"
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
        workoutViewModel.workouts.append(workout)
        // save to database as well
        // in workoutViewModel, load workouts from database as append
        // how to differentiate between past workouts and custom workouts? new field in Workout model - workout type
    }
}
*/
