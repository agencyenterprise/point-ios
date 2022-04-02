import PointSDK
import SwiftUI

// MARK: - HealthMetricsViewModel

final class HealthMetricsViewModel: ObservableObject {
    typealias Content = [(key: String, value: [HealthMetric])]
    let dataManager: DataManager

    @Published var state: ViewState<Content, Error> = .loading(content: nil)

    init(dataManager: DataManager) { self.dataManager = dataManager }

    @MainActor func getHealthMetrics() async {
        await state.asyncAccept {
            Array(
                Dictionary(
                    grouping: try await dataManager
                        .getHealthMetrics(filter: Set(HealthMetric.Kind.allCases), workoutId: nil, date: nil),
                    by: \.type
                )
                .mapValues { $0.sorted { $0.date > $1.date } }
            )
            .sorted { $0.key > $1.key }
        }
    }
    
    func getUserHealthMetrics() async -> [HealthMetric]? {
        do {
            return try await dataManager.getHealthMetrics(
                filter: Set(HealthMetric.Kind.allCases),
                workoutId: nil,
                date: nil
            )
        } catch {
            print("Error retrieving user health metrics: \(error.localizedDescription)")
            return nil
        }
    }
}
