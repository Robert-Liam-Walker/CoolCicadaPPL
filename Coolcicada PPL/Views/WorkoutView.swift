import SwiftUI

struct WorkoutView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    
    init(viewModel: WorkoutViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.workouts) { workout in
                    HStack {
                        NavigationLink(destination: WorkoutDetailsView(viewModel: viewModel, workout: workout)) {
                            Text(workout.name)
                        }
                        Spacer()
                        Button(action: {
                            viewModel.deleteWorkout(workout)
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 14)) // Adjust the font size here
                                .foregroundColor(.blue)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                NavigationLink(destination: CustomWorkoutView(viewModel: viewModel.customWorkoutViewModel)) {
                    Text("Add Custom Workout")
                }
            }
            .navigationBarTitle("Workouts")
        }
    }
}
