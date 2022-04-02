import PointSDK
import SwiftUI

final class LatestDataViewModel: ObservableObject {
    
    @Published var state = ViewState<Array<(key: HealthQueryType, value: BatchSyncResult)>, Error>()
    
    private let healthKitManager: HealthKitManager

    init(healthKitManager: HealthKitManager) {
        self.healthKitManager = healthKitManager
    }
    
    @MainActor func getLatestData() async {
        await state.asyncAccept {
            let result = try await healthKitManager.syncAllLatestData()
            return Array(result)
        }
    }
    
    func getLatestDataForType(type: HealthQueryType) async {
        do {
            guard let healthKitManager = Point.healthKit else { return }
            let result = try await healthKitManager.syncLatestData(sampleType: type)
            print("Latest data result: \(result)")
        } catch {
            print("Error running historical data: \(error)")
        }
    }
}
