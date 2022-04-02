import Auth0
import PointSDK
import SwiftUI

final class SwitchViewModel: ObservableObject {
    enum SwitchViewModelError: Error {
        case missingCredentials
    }
    
    enum State: Identifiable {
        case loading
        case login
        case logged

        var id: Self { self }
    }

    enum AuthError: LocalizedError {
        case missingCredentials
    }

    @Published var state = State.loading
    @Published var error: Error?

    @MainActor
    init() async throws {
        CredentialsManager(authentication: Auth0.authentication()).credentials { error, credentials in
            switch (error, credentials) {
            case let (error?, nil):
                self.state = .login
                self.error = error

            case (_, nil):
                self.state = .login

            case let (_, credentials?):
                guard let accessToken = credentials.accessToken else {
                    return self.error = SwitchViewModelError.missingCredentials
                }

                Task {
                    print("Access Token: \(accessToken)")
                    try await self.setupSDK(accessToken: accessToken)
                    self.state = .logged
                }
            }
        }
    }

    @MainActor
    func logout() async {
        _ = CredentialsManager(authentication: Auth0.authentication()).clear()
        // Logout should always work, if we see any crashes here we should probably fix something or handle the error inside the sdk.
        try! await Point.logout()
        state = .login
    }

    func login(email: String, password: String) {
        let authentication = Auth0.authentication()
        authentication
            .login(
                usernameOrEmail: email,
                password: password,
                realm: "Username-Password-Authentication",
                scope: "openid profile email offline_access"
            )
            .start { result in
                Task {
                    await MainActor.run {
                        self.acceptCredentials(result: result, authentication: authentication)
                    }
                }
            }
    }

    @MainActor
    private func acceptCredentials(result: Swift.Result<Credentials, Error>, authentication: Authentication) {
        do {
            let credentials = try result.get()
            _ = CredentialsManager(authentication: authentication).store(credentials: credentials)
            var accessToken: String {
                get throws {
                    guard let accessToken = credentials.accessToken else {
                        throw AuthError.missingCredentials
                    }

                    return accessToken
                }
            }
            Task {
                try await self.setupSDK(accessToken: try accessToken)
                self.state = .logged
            }
        } catch {
            self.error = error
        }
    }

    func setupSDK(accessToken: String) async throws {
        try await Point.login(accessToken: accessToken, shouldSyncHistoricalData: false)
    }
}
