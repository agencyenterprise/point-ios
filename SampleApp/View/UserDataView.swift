import PointSDK
import SwiftUI

struct UserDataView: View {
    @ObservedObject var userViewModel: UserViewModel
    init(userViewModel: UserViewModel) {
        self.userViewModel = userViewModel
    }

    private var notAvailable: String {
        "Not Available"
    }

    var body: some View {
        StateView(state: userViewModel.state) { user in
            List {
                Section {
                    if let name = user?.firstName, !name.isEmpty {
                        Text("\(name)")
                    } else {
                        Text("\(notAvailable)")
                    }
                } header: { Text("Name") }

                Section {
                    Text("\(user?.id ?? notAvailable)")
                } header: { Text("Id") }

                Section {
                    Text("\(user?.birthday ?? notAvailable)")
                } header: { Text("Birthday") }

                Section {
                    Text("\(user?.email ?? notAvailable)")
                } header: { Text("Email") }

                Section {
                    SelectionView(viewModel: GoalViewModel(dataManager: userViewModel.pointDataManager, goal: user?.goal))
                } header: { Text("Goal") }

                Section {
                    SelectionView(viewModel: SpecificGoalViewModel(
                        dataManager: userViewModel.pointDataManager,
                        specificGoal: user?.specificGoal
                    ))
                } header: { Text("Specific Goal") }

                Section {
                    if let workout = user?.lastWorkout {
                        WorkoutView(viewModel: .init(dataManager: userViewModel.pointDataManager), workout: workout)
                    } else {
                        Text(notAvailable)
                    }
                } header: { Text("Last Workout") }
                
                Section {
                    WorkoutsView(viewModel: .init(dataManager: userViewModel.pointDataManager))
                } header: { Text("Workouts") }
                
                Section {
                    Text("\(String(describing: user?.goalProgress))")
                } header: { Text("Goal Progress") }
            }
        }
        .task { await userViewModel.syncUser() }
    }
}
