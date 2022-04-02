import PointSDK
import SwiftUI

final class HistoricalDataViewModel: ObservableObject {
    @Published var state = ViewState<Array<(key: HealthQueryType, value: BatchSyncResult)>, Error>()
    
    private let healthKitManager: HealthKitManager

    init(healthKitManager: HealthKitManager) {
        self.healthKitManager = healthKitManager
    }
    
    @MainActor func getHistoricalData() async {
        await state.asyncAccept {
            let result = try await healthKitManager.syncAllHistoricalData()
            return Array(result)
        }
    }
    
    func getAllHistoricalData() async {
        do {
            let result = try await healthKitManager.syncAllHistoricalData()
            print("Historical data result: \(result)")
        } catch {
            print("Error running historical data: \(error)")
        }
    }
    
    func getHistoricalDataForType(type: HealthQueryType) async {
        do {
            let result = try await healthKitManager.syncHistoricalData(sampleType: type)
            print("Historical data result: \(result)")
        } catch {
            print("Error running historical data: \(error)")
        }
    }
}
