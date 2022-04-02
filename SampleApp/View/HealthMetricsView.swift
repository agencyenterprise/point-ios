import PointSDK
import SwiftUI

struct HealthMetricsView: View {
    @ObservedObject var viewModel: HealthMetricsViewModel

    var body: some View {
        List {
            StateView(state: viewModel.state) { healthMetricsAndKeys in
                ForEach(healthMetricsAndKeys, id: \.key) { (key, healthMetrics) in
                    Section(key) {
                        ForEach(healthMetrics, id: \.hashValue, content: HealthMetricView.init)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                AsyncButton(action: viewModel.getHealthMetrics) {
                    Image(systemName: "arrow.counterclockwise")
                }
            }
        }
        .navigationTitle("Health Metrics")
        .task { await viewModel.getHealthMetrics() }
    }
}
