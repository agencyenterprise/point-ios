import Auth0
import Combine
import PointSDK
import SwiftUI

// MARK: - SampleApp

@main
struct SampleApp: App {
    @State private var error: Error?
    @StateObject private var viewModel = SampleAppViewModel()

    var body: some Scene {
        WindowGroup {
            MainView(viewModel: .init(pointHealthKitManager: viewModel.healthKitManager))
                .environment(\.pointHealthKitManager, viewModel.healthKitManager)
                .environment(\.pointDataManager, viewModel.dataManager)
                .task { await viewModel.setupHeartRateBackgroundQuery() }
        }
    }
}

// MARK: - SampleAppViewModel

final class SampleAppViewModel: ObservableObject {
    lazy var healthKitManager = Point.healthKit
    lazy var dataManager = Point.dataManager

    init() {
        Point.verbose = true
        Point.setup(clientId: "Your Client ID", clientSecret: "Your Client Secret", queryTypes: Set(HealthQueryType.allCases), environment: .development)
    }

    func setupHeartRateBackgroundQuery() async {
        guard let healthKitManager = healthKitManager else { return }
        
        await healthKitManager.setupBackgroundQuery(for: .heartRate)
    }
    
    func setupAllBackgroundQueries() async {
        guard let healthKitManager = healthKitManager else { return }
        
        await healthKitManager.setupAllBackgroundQueries()
    }
    
    func stopBackgroundListener() async {
        do {
            guard let healthKitManager = healthKitManager else { return }
            try await healthKitManager.disableBackgroundDelivery(for: .heartRate)
        } catch {
            print("Error disabling background delivery: \(error)")
        }
    }
    
    func stopAllBackgroundListeners() async {
        do {
            guard let healthKitManager = healthKitManager else { return }
            try await healthKitManager.disableAllBackgroundDelivery()
        } catch {
            print("Error disabling background delivery: \(error)")
        }
    }
}
