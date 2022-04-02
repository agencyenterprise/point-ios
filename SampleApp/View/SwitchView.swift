import PointSDK
import SwiftUI

// MARK: - SwitchView

struct SwitchView: View {
    @Environment(\.pointHealthKitManager) var healthKitManager
    @ObservedObject var viewModel: SwitchViewModel

    var body: some View {
        NavigationView {
            Group {
                switch viewModel.state {
                case .loading: ProgressView()
                case .logged: SDKFeaturesView().transition(.opacity)
                case .login: LoginView(error: $viewModel.error, onLogin: viewModel.login).transition(.opacity)
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        viewModel.state = .login
                    } label: {
                        Image(systemName: "person.badge.plus")
                    }

                    AsyncButton(action: viewModel.logout) {
                        Image(systemName: "person.badge.minus")
                    }
                }
            }
            .animation(.spring(), value: viewModel.state)
        }
    }
}

// MARK: - SDKFeaturesView

struct SDKFeaturesView: View {
    @Environment(\.pointHealthKitManager) var healthKitManager
    @Environment(\.pointDataManager) var dataManager: DataManager!

    var body: some View {
        List {
            NavigationLink("Health Kit") {
                APIView(
                    viewModel: .init(healthKitManager: healthKitManager, dataManager: dataManager),
                    userViewModel: .init(pointHealthKitManager: healthKitManager, pointDataManager: dataManager),
                    historicalViewModel: .init(healthKitManager: healthKitManager!),
                    latestDataViewModel: .init(healthKitManager: healthKitManager!)
                )
            }

            NavigationLink("Health Metrics") {
                HealthMetricsView(viewModel: .init(dataManager: dataManager))
            }

            NavigationLink("Daily History") {
                DailyHistoryView(viewModel: .init(dataManager: dataManager))
            }

            NavigationLink("Workout Recommendation") {
                WorkoutRecommendationsView(viewModel: .init(dataManager: dataManager))
            }
        }
        .navigationTitle("Features")
    }
}
