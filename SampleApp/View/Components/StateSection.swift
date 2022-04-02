import SwiftUI

// MARK: - StateSection

struct StateSection: View {
    var title: String
    var state: APIViewModel.State

    @State private var isExpanded = false

    var body: some View {
        Section {
            if isExpanded {
                VStack(alignment: .leading, spacing: 16) {
                    state.value.map(Text.init(verbatim:))
                    state.error.map(ErrorView.init)
                }
            }
        } header: {
            Button {
                isExpanded.toggle()
            } label: {
                HStack {
                    Text(title)
                    state.image
                }
            }
        }
    }
}
