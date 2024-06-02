import SwiftUI

struct WorkoutHistoryView: View {
    @ObservedObject var viewModel: WorkoutHistoryViewModel
    
    var body: some View {
        List(viewModel.workoutHistory) { workout in
            VStack(alignment: .leading) {
                Text(workout.name)
                // Display additional workout details as needed
            }
        }
        .navigationBarTitle("Workout History")
    }
}
