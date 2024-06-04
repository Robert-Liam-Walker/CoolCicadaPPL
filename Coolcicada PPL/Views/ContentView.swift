import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    
    init(viewModel: WorkoutViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        TabView{
            WorkoutView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Workouts")
                }
            WorkoutHistoryView(viewModel: WorkoutHistoryViewModel(workoutViewModel: viewModel))
                .tabItem {
                    Image(systemName: "clock")
                    Text("History")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: WorkoutViewModel())
    }
}

