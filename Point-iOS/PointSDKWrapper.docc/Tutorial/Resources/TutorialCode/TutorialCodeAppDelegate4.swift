import UIKit
import PointSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Point.verbose = true
        Point.setup(
            clientId: "PointReferenceId",
            clientSecret: "PointReferenceSecret",
            environment: .development)
        Point.setupHealthkitIntegration(queryTypes: Set(HealthQueryType.allCases))
        Task {
            await Point.healthKit?.startAllListeners()
        }
        return true
    }
    //Other AppDelegateFunctions
}
