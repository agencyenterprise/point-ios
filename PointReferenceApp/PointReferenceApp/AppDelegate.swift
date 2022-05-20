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
        Point.setup(clientId: "PointReferenceId", clientSecret: "PointReferenceSecret", queryTypes: Set(HealthQueryType.allCases), environment: .development)
        
        // MARK: Step 2 and 3 - Go to ViewController.swift

        Task {
            // MARK: Step 4 - Setting up background listeners
            await Point.healthKit?.setupAllBackgroundQueries()
        }
        return true
    }

    // MARK: Step 6 - Enabling foreground listeners

    func applicationWillResignActive(_ application: UIApplication) {
        Point.healthKit?.stopAllForegroundListeners()
    }
    
    // MARK: Step 7 - Go to ViewController


    // MARK: Auto generated functions
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

    }
}


