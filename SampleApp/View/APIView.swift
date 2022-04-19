import PointSDK
import SwiftUI

// MARK: - APIView

struct APIView: View {
    @ObservedObject var viewModel: APIViewModel
    @ObservedObject var userViewModel: UserViewModel
    var historicalViewModel: HistoricalDataViewModel
    var latestDataViewModel: LatestDataViewModel

    func list(title: String, states: [(title: String, state: APIViewModel.State)]) -> some View {
        List(states, id: \.title) {
            StateSection(title: $0.title, state: $0.state)
        }
        .navigationTitle(title)
    }

    var body: some View {
        if viewModel.supportsHealthKit {
            List {
                "Queries".let {
                    NavigationLink(
                        $0,
                        destination: list(title: $0, states: viewModel.queryStates)
                            .toolbar {
                                ToolbarItemGroup(placement: .navigationBarTrailing) {
                                    AsyncButton(action: viewModel.sync) {
                                        Image(systemName: "arrow.counterclockwise")
                                    }
                                }
                            }
                    )
                }

                "Foreground Listeners".let {
                    NavigationLink($0, destination: list(title: $0, states: viewModel.foregroundStates))
                }

                NavigationLink("User data", destination: UserDataView(userViewModel: userViewModel))
                
                NavigationLink("Historical data", destination: HistoricalDataView(viewModel: historicalViewModel))
                
                NavigationLink("Latest data", destination: LatestDataView(viewModel: latestDataViewModel))
            }
            .navigationTitle("Feature")
            .task {
                await viewModel.sync()
                await viewModel.startForegroundListeners()
            }
        } else {
            Text("Running without Health Kit.")
        }
    }
}
