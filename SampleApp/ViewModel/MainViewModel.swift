import HealthKit
import PointSDK
import SwiftUI

final class MainViewModel: ObservableObject {
    let pointHealthKitManager: HealthKitManager?

    @Published var didCheckPermissions = false
    @Published var switchViewModel: SwitchViewModel?
    @Published var error: Error?

    init(pointHealthKitManager: HealthKitManager?) {
        self.pointHealthKitManager = pointHealthKitManager
        Task {
            do {
                self.switchViewModel = try await .init()
            } catch {
                self.error = error
            }
        }
    }

    @MainActor
    func requestPermissions() async {
        defer { didCheckPermissions = true }
        guard let pointHealthKitManager = pointHealthKitManager else { return }
        do {
            try await pointHealthKitManager.requestAuthorizationsIfPossible()
        } catch {
            self.error = error
        }
        
        await startHeartRateBackgroundListener()
    }
    
    func startHeartRateBackgroundListener() async {
        guard let healthKitManager = pointHealthKitManager else { return }
        do {
            let heartRateEnable = try await healthKitManager.enableBackgroundDelivery(for: HealthQueryType.heartRate)
            print("Background Delivery Enabled for heart rate: \(heartRateEnable)")
        } catch {
            print("Background Delivery Error:", error)
        }
    }
    
    func startAllBackgroundListeners() async {
        guard let healthKitManager = pointHealthKitManager else { return }
        do {
            let result = try await healthKitManager.enableAllBackgroundDelivery()
            print("Background Delivery Enabled: \(result)")
        } catch {
            print("Background Delivery Error:", error)
        }
    }
}
