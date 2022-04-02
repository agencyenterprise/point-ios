import SwiftUI

struct HistoricalDataView: View {
    @ObservedObject var viewModel: HistoricalDataViewModel

    var body: some View {
        StateView(state: viewModel.state) { results in
            List {
                ForEach(results, id: \.key) { type, syncResult in
                    BatchSyncView(type: type, syncResult: syncResult)
                }
            }
        }
        .task {
            await viewModel.getHistoricalData()
        }
    }
}
