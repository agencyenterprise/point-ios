# Point Health Kit

Use the Point Health Kit to collect and upload health samples to the Point Database.

## Overview
Point Health Kit abstracts the main functionalities from Apple's [HealthKit](https://developer.apple.com/documentation/healthkit) in order to collect and upload health samples in an optimized and easy-to-implement way. 

All methods are optimized for performance and low battery draining. The SDK has several internal optimizations, including a small sqlite database to control and avoid uploading duplicated samples, reducing the network requests and data usage.

> Important: All methods results are discardable and meant to be used for debug/information purposes only, we handle all the data internally so that you dont have to worry about processing or uploading the samples.

> Important: All health kit methods require previous user authorization on the data types. Check the **Permissions** session.

## Setup

Calling ``Point/setupHealthkitIntegration(queryTypes:userInformationTypes:)`` will instantiate ``HealthKitManager`` within the SDK and it will be available for you to use. As this is the only way to create an instance of HealthKitManager, we suggest calling it as soon as possible, just after ``Point/setup(clientId:clientSecret:environment:)``.

When setting up, you will need to send a Set of ``HealthQueryType``. These are the types of Health data you wish to collect when using the SDK. Assume that all the following features of this article will only work for the types you define in this step.

```swift
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Point.setup(
            clientId: "Your Client ID",
            clientSecret: "Your Client Secret",
            environment: appEnvironment
        )
        Point.setupHealthkitIntegration(queryTypes: Set(HealthQueryType.allCases))
        ...
    }
...
}
```

