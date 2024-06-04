import SwiftUI

struct WorkoutHistoryView: View {
    @ObservedObject var viewModel: WorkoutHistoryViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.workoutHistory) { workout in
                NavigationLink(destination: WorkoutHistoryDetailsView(workout: workout)) {
                    VStack(alignment: .leading) {
                        Text(workout.name)
                            .font(.headline)
                        Text("\(workout.date, formatter: dateFormatter)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationBarTitle("Workout History")
        }
    }
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}
