import SwiftUI

struct LatestDataView: View {
    @ObservedObject var viewModel: LatestDataViewModel

    var body: some View {
        StateView(state: viewModel.state) { results in
            List {
                ForEach(results, id: \.key) { type, syncResult in
                    BatchSyncView(type: type, syncResult: syncResult)
                }
            }
        }
        .task {
            await viewModel.getLatestData()
        }
    }
}
