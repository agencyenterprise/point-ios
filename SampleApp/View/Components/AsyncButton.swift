import SwiftUI

struct AsyncButton<Label: View>: View {
    var action: () async -> Void
    @ViewBuilder var label: () -> Label

    @State private var isPerformingTask = false

    var body: some View {
        Button {
            isPerformingTask = true
            Task {
                await action()
                isPerformingTask = false
            }
        } label: {
            if isPerformingTask {
                ProgressView()
            } else {
                label()
            }
        }
        .disabled(isPerformingTask)
    }
}
