import Foundation
import PointSDK

final class UserViewModel: ObservableObject {
    let pointHealthKitManager: HealthKitManager?
    let pointDataManager: DataManager

    @Published var state = ViewState<User?, Error>()

    init(pointHealthKitManager: HealthKitManager?, pointDataManager: DataManager) {
        self.pointHealthKitManager = pointHealthKitManager
        self.pointDataManager = pointDataManager
    }

    @MainActor func syncUser() async {
        await state.asyncAccept(throwingContent: pointDataManager.getUserData)
    }
    
    func getUser() async -> User? {
        do {
            return try await Point.dataManager.getUserData()
        } catch {
            print("Error retrieving user data: \(error)")
            return nil
        }
    }
}
