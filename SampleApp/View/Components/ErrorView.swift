import SwiftUI

// MARK: - ErrorView

struct ErrorView: View {
    var error: Error
    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            Text(error.localizedDescription)
            Divider()
            if case let error = error as NSError {
                combine(text1: Text("Domain: "), text2: Text(error.domain))
                combine(text1: Text("Code: "), text2: Text(verbatim: "\(error.code)"))
                combine(text1: Text("UserInfo: "), text2: Text(verbatim: "\(error.userInfo)"))
            }
        }
        .padding(.vertical)
    }

    private func combine(text1: Text, text2: Text) -> Text {
        text1.fontWeight(.semibold) + text2.fontWeight(.light)
    }
}
