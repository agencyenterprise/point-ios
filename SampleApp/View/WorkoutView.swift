import PointSDK
import SwiftUI

struct WorkoutView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @State private var isExpanded = false
    
    let workout: Workout
    var body: some View {
        Section {
            if isExpanded {
                StateView(state: viewModel.selectedWorkout) { workout in
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Activity: \(workout.activityName)")
                        Text("Calories: \(workout.calories)")
                        Text("Distance: \(workout.distance)")
                        Text("Duration: \(workout.duration)")
                        Text("Start Date: \(workout.start)")
                        Text("End Date: \(workout.end)")
                    }
                }
                .task { await viewModel.getWorkout(id: workout.id) }
            }
        } header: {
            Button {
                isExpanded.toggle()
            } label: {
                Text(workout.activityName)
            }
        }
    }
}
