import SwiftUI

struct ExerciseView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @State private var weightText: String = ""
    var exercise: Exercise
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(exercise.name)
                .font(.headline)
            Text("\(exercise.sets) sets of \(exercise.reps)")
                .font(.subheadline)
            
            HStack {
                Text("Weight: ")
                TextField("Enter weight", text: $weightText, onCommit: {
                    if let weight = Int(weightText) {
                        print("Weight updated in ExerciseView:", weight)
                        viewModel.updateWeight(for: exercise.id, weight: weight)
                    }
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
            }
        }
        .padding()
        .onAppear {
            weightText = "" // Set weightText to empty string
            if exercise.weight != 0 {
                weightText = String(exercise.weight)
            }
        }
        .background(Color.white)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .onChange(of: weightText) {
            if let weight = Int(weightText) {
                print("Weight updated in ExerciseView:", weight)
                viewModel.updateWeight(for: exercise.id, weight: weight)
            }
        }
    }
}
