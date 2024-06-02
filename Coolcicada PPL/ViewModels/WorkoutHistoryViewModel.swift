import Foundation
import Combine

class WorkoutHistoryViewModel: ObservableObject {
    @Published var workoutHistory: [Workout] = []
    private var cancellables = Set<AnyCancellable>()
    
    let workoutViewModel: WorkoutViewModel
    
    init(workoutViewModel: WorkoutViewModel) {
        self.workoutViewModel = workoutViewModel
        fetchWorkoutHistory()
        setupSubscriptions()
    }
    
    func fetchWorkoutHistory() {
        workoutHistory = SQLiteDatabase.shared.fetchWorkouts()
        print("workouthistoryviewmodel fetched workout history")
    }

    // Function to delete a saved workout
    func deleteSavedWorkout(at index: Int) {
        // to be implemented
    }
    
    private func setupSubscriptions() {
        // Subscribe to workoutSaved publisher in WorkoutViewModel
        workoutViewModel.workoutSaved
            .sink { [weak self] _ in
                self?.fetchWorkoutHistory() // Fetch updated workout history when a workout is saved
            }
            .store(in: &cancellables)
    }
}
