import SwiftUI

struct WorkoutHistoryDetailsView: View {
    let workout: Workout

    var body: some View {
        List {
            ForEach(workout.exercises) { exercise in
                ExerciseHistoryRowView(exercise: exercise)
            }
        }
        .navigationBarTitle("Workout Details")
    }
}

struct ExerciseHistoryRowView: View {
    let exercise: Exercise
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(exercise.name)
                .font(.headline)
            Text("Sets: \(exercise.sets)")
            Text("Reps: \(exercise.reps)")
            Text("Weight: \(exercise.weight)")
        }
    }
}
