//
//  AppDelegate.swift
//  PointReferenceApp
//
//  Created by Point.
//

import UIKit
import PointSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // MARK: Step 1 - Setup
        Point.verbose = true
        Point.setup(clientId: "PointReferenceId", clientSecret: "PointReferenceSecret", environment: .development)
        Point.setupHealthkitIntegration(queryTypes: Set(HealthQueryType.allCases))
        
        // MARK: Step 2 and 3 - Go to ViewController.swift

        Task {
            // MARK: Step 4 - Setting up listeners
            do {
                try await Point.healthKit?.startAllListeners()
            } catch {
                print(error.localizedDescription)
            }
        }
        return true
    }
    
    // MARK: Step 5 - Go to ViewController


    // MARK: Auto generated functions
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

    }
}


