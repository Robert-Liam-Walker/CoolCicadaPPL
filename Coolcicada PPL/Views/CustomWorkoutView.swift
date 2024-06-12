import SwiftUI
import Combine

struct CustomWorkoutView: View {
    @ObservedObject var viewModel: CustomWorkoutViewModel
    
    @State private var exerciseName: String = ""
    @State private var sets: String = ""
    @State private var reps: String = ""
    
    @State private var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.workout.exercises) { exercise in
                    VStack{
                        Text(exercise.name).font(.headline).frame(maxWidth: .infinity, alignment: .leading)
                        HStack{
                            Text("\(exercise.sets)").font(.subheadline)
                            if exercise.sets == 1 {
                                Text("set")
                            }
                            else{
                                Text("sets")
                            }
                            Spacer()
                            Text(exercise.reps)
                            if exercise.reps == "1" {
                                Text("rep")
                            }
                            else{
                                Text("reps")
                            }
                        }
                    }
                }
                VStack{
                    TextField("Exercise", text: $exerciseName).font(.headline)
                    HStack {
                        TextField("Sets", text: $sets).font(.subheadline)
                        Spacer()
                        TextField("Reps", text: $reps).font(.subheadline).multilineTextAlignment(.trailing)
                    }
                    Button(action: addExercise) {
                        Text("Add Exercise").font(.subheadline)
                    }
                }
            }
            .padding()
        }
        .navigationBarTitle(viewModel.workout.name, displayMode: .inline)
        .navigationBarItems(trailing:
            Button(action: {
                print("Save button tapped for new workout: \(viewModel.workout.name)")
                viewModel.saveWorkout()
            }) {
                Text("Save")
                    .padding(8)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        )
        .onReceive(viewModel.workoutSaved) { _ in
            resetViewModel()
        }
    }
    
    func addExercise() {
        guard let setsInt = Int(sets) else { return }
        let exercise = Exercise(name: exerciseName, sets: setsInt, reps: reps, weight: 0)
        viewModel.addExercise(exercise)
        
        // Clear input fields
        exerciseName = ""
        sets = ""
        reps = ""
    }
    
    func resetViewModel() {
        // Create a new view model to reset the state
        let newViewModel = CustomWorkoutViewModel()
        viewModel.workout = newViewModel.workout
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            CustomWorkoutView(viewModel: CustomWorkoutViewModel())
        }
    }
}
