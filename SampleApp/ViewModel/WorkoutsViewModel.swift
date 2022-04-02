import Foundation
import PointSDK

final class WorkoutsViewModel: ObservableObject {
    let dataManager: DataManager
    
    @Published var state: ViewState<[Workout], Error> = .loading(content: nil)

    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    @MainActor func getUserWorkouts() async {
        await state.asyncAccept { try await dataManager.getUserWorkouts(offset: 0) }
    }
    
    func retrieveUserWorkouts(offset: Int = 0) async -> [Workout] {
        do {
            return try await Point.dataManager.getUserWorkouts(offset: offset)
        } catch {
            print("Error retrieving user workouts: \(error)")
            return []
        }
    }
}
