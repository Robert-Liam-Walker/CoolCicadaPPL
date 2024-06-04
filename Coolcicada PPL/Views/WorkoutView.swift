import SwiftUI

struct WorkoutView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    
    init(viewModel: WorkoutViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            List(viewModel.workouts) { workout in
                NavigationLink(destination: WorkoutDetailsView(viewModel: viewModel, workout: workout)) {
                    Text(workout.name)
                }
            }
            .navigationBarTitle("Workouts")
        }
    }
}
