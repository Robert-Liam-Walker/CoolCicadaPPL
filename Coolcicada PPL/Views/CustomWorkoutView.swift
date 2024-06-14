import SwiftUI
import Combine

struct CustomWorkoutView: View {
    @ObservedObject var viewModel: CustomWorkoutViewModel
    
    @State private var exerciseName: String = ""
    @State private var sets: String = ""
    @State private var reps: String = ""
    
    @State private var isAddingExercise = false // Track whether to show exercise input fields
    @State private var isEditingName = false // Track whether to show workout name editing
    @State private var newWorkoutName = "" // Store the new workout name
    
    @State private var showAlert = false // Flag to show alert
    @State private var alertMessage = "" // Message for alert
    
    var body: some View {
        VStack {
            // Display the workout name and edit button
            HStack {
                if isEditingName {
                    TextField("New Workout Name", text: $newWorkoutName)
                        .font(.title)
                        .textFieldStyle(PlainTextFieldStyle()) // Remove border to make it look seamless
                        .padding(.leading)
                    
                    Button(action: {
                        viewModel.renameWorkout(to: newWorkoutName)
                        isEditingName = false
                    }) {
                        Text("Save")
                            .padding(8)
                            .foregroundColor(.white)
                            .background(Color.gray)
                            .cornerRadius(8)
                    }
                    .padding(.trailing)
                } else {
                    Text(viewModel.workout.name)
                        .font(.title)
                        .padding(.leading)
                    
                    Spacer()
                    
                    Button(action: {
                        newWorkoutName = viewModel.workout.name // Pre-fill with the current name
                        isEditingName = true
                    }) {
                        Image(systemName: "pencil")
                            .padding(8)
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing)
                }
            }
            .padding(.vertical)
            
            // List of exercises
            List {
                ForEach(viewModel.workout.exercises) { exercise in
                    VStack(alignment: .leading) {
                        Text(exercise.name)
                            .font(.headline)
                        HStack {
                            Text("\(exercise.sets)")
                                .font(.subheadline)
                            Text(exercise.sets == 1 ? "set" : "sets")
                            Spacer()
                            Text("\(exercise.reps)")
                                .font(.subheadline)
                            Text(exercise.reps == "1" ? "rep" : "reps")
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .padding()
            
            // Add Exercise Section
            VStack {
                if !isAddingExercise {
                    Button(action: {
                        isAddingExercise.toggle()
                    }) {
                        Text("Add Exercise")
                            .padding(8)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    .padding()
                } else {
                    VStack {
                        TextField("Exercise Name", text: $exerciseName)
                            .font(.headline)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        HStack {
                            TextField("Sets", text: $sets)
                                .font(.subheadline)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                                .padding(.horizontal)
                            
                            TextField("Reps", text: $reps)
                                .font(.subheadline)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                                .padding(.horizontal)
                        }
                        
                        HStack {
                            Button(action: {
                                isAddingExercise = false
                                clearExerciseInputs()
                            }) {
                                Text("Cancel")
                                    .padding(8)
                                    .foregroundColor(.white)
                                    .background(Color.gray)
                                    .cornerRadius(8)
                            }
                            .padding(.horizontal)
                            
                            Button(action: {
                                addExercise()
                                isAddingExercise = false // Toggle back to false after adding exercise
                                clearExerciseInputs()
                            }) {
                                Text("Save Exercise")
                                    .padding(8)
                                    .foregroundColor(.white)
                                    .background(Color.blue)
                                    .cornerRadius(8)
                            }
                            .padding(.horizontal)
                        }
                        .padding(.top)
                    }
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding()
                }
            }
        }
        .navigationBarTitle(viewModel.workout.name, displayMode: .inline) // Display workout name in the navigation bar
        .navigationBarItems(trailing:
            Button(action: {
                guard !viewModel.workout.exercises.isEmpty else {
                    showAlert = true
                    alertMessage = "Cannot save workout with no exercises."
                    return
                }
                
                viewModel.saveWorkout()
                resetViewModel()
            }) {
                Text("Save")
                    .padding(8)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        )
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Alert"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func addExercise() {
        guard !exerciseName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showAlert = true
            alertMessage = "Exercise name cannot be empty."
            return
        }
        
        guard let setsInt = Int(sets), setsInt > 0 else {
            showAlert = true
            alertMessage = "Sets must be a valid number greater than 0."
            return
        }
        
        guard let repsInt = Int(reps), repsInt > 0 else {
            showAlert = true
            alertMessage = "Reps must be a valid number greater than 0."
            return
        }
        
        let exercise = Exercise(name: exerciseName, sets: setsInt, reps: reps, weight: 0)
        viewModel.addExercise(exercise)
        
        // Clear input fields
        clearExerciseInputs()
    }
    
    func clearExerciseInputs() {
        exerciseName = ""
        sets = ""
        reps = ""
    }
    
    func resetViewModel() {
        // Reset the view model to start fresh for a new workout
        let newViewModel = CustomWorkoutViewModel()
        viewModel.workout = newViewModel.workout
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            CustomWorkoutView(viewModel: CustomWorkoutViewModel())
        }
    }
}
