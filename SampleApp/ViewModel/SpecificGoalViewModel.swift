import Foundation
import SwiftUI
import PointSDK

final class SpecificGoalViewModel {
    let dataManager: DataManager?

    @Published var specificGoal: String
    @Published var error: Error?

    init(dataManager: DataManager?, specificGoal: SpecificGoal?) {
        self.dataManager = dataManager
        self.specificGoal = specificGoal?.description ?? "Not Available"
    }
}

extension SpecificGoalViewModel: SelectibleViewModel {
    var currentlySelected: String {
        specificGoal
    }
    
    func getOptions() -> [AnySelectible] {
        return SpecificGoal.allCases
    }
    
    @MainActor func select(_ option: AnySelectible) async {
        Task {
            guard let dataManager = dataManager, let goal = option as? SpecificGoal else { return }
            do {
                let result = try await dataManager.syncUserSpecificGoal(specificGoal: goal)
                if result { self.specificGoal = goal.description }
            } catch {
                self.error = error
            }
        }
    }
    
    
}

extension SpecificGoal: AnySelectible {
    public var description: String {
        switch self {
        case .buildLeanMuscle:
            return "Build lean muscle mass"
        case .loseWeight:
            return "Lose weight"
        case .prepareForEvent:
            return "Prepare for an event"
        case .accomplishMore:
            return "Accomplish more with my body"
        case .maintainHealth:
            return "Maintain my health"
        }
    }
}
