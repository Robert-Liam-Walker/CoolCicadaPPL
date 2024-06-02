import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    
    init(viewModel: WorkoutViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        TabView{
            WorkoutListView(viewModel: viewModel)
            //HistoryView
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: WorkoutViewModel())
    }
}

