import SwiftUI

struct WorkoutView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    let workout: Workout
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(workout.exercises) { exercise in
                ExerciseView(viewModel: viewModel, exercise: exercise)
            }
        }
        .padding()
        .navigationBarTitle(workout.name, displayMode: .inline)
    }
}
