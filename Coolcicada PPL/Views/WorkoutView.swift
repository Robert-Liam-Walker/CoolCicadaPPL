import SwiftUI

struct WorkoutView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    //@ObservedObject var customWorkoutViewModel: CustomWorkoutViewModel
    
    init(viewModel: WorkoutViewModel) {
        self.viewModel = viewModel
        //self.customWorkoutViewModel = CustomWorkoutViewModel()
    }
    
    var body: some View {
        NavigationView {
            /*
            List(viewModel.workouts) { workout in
                NavigationLink(destination: WorkoutDetailsView(viewModel: viewModel, workout: workout)) {
                    Text(workout.name)
                }
                HStack {
                    Button("test") { print("test") }
                }
            }*/
            List{
                ForEach(viewModel.workouts){ workout in
                    NavigationLink(destination: WorkoutDetailsView(viewModel: viewModel, workout: workout)) {
                        Text(workout.name)
                    }
                }
                HStack {
                    NavigationLink(destination: CustomWorkoutView(viewModel: viewModel.customWorkoutViewModel)){
                        Text("Add Custom Workout")
                    }
                }
            }
            .navigationBarTitle("Workouts")
        }
    }
}
