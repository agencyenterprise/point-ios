import Foundation
import PointSDK

final class GoalViewModel {
    let dataManager: DataManager?
    
    @Published var goal: String
    @Published var error: Error?

    init(dataManager: DataManager?, goal: Goal?) {
        self.dataManager = dataManager
        self.goal = goal?.description ?? "Not Available"
    }
}

extension GoalViewModel: SelectibleViewModel {
    var currentlySelected: String {
        goal
    }

    func getOptions() -> [AnySelectible] {
        return Goal.allCases
    }
    
    @MainActor func select(_ option: AnySelectible) async {
        Task {
            guard let dataManager = dataManager, let goal = option as? Goal else { return }
            do {
                let result = try await dataManager.syncUserGoal(goal: goal)
                if result { self.goal = goal.description }
            } catch {
                self.error = error
            }
        }
    }
}

extension Goal: AnySelectible {
    public var description: String {
        switch self {
        case .athleticPerformance:
            return "Athletic Performance"
        case .weightLoss:
            return "Weight Loss"
        }
    }
}