This function will have no effect if you call it with an empty set of types. Also, as [HealthKit](https://developer.apple.com/documentation/healthkit) is only available on iOS devices, this function will have no effect on other devices, like MacOS or iPadOS.

Additionally, the SDK will get user information from Health's profile, like date of birth and biological sex. All available types are synced by default, but you can select only specific types to be collected using the `userInformationTypes` parameter.

> Tip: This function returns a discardable reference to ``HealthKitManager`` if successful, although, you don't need to hold it if you don't need it, as it will always be available as a variable in ``Point``. Also, subsequent calls of this function will only return this same reference.

## Permissions

Request authorization for all types defined on setup. Calling this function will display an iOS modal asking for the requested authorizations. We recommend calling this before your first call of ``Point/setUserToken(accessToken:shouldSyncHistoricalData:)``.

```swift
@MainActor
func requestPermissions() async {
    guard let pointHealthKitManager = Point.healthKit else { return }
    do {
        try await pointHealthKitManager.requestAuthorizationsIfPossible()
    } catch {
        print("Error requesting authorization: \(error.localizedDescription)")
    }
}
```

> Important: Using any of the following features of this article without having requested permissions previously will result in failure.

## Listeners
Listeners are tools to keep track of new samples added to Apple's Health. They run on top of HealthKit's background delivery, so they are able to work even when your app is on background. When a listener is set, it wakes up your app whenever a process adds new samples of the specified type, and then syncs those to the Point database.

### Start

You need to start the listeners you wish to run. This must be done as soon as possible, such as when the app finishes launching.

You can start listeners for all types set in ``Point/setupHealthkitIntegration(queryTypes:)``
```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    Point.setup(
        clientId: "You Client ID",
        clientSecret: "Your Client Secret",
        environment: appEnvironment
    )
    Point.setupHealthkitIntegration(queryTypes: Set(HealthQueryType.allCases))
    Task {
        guard let healthKitManager = Point.healthKit else { return }
        
        do {
            try await healthKitManager.startAllListeners()
        } catch {
            print(error.localizedDescription)
        }
    }
    return true
}
```

You can also start a listener for just a specific ``HealthQueryType``.
```swift
func startHeartRateListener() async {
    guard let healthKitManager = Point.healthKit else { return }
    
    await healthKitManager.startListener(for: .heartRate)
}
```

> Important: If you plan on supporting background delivery, set up all your types as soon as possible in application launch, for more information see: [Enable background delivery official docs](https://developer.apple.com/documentation/healthkit/hkhealthstore/1614175-enablebackgrounddelivery)

> Important: For iOS 15 you must enable the HealthKit Background Delivery by adding the com.apple.developer.healthkit.background-delivery entitlement to your app.

### Stop

Stopping a listener will make any changes made on Apple's Health unnoticeable.

You can stop a listener of specific ``HealthQueryType``.
```swift
func stopListener() async {
    do {
        guard let healthKitManager = Point.healthKit else { return }
        try await healthKitManager.stopListener(for: .heartRate)
    } catch {
        print("Error stopping listener: \(error.localizedDescription)")
    }
}
```

Or you can stop all listeners:
```swift
func stopAllListeners() async {
    do {
        guard let healthKitManager = Point.healthKit else { return }
        try await healthKitManager.stopAllListeners()
    } catch {
        print("Error stopping all listeners: \(error.localizedDescription)")
    }
}
```
> Important: Avoid stopping the listeners in the application lifecycle. You are not required to stop them at any time and their lifecycles are handled by Point SDK. The listeners are automatically stopped on user logout and restarted on new logins. Only explicitly stop them on a special scenario.

## Historical Data
**Helper functions to get the user past data, optimized to handle large amounts of data, using multiple Tasks and uploading in batches.**

Fetches and uploads the user past data for all ``HealthQueryType`` defined in ``Point/setupHealthkitIntegration(queryTypes:)``. This is executed automatically when you set the user token for the first time in a session, so you don't need to call this function manually unless you turned automatic syncing off. 
```swift
func syncAllHistoricalData() async {
    do {
        guard let healthKitManager = Point.healthKit else { return }
        let result = try await healthKitManager.syncAllHistoricalData()
        print("Historical data result: \(result)")
    } catch {
        print("Error running historical data: \(error.localizedDescription)")
    }
}
```

You can also run a manual sync for specific ``HealthQueryType``, but we encourage not to do it and let the automated process handle that.
```swift
func syncHistoricalDataForType(type: HealthQueryType) async {
    do {
        guard let healthKitManager = Point.healthKit else { return }
        let result = try await healthKitManager.syncHistoricalData(sampleType: type)
        print("Historical data result: \(result)")
    } catch {
        print("Error running historical data: \(error.localizedDescription)")
    }
}
```

> All historical data methods will query samples from an interval before the oldest sample date of the given type. The interval can be from 1 to 6 months, with 3 as default. If the oldest sample is older than one year, no query will be done. The starting date of the query is limited to one year before the current date.

> Automatic "historical data syncing" is enabled by default. To turn it off, just set `shouldSyncHistoricalData` parameter as false on the `setAccessToken` method. We strongly recommend to keep it enabled to acquire more accurate and personalized user data.

## Manual Sync
Use ``HealthKitManager/sync(queryType:from:to:filterDuplicates:)`` to run a custom query and sync the result with Point database.

> Warning: This is available only for debugging purposes. The SDK provides tools to automatically sync Health data, which are optimized for the Point Health Service needs. It's not recommended to use this function for any other purposes other than debugging, as this may cause unnacurate metrics or unnecessary workload.


```swift
func syncHeartRate() async throws -> BatchSyncResult? {
    guard let healthKitManager = Point.healthKit else { return nil }
    do {
        let startDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
        return try await healthKitManager.sync(queryType: .heartRate, from: startDate, to: Date(), filterDuplicates: false)
    } catch {
        print(error.localizedDescription)
        return nil
    }
}
```

> Important: The `filterDuplicates` parameter can be used to turn on/off the duplicate control database. When this parameter is `false`, all fetched samples are going to be uploaded to Point's Database, which may cause unnecessary workload. If this parameter is `true`, only new samples are going to be uploaded, but expect this to change the behaviour of the Listeners.

## Topics

### HealthKit
- ``HealthKitManager``
- ``HealthQueryType``

### API Data
- ``SyncResult``
- ``BatchSyncResult``
