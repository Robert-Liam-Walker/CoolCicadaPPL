import Foundation

class WorkoutHistoryViewModel: ObservableObject {
    @Published var savedWorkouts: [SavedWorkout] = []
    
    init() {
        fetchSavedWorkouts()
        
    }
    
    func fetchSavedWorkouts() {
        savedWorkouts = [
                    SavedWorkout(name: "Workout 1", date: Date(), exercises: []),
                    SavedWorkout(name: "Workout 2", date: Date(), exercises: []),
                    SavedWorkout(name: "Workout 3", date: Date(), exercises: [])
                ]
    }
    
    // Function to delete a saved workout
    func deleteSavedWorkout(at index: Int) {
        
    }
}
