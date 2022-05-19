//
//  ViewController.swift
//  PointReferenceApp
//
//  Created by Point.
//

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
            // MARK: Step 2 - User authorization
            await requestAuthorization()

            // MARK: Step 3 - User authentication
            // This will trigger past data sync
            await setUserToken()
            
            // MARK: Step 4 - Go to AppDelegate.swift

            // MARK: Step 5 - Enabling background deliveries
            await enableBackgroundDelivery()
            
            // MARK: Step 6 - Enabling foreground listeners
            await enableForegroundListener()

            // MARK: Step 7 - Getting user data
            await getUserData()

            // MARK: Step 8 - Getting user health metrics
            await getHeathMetrics()
        }

    }
}

extension ViewController {
    func requestAuthorization() async {
        do {
            try await Point.healthKit?.requestAuthorizationsIfPossible()
            print("Authorizations ok")
        } catch {
            print("Error requesting authorizations: \(error)")
        }
    }

    func setUserToken() async {
        do {
            try await Point.setUserToken(accessToken: self.getUserToken())
            print("Token ok")
        } catch {
            print("Error setting the user token or fetching user past data: \(error)")
        }
    }

    func enableBackgroundDelivery() async {
        do {
            let _ = try await Point.healthKit?.enableAllBackgroundDelivery()
            print("Background deliveries ok")
        } catch {
            print("Error enabling background deliveries: \(error)")
        }
    }

    func enableForegroundListener() async {
        do {
            let _ = try await Point.healthKit?.enableAllForegroundListeners()
            print("Foreground listeners ok")
        } catch {
            print("Error enabling foreground listeners: \(error)")
        }
    }
}

extension ViewController {
    @MainActor func getUserData() async {
        do {
            guard let userData = try await Point.healthDataService.getUserData() else {
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

    @MainActor func getHeathMetrics() async {
        do {
            let metrics = try await Point.healthDataService.getHealthMetrics(
                filter: [.restingHr],
                workoutId: nil,
                date: nil
            )
            
            guard let metric = metrics.first else {
                print("No health metrics.")
                return
            }
            metricLabel.text = "Metric type: \(metric.type)"
            metricValueLabel.text = "Value: \(metric.value)"
            metricVarianceLabel.text = "Variance: \(metric.variance ?? 0)"
        } catch {
            print("Error getting health metrics: \(error)")
        }
    }
}

extension ViewController {
    func getUserToken() -> String {
        return "Replace This With Your Token"
    }
}
