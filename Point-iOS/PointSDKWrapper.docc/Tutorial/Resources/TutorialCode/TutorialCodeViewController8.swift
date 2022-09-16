import UIKit
import PointSDK

class ViewController: UIViewController {
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var workoutLabel: UILabel!
    @IBOutlet weak var metricLabel: UILabel!
    @IBOutlet weak var metricValueLabel: UILabel!
    @IBOutlet weak var metricVarianceLabel: UILabel!

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

            await getHeathMetrics()
        }
    }
    
    @MainActor func getUserData() async {
        do {
            guard let userData = try await Point.healthService.getUserData() else {
                print("No user data.")
                return
            }
            userLabel.text = "User email is: \(userData.email ?? "Not provided")"

            guard let lastWorkout = userData.lastWorkout?.activityName else {
                print("No workouts available yet")
                return
            }
            workoutLabel.text = "User's last workout was: \(lastWorkout)"
            
        } catch {
            print("Error getting user data: \(error)")
        }
    }

    func getHeathMetrics() async {
        do {
            let metrics = try await Point.healthDataService.getHealthMetrics(
                filter: [HealthMetric.Kind.allCases],
                workoutId: nil,
                date: nil
            )
            print(metrics)
        } catch {
            print("Error getting health metrics: \(error)")
        }
    }
}

extension ViewController {
    func getUserToken() -> String {
        return "ReplaceThisWithYourToken"
    }
}
