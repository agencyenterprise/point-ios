import PointSDK
import SwiftUI

struct WorkoutsView: View {
    @ObservedObject var viewModel: WorkoutsViewModel

    var body: some View {
        StateView(state: viewModel.state) { workouts in
            ForEach(workouts, id: \.id) { workout in
                WorkoutView.init(viewModel: .init(dataManager: viewModel.dataManager), workout: workout)
            }
        }
        .task { await viewModel.getUserWorkouts() }
    }
}
