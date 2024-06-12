import Combine
import Foundation

class WorkoutViewModel: ObservableObject {
    @Published var workouts: [Workout] = []
    private var cancellables = Set<AnyCancellable>()
    
    // Publisher to signal
    let workoutSaved = PassthroughSubject<Void, Never>()
    
    let customWorkoutViewModel: CustomWorkoutViewModel
    
    init(customWorkoutViewModel : CustomWorkoutViewModel) {
        self.customWorkoutViewModel = customWorkoutViewModel
        loadWorkouts()
        //fetchCustomWorkouts()
        setupSubscriptions()
    }
    
    func loadWorkouts() {
        var pushExercises = [
            Exercise(name: "Flat Barbell Bench Press", sets: 3, reps: "5", weight: 0),
            Exercise(name: "Seated (or Standing) Barbell Shoulder/Overhead Press", sets: 3, reps: "5", weight: 0),
            Exercise(name: "Incline Barbell Bench Press", sets: 3, reps: "5", weight: 0),
            Exercise(name: "Dumbbell Side Lateral Raise", sets: 3, reps: "10-12", weight: 0),
            Exercise(name: "Rope Pushdowns (circuit machine)", sets: 3, reps: "10-12", weight: 0),
            Exercise(name: "Overhead Dumbbell Extension or similar triceps exercise", sets: 3, reps: "10-12", weight: 0)
        ]
        
        var pullExercises = [
            Exercise(name: "Barbell Rows", sets: 3, reps: "5 (or Deadlifts 3x5)", weight: 0),
            Exercise(name: "Lat Pulldowns", sets: 3, reps: "8-10", weight: 0),
            Exercise(name: "Seated Rows", sets: 3, reps: "8-10", weight: 0),
            Exercise(name: "Face-pulls", sets: 3, reps: "10-12", weight: 0),
            Exercise(name: "Shrugs (circuit machine or dumbbells)", sets: 3, reps: "10-12", weight: 0),
            Exercise(name: "Barbell Bicep Curls (Alternate between close and normal grip)", sets: 4, reps: "10-12", weight: 0),
            Exercise(name: "Choice of one other bicep exercise (typically Hammer Curls)", sets: 3, reps: "10-12", weight: 0)
        ]
        
        var legsExercises = [
            Exercise(name: "Barbell Squats", sets: 4, reps: "5-6", weight: 0),
            Exercise(name: "Leg Press (optional if already doing above squats)", sets: 3, reps: "8-10", weight: 0),
            Exercise(name: "Leg Extensions (circuit machine)", sets: 3, reps: "10-12", weight: 0),
            Exercise(name: "Hamstring Curls (circuit machine)", sets: 3, reps: "10-12", weight: 0),
            Exercise(name: "Standing Calf Raises (circuit machine)", sets: 5, reps: "10-12", weight: 0)
        ]
        
        workouts = [
            Workout(name: "Push (Chest/Triceps/Shoulders)", type: "default", date: Date(), exercises: pushExercises),
            Workout(name: "Pull (Back/Biceps)", type: "default", date: Date(), exercises: pullExercises),
            Workout(name: "Legs (Quad/Ham/Calves)", type: "default", date: Date(), exercises: legsExercises)
        ]
        fetchCustomWorkouts()
        //print("WorkoutViewModel loading custom workouts")
        //print(SQLiteDatabase.shared.fetchCustomWorkouts())
        //workouts.append(contentsOf: SQLiteDatabase.shared.fetchCustomWorkouts())
    }
    
    func getWorkout(by id: UUID) -> Workout? {
        return workouts.first { $0.id == id }
    }
    
    func updateWeight(for exerciseId: UUID, weight: Int) {
        for workoutIndex in workouts.indices {
            if let exerciseIndex = workouts[workoutIndex].exercises.firstIndex(where: { $0.id == exerciseId }) {
                var updatedExercise = workouts[workoutIndex].exercises[exerciseIndex]
                updatedExercise.weight = weight
                workouts[workoutIndex].exercises[exerciseIndex] = updatedExercise
                print("exercise updated", updatedExercise, "weight", weight)
                objectWillChange.send()
            }
        }
    }
    
    func saveWorkout(_ workout: Workout) {
        let updatedWorkout = Workout(name: workout.name, type: "history", date: Date(), exercises: workout.exercises)

        if let workoutIdString = SQLiteDatabase.shared.insertWorkout(updatedWorkout),
           let workoutId = UUID(uuidString: workoutIdString) {
            for exercise in updatedWorkout.exercises {
                _ = SQLiteDatabase.shared.insertExercise(exercise, forWorkoutId: workoutId)
            }
        }
        print("Workout saved in WorkoutViewModel")
        print("Workout type in WorkoutViewModel: ", updatedWorkout)
        workoutSaved.send()
    }
    
    func deleteWorkout(_ workout: Workout) {
        if let index = workouts.firstIndex(where: { $0.id == workout.id }) {
            workouts.remove(at: index)
            SQLiteDatabase.shared.deleteWorkout(workout.id)
            objectWillChange.send()
        }
    }
    
    func fetchCustomWorkouts() {
        let newCustomWorkouts = SQLiteDatabase.shared.fetchCustomWorkouts()
        
        // Filter out custom workouts from the current list
        workouts.removeAll { $0.type == "custom" }
        
        // Append the new custom workouts
        workouts.append(contentsOf: newCustomWorkouts)
        
        objectWillChange.send()  // Notify the view of the change
    }

    
    private func setupSubscriptions() {
        print("WorkoutViewModel received customWorkoutViewModel.workoutSaved")
        customWorkoutViewModel.workoutSaved
            .sink { [weak self] _ in
                self?.fetchCustomWorkouts() // Fetch updated workout history when a workout is saved
            }
            .store(in: &cancellables)
    }
}
