import Combine
import HealthKit
import PointSDK
import SwiftUI

// MARK: - APIViewModel

final class APIViewModel: ObservableObject {
    @Published var activeEnergyBurned: State = .loading
    @Published var basalEnergyBurned: State = .loading
    @Published var stepCountSample: State = .loading
    @Published var sleep: State = .loading
    @Published var vo2Max: State = .loading
    @Published var heartRate: State = .loading
    @Published var restingHeartRate: State = .loading
    @Published var heartRateVariability: State = .loading
    @Published var workout: State = .loading
    @Published var mindfulSession: State = .loading
    @Published var dateOfBirth: State = .loading

    @Published var foregroundListenerSteps: State = .loading
    @Published var foregroundListenerHeartRate: State = .loading
    @Published var foregroundListenerBasalEnergyBurned: State = .loading
    @Published var foregroundListenerWorkout: State = .loading

    @Published var user: User? = nil

    var cancelables: Set<AnyCancellable> = []

    var supportsHealthKit: Bool { healthKitManager != nil }
    var queryStates: [(title: String, state: State)] {
        [
            ("Active Energy Burned", activeEnergyBurned),
            ("Basal Energy Burned", basalEnergyBurned),
            ("Step Count Sample", stepCountSample),
            ("Sleep", sleep),
            ("VO2 Max", vo2Max),
            ("Heart Rate", heartRate),
            ("Resting Heart Rate", restingHeartRate),
            ("Heart Rate Variability", heartRateVariability),
            ("Workout", workout),
            ("Mindful Session", mindfulSession),
            ("Date Of Birth", dateOfBirth),
        ]
    }

    var foregroundStates: [(title: String, state: State)] {
        [
            ("Listener Step Count", foregroundListenerSteps),
            ("Listener Heart Rate", foregroundListenerHeartRate),
            ("Listener Basal Energy Burned", foregroundListenerBasalEnergyBurned),
            ("Listener Workout", foregroundListenerWorkout),
        ]
    }

    private let healthKitManager: HealthKitManager?
    private let dataManager: DataManager
    private static var defaultStartDate: Date { Calendar.current.date(byAdding: .weekOfYear, value: -5, to: .init())! }
    private var workoutListenerTask: Task<(), Error>?
    private var heartRateListenerTask: Task<(), Error>?

    init(healthKitManager: HealthKitManager?, dataManager: DataManager) {
        self.dataManager = dataManager
        self.healthKitManager = healthKitManager
    }

    func startForegroundListeners() async {
        guard let healthKitManager = healthKitManager else { return }
        let listenInterval = 10
        var listenStartDate: Date {
            Calendar.current.date(byAdding: .hour, value: -24, to: .init())!
        }

        do {
            cancelables.formUnion(
                [
                    try await healthKitManager.poll(timeInterval: TimeInterval(listenInterval)) {
                        .stepCount(startDate: listenStartDate)
                    }
                    .receive(on: DispatchQueue.main)
                    .sink { _ in } receiveValue: { [weak self] in
                        guard let self = self else { return }
                        self.foregroundListenerSteps = self.mapToState(value: $0)
                    },

                    try await healthKitManager.poll(timeInterval: TimeInterval(listenInterval)) {
                        .basalEnergyBurned(startDate: listenStartDate, limit: 10)
                    }
                    .receive(on: DispatchQueue.main)
                    .sink { _ in } receiveValue: { [weak self] in
                        guard let self = self else { return }
                        self.foregroundListenerBasalEnergyBurned = self.mapToState(value: $0)
                    }
                ]
            )
        } catch {
            print("Error starting foreground listeners \(error)")
        }

        do {
            let stream = try await healthKitManager.listen(type: .workout)
            workoutListenerTask = Task { @MainActor in
                do {
                    for try await sample in stream {
                        self.foregroundListenerWorkout = self.mapToState(value: sample)
                    }
                } catch {
                    print(error)
                }
            }
        } catch {
            print("Error starting workout foreground listener \(error)")
        }

        do {
            let stream = try await healthKitManager.listen(type: .heartRate)
            heartRateListenerTask = Task { @MainActor in
              do {
                  for try await sample in stream {
                      self.foregroundListenerHeartRate = self.mapToState(value: sample)
                  }
              } catch {
                  print(error)
              }
            }
        } catch {
            print("Error starting heart rate foreground listener \(error)")
        }
    }

    @MainActor func sync() async {
        guard let healthKitManager = healthKitManager else { return }

        activeEnergyBurned = .loading
        basalEnergyBurned = .loading
        stepCountSample = .loading
        sleep = .loading
        vo2Max = .loading
        heartRate = .loading
        restingHeartRate = .loading
        heartRateVariability = .loading
        workout = .loading
        mindfulSession = .loading
        dateOfBirth = .loading

        let defaultStartDate = Self.defaultStartDate
        dateOfBirth = await mapToState { try await healthKitManager.syncUserBirthday() }
        sleep = await mapToState { try await healthKitManager.sync(query: .sleep(startDate: defaultStartDate)) }
        vo2Max = await mapToState { try await healthKitManager.sync(query: .vo2Max(startDate: defaultStartDate)) }
        mindfulSession = await mapToState {
            try await healthKitManager.sync(query: .mindfulness(startDate: defaultStartDate))
        }
        heartRate = await mapToState { try await healthKitManager.sync(query: .heartRate(startDate: defaultStartDate)) }
        restingHeartRate = await mapToState {
            try await healthKitManager.sync(query: .restingHeartRate(startDate: defaultStartDate))
        }
        workout = await mapToState {
            try await healthKitManager.sync(query: .workout(startDate: defaultStartDate))
        }
        activeEnergyBurned = await mapToState {
            try await healthKitManager.sync(query: .activeEnergyBurned(startDate: defaultStartDate))
        }

        basalEnergyBurned = await mapToState {
            try await healthKitManager.sync(query: .basalEnergyBurned(startDate: defaultStartDate))
        }
        stepCountSample = await mapToState {
            try await healthKitManager.sync(query: .stepCount(startDate: defaultStartDate))
        }
        heartRateVariability = await mapToState {
            try await healthKitManager.sync(query: .heartRateVariabilitySDNN(startDate: defaultStartDate))
        }
    }

    func syncHeartRate() async -> SyncResult? {
        guard let healthKitManager = Point.healthKit else { return nil }
        do {
            let startDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
            return try await healthKitManager.sync(query: .heartRate(startDate: startDate))
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

private extension APIViewModel {
    func mapToState(value: () async throws -> SyncResult) async -> State {
        do {
            return mapToState(value: try await value())
        } catch {
            return .failure(error: error)
        }
    }

    func mapToState(value: SyncResult) -> State {
        value.success ? .success(value: "\(value.samplesCount)") : .failure(error: nil, value: "\(0)")
    }
}

extension APIViewModel {
    enum State {
        case loading
        case success(value: String)
        case failure(error: Error?, value: String? = nil)

        var value: String? {
            switch self {
            case .loading: return nil
            case let .success(value: value): return value
            case let .failure(error: _, value: value): return value
            }
        }

        var error: Error? {
            switch self {
            case .loading, .success: return nil
            case let .failure(error: error, value: _): return error
            }
        }

        @ViewBuilder
        var image: some View {
            Group {
                switch self {
                case .loading: ProgressView()
                case .success: Image(systemName: "checkmark.circle")
                case .failure: Image(systemName: "x.circle")
                }
            }
            .frame(height: 32)
            .padding(.horizontal)
            .transition(.opacity.animation(.spring()))
        }
    }
}
