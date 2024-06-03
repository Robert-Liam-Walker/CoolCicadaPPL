import SwiftUI

struct WorkoutHistoryView: View {
    @ObservedObject var viewModel: WorkoutHistoryViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.workoutHistory) { workout in
                NavigationLink(destination: WorkoutDetailsView(workout: workout)) {
                    Text(workout.name)
                }
            }
            .navigationBarTitle("Workout History")
        }
    }
}
