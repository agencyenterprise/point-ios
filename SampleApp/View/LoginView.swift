import SwiftUI

// MARK: - LoginView

struct LoginView: View {
    @State private var email = "anny+2@ae.studio"
    @State private var password = "PointTest123@"

    @Binding var error: Swift.Error?

    var onLogin: (_ email: String, _ password: String) -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                    TextField("Email", text: $email)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Password")
                    SecureField("Password", text: $password)
                }
            }
            .padding()
        }
        .textFieldStyle(.roundedBorder)
        .navigationTitle("Login")
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button {
                    onLogin(email, password)
                } label: {
                    Text("Sign in")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(Color.green)
                        .cornerRadius(15.0)
                }
            }
        }
        .alert(error?.localizedDescription ?? "", isPresented: $error.isNotNil) {
            Button("OK") { error = nil }
        }
    }
}

extension Optional where Wrapped == Error {
    var isNotNil: Bool {
        get { self != nil }
        set { if !newValue { self = nil } }
    }
}
