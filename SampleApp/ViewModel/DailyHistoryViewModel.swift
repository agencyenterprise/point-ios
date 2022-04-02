import PointSDK
import SwiftUI

// MARK: - DailyHistoryViewModel

final class DailyHistoryViewModel: ObservableObject {
    typealias Content = [DailyHistory]
    let dataManager: DataManager

    @Published var state: ViewState<Content, Error> = .loading(content: nil)

    init(dataManager: DataManager) { self.dataManager = dataManager }

    @MainActor func getDailyHistory() async {
        await state.asyncAccept {
            try await dataManager.getDailyHistory(offset: 0)
        }
    }
    
    func getDailyHistory(offset: Int = 0) async -> [DailyHistory]? {
        do {
            return try await dataManager.getDailyHistory(offset: offset)
        } catch {
            print("Error retrieving daily history: \(error.localizedDescription)")
            return nil
        }
    }
}
