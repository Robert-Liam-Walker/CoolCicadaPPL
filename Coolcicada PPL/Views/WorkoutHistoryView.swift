import SwiftUI

struct WorkoutHistoryView: View {
    @ObservedObject var viewModel: WorkoutHistoryViewModel
    
    init(viewModel: WorkoutHistoryViewModel) {
        self.viewModel = viewModel
        viewModel.fetchSavedWorkouts() // Call fetchSavedWorkouts() in the init
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.savedWorkouts, id: \.name) { savedWorkout in
                    VStack(alignment: .leading) {
                        Text(savedWorkout.name)
                            .font(.headline)
                        Text("\(savedWorkout.date)")
                            .font(.subheadline)
                    }
                }
                .navigationBarTitle("Workout History")
                .navigationBarItems(trailing:
                    Button(action: {
                        // Action to perform when the "+" button is tapped
                        // You can implement logic to add a new workout here
                        print("Add workout button tapped")
                    }) {
                        Image(systemName: "plus")
                    }
                )
            }
        }
    }
}
