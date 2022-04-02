import Foundation
import PointSDK

final class WorkoutViewModel: ObservableObject {
    let dataManager: DataManager
    
    @Published var selectedWorkout: ViewState<Workout, Error> = .loading(content: nil)

    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    @MainActor func getWorkout(id: Int) async {
        await selectedWorkout.asyncAccept {
            try await dataManager.getWorkout(id: id)
        }
    }
    
    func retrieveWorkout(id: Int) async -> Workout? {
        do {
            return try await Point.dataManager.getWorkout(id: id)
        } catch {
            print("Error retrieving workout: \(error.localizedDescription)")
            return nil
        }
    }
}
