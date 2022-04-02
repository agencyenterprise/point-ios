import PointSDK
import SwiftUI

final class WorkoutRecommendationViewModel: ObservableObject {
    typealias Content = [WorkoutRecommendation]
    let dataManager: DataManager

    @Published var state: ViewState<Content, Error> = .loading(content: nil)

    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    @MainActor func getWorkoutRecommendations(date: Date) async {
        await state.asyncAccept {
            try await dataManager.getWorkoutRecommendations(date: date)
        }
    }
    
    func getWorkoutsRecommendations(date: Date) async -> [WorkoutRecommendation] {
        do {
            return try await dataManager.getWorkoutRecommendations(date: date)
        } catch {
            print("Error retrieving workout recommendations \(error.localizedDescription)")
            return []
        }
    }
}
