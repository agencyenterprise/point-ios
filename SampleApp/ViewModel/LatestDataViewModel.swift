import PointSDK
import SwiftUI

final class LatestDataViewModel: ObservableObject {
    
    @Published var state = ViewState<Array<(key: HealthQueryType, value: BatchSyncResult)>, Error>()
    
    private let healthKitManager: HealthKitManager?

    init(healthKitManager: HealthKitManager?) {
        self.healthKitManager = healthKitManager
    }
    
    @MainActor func getLatestData() async {
        await state.asyncAccept {
            guard let healthKitManager = healthKitManager else {
                print("Unable to get latest data: Running with no health kit manager.")
                return []
            }
            let result = try await healthKitManager.syncAllLatestData()
            return Array(result)
        }
    }
    
    func getLatestDataForType(type: HealthQueryType) async {
        do {
            guard let healthKitManager = healthKitManager else {
                print("Unable to get latest data: Running with no health kit manager.")
                return
            }
            let result = try await healthKitManager.syncLatestData(sampleType: type)
            print("Latest data result: \(result)")
        } catch {
            print("Error running historical data: \(error)")
        }
    }
}
