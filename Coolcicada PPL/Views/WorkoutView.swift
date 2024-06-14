import SwiftUI

struct WorkoutView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    
    init(viewModel: WorkoutViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.workouts) { workout in
                        HStack {
                            NavigationLink(destination: WorkoutDetailsView(viewModel: viewModel, workout: workout)) {
                                Text(workout.name)
                            }
                            Spacer()
                            Button(action: {
                                viewModel.deleteWorkout(workout)
                            }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 14))
                                    .foregroundColor(.blue)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .navigationBarTitle("Templates")
                
                Spacer()
                
                HStack {
                    NavigationLink(destination: CustomWorkoutView(viewModel: viewModel.customWorkoutViewModel)) {
                        Text("Add Template")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding([.leading, .bottom])
                    }
                    
                    NavigationLink(destination: Text("Quick Start Workout View")) { // Placeholder for Quick Start Workout View
                        Text("Quick Start")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding([.trailing, .bottom])
                    }
                }
                .padding([.horizontal])
            }
        }
    }
}
