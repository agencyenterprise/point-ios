import UIKit
import PointSDK

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        Task {
            do {
                try await Point.healthKit?.requestAuthorizationsIfPossible()
            } catch {
                print("Error requesting authorizations: \(error)")
            }

            do {
                try await Point.setUserToken(accessToken: self.getUserToken())
            } catch {
                print("Error setting the user token or fetching user past data: \(error)")
            }

            do {
                let _ = try await Point.healthKit?.enableAllBackgroundDelivery()
            } catch {
                print("Error enabling background deliveries: \(error)")
            }
        }
    }
}

extension ViewController {
    func getUserToken() -> String {
        return "ReplaceThisWithYourToken"
    }
}
