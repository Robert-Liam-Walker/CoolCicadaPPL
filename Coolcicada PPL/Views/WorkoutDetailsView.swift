import SwiftUI

struct WorkoutDetailsView: View {
    let workout: Workout

    var body: some View {
        List {
            ForEach(workout.exercises) { exercise in
                ExerciseRowView(exercise: exercise)
            }
        }
        .navigationBarTitle("Workout Details")
    }
}

struct ExerciseRowView: View {
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
