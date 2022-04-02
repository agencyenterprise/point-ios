import SwiftUI

struct ContentOrError<Content: View>: View {
    @Binding var error: Error?
    var content: () -> Content
    var body: some View {
        if let error = error {
            ErrorView(error: error)
        } else {
            content()
        }
    }
}
