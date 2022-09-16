# Getting Started

Learn how to configure you project and start using the SDK

## Setting Up Point SDK

Before any feature can be used, you must initialize the SDK by providing your credentials.

It is recommended to do this at the start of your application.
```swift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Point.verbose = true // if want to see console logs about the SDK operations
        Point.setup(
            clientId: "YOUR_CLIENT_ID", 
            clientSecret: "YOUR_CLIENT_SECRET",
            environment: .development
        )
    }
}
```

> Important: Important: Using **Point.verbose = true** will make the SDK print logs in the debug console about internal operations, filters, dates, errors, warnings and much more. This is helpful during development/integration phase, but we recommend turning it off before releasing your app into production.


### Setting User's Access Token

> Note: This section assumes you already have a user token. Refer to <doc:AuthenticatingUsers> for more details.

 Set the user access token. This token is used internally to authenticate your user against Point API.

```swift
func setupAccessToken(accessToken: String) async throws {
    try await Point.setUserToken(accessToken: accessToken)
}
```

> Important: If you have set up Healthkit integration, the setUserToken function automatically trigger a group of queries fetching past user's data, only if it's the first `setUserToken` usage in the current session. Because of this, we suggest evoking this function after ``HealthKitManager/requestAuthorizationsIfPossible()`` otherwise this automatic sync will fail. Refer to <doc:PointHealthKit> for more information.



## Collecting and uploading samples
Use one or more of our integrations to collect and upload health samples and basic user data to Point Database.

- Check <doc:Healthkit> to know how to support Apple Watch and Health app. This is only available in iPhone devices.

- Check <doc:Fitbit> to know how to support Fitbit devices. This is available regardless of device.

## Retrieving user data and generated metrics
Use the <doc:PointAPI> to retrieve user data and generated metrics such as recommendations, trends, workouts, health metrics and more.
