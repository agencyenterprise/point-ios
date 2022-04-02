import SwiftUI

// MARK: - MainView

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel

    var body: some View {
        if !viewModel.didCheckPermissions {
            ProgressView().task { await viewModel.requestPermissions() }
        } else if let switchViewModel = viewModel.switchViewModel {
            SwitchView(viewModel: switchViewModel)
        } else if let error = viewModel.error {
            Text(verbatim: error.localizedDescription)
        } else {
            ProgressView()
        }
    }
}
