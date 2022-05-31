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

            do {
                let _ = try await Point.healthKit?.enableAllBackgroundDelivery()
            } catch {
                print("Error enabling background deliveries: \(error)")
            }

            do {
                let _ = try await Point.healthKit?.enableAllForegroundListeners()
            } catch {
                print("Error enabling foreground listeners: \(error)")
            }
            
            await getUserData()
        }
    }
    
    func getUserData() async {
        do {
            guard let userData = try await Point.healthDataService.getUserData() else {
                print("No user data.")
                return
            }
        } catch {
            print("Error getting user data: \(error)")
        }
    }
}

extension ViewController {
    func getUserToken() -> String {
        return "ReplaceThisWithYourToken"
    }
}
