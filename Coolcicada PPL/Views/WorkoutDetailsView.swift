import SwiftUI

struct WorkoutDetailsView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    var workout: Workout
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading) {
                ForEach(workout.exercises) { exercise in
                    ExerciseView(viewModel: viewModel, exercise: exercise)
                }
            }
            .padding()
        }
        .navigationBarTitle(workout.name, displayMode: .inline)
        .navigationBarItems(trailing:
            Button(action: {
                print("Save button tapped for workout: \(workout.name)")
                viewModel.saveWorkout(workout)
            }) {
                Text("Save")
                    .padding(8)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        )
    }
}
