import UIKit
import PointSDK

class ViewController: UIViewController {
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var workoutLabel: UILabel!

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
            
            await getUserData()
        }
    }
}

extension ViewController {
    func getUserToken() -> String {
        return "ReplaceThisWithYourToken"
    }
}
