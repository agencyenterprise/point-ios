import Foundation
import SwiftUI
import PointSDK

protocol SelectibleViewModel: ObservableObject {
    var currentlySelected: String { get }
    var error: Error? { get set }
    func getOptions() -> [AnySelectible]
    @MainActor func select(_ option: AnySelectible) async
}

protocol AnySelectible: CustomStringConvertible {}

struct SelectionView<Model: SelectibleViewModel>: View {
    @ObservedObject var viewModel: Model
    
    init(viewModel: Model) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ContentOrError(error: $viewModel.error) {
            Group {
                Text("\(viewModel.currentlySelected)")
                ForEach(viewModel.getOptions(), id: \.description) { selectible in
                    Button(selectible.description) { Task { await viewModel.select(selectible) } }
                }
            }
        }
    }
}
