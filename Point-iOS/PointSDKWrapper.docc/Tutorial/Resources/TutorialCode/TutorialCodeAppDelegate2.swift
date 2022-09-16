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
        return true
    }
    //Other AppDelegateFunctions
}
