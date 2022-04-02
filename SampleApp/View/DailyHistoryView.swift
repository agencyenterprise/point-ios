import PointSDK
import SwiftUI

struct DailyHistoryView: View {
    @ObservedObject var viewModel: DailyHistoryViewModel

    var body: some View {
        List {
            StateView(state: viewModel.state) { dailyHistory in
                ForEach(dailyHistory, id: \.date) { dailyHistory in
                    Section(dailyHistory.date) {
                        ForEach(dailyHistory.metrics, id: \.hashValue) { metric in
                            Text(metric.type).bold()
                            HealthMetricView.init(healthMetric: metric)
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                AsyncButton(action: { await viewModel.getDailyHistory() }) {
                    Image(systemName: "arrow.counterclockwise")
                }
            }
        }
        .navigationTitle("Daily History")
        .task { await viewModel.getDailyHistory() }
    }
}
