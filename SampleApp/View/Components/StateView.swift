import SwiftUI

struct StateView<ContentView: View, Content, Error>: View {
    var state: ViewState<Content, Error>

    @ViewBuilder
    var contentViewBuilder: (_ content: Content) -> ContentView

    var body: some View {
        switch state {
        case .loading(content: .none): ProgressView()
        case let .error(error, content: .none): self.error(error)
        case let .loading(content: .some(content)):
            contentViewBuilder(content)
                .toolbar {
                    ToolbarItemGroup { ProgressView() }
                }

        case let .error(error, content: .some(content)):
            VStack(spacing: 8) {
                self.error(error)
                contentViewBuilder(content)
            }

        case let .content(content): contentViewBuilder(content)
        }
    }

    @ViewBuilder func error(_ error: Error) -> some View {
        if let error = error as? Swift.Error {
            Text(error.localizedDescription)
        } else {
            Text(verbatim: "\(error)")
        }
    }
}
