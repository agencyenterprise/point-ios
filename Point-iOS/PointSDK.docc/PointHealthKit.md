# Point Health Kit

Use the Point Health Kit to collect and upload health samples to the Point Database.

## Overview
Point Health Kit abstracts the main functionalities from Apple's Health kit in order to collect and upload health samples in an optimized and easy-to-implement way. 

All methods are optimized for performance and low battery draining, the SDK has several internal optimizations including a small sqlite database to control and avoid uploading duplicated samples, reducing the network requests and data usage.

> Important: All methods results are discardable and meant to be used for debug/information purposes only, we handle all the data internally so that you dont have to worry about processing or uploading the samples.

> Important: All health kit methods require previous user authorization on the data types. Check the **Permissions** session.

## Permissions

Request authorization for all types defined on SDK setup, it is recommended to do it before login or other SDK methods.

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

## Background Listeners
Background listeners run on top of HealthKit's background delivery. When a background listener is set, it wakes up your app whenever a process adds new samples of the specified type, and then syncs those to the Point database.

They are split into two parts: setup and enable.

### Setup

First, you need to setup the background queries you wish to run. This must be done as soon as possible, such as when the app finishes launching.

> This can be done (and we encourage you to do so) before asking for user authorization for the given type. If the user denies authorization, the query will simply have no effect.

You can set up background queries for all types you have set up the SDK with.
```swift
func setupAllBackgroundQueries() async {
    guard let healthKitManager = healthKitManager else { return }
    
    await healthKitManager.setupAllBackgroundQueries()
}
```

You can also setup a background query for just a specific ``HealthQueryType``.
```swift
func setupHeartRateBackgroundQuery() async {
    guard let healthKitManager = Point.healthKit else { return }
    
    await healthKitManager.setupBackgroundQuery(for: .heartRate)
}
```

### Enable

After asking for user permission for the desired sample types, you must enable the background listeners you have set up.

You can enable the background listeners for all ``HealthQueryType`` you have set up the SDK with.
```swift
func enableAllBackgroundListeners() async {
    guard let healthKitManager = Point.healthKit else { return }
    do {
        let result = try await healthKitManager.enableAllBackgroundDelivery()
        print("Background Delivery Enabled: \(result)")
    } catch {
        print("Background Delivery Error:", error)
    }
}
```
You can also enable a background listener for just a specific ``HealthQueryType``.
```swift
func enableBackgroundListener() async {
    guard let healthKitManager = Point.healthKit else { return }
    do {
        let isEnabled = try await healthKitManager.enableBackgroundDelivery(for: HealthQueryType.heartRate)
        print("Background Delivery Enabled: \(isEnabled)")
    } catch {
        print("Background Delivery Error:", error)
    }
}
```

> Important: If you plan on supporting background listeners, set up all your types as soon as possible in application launch, for more information see: [Enable background delivery official docs](https://developer.apple.com/documentation/healthkit/hkhealthstore/1614175-enablebackgrounddelivery)

> Important: For iOS 15 you must enable the HealthKit Background Delivery by adding the com.apple.developer.healthkit.background-delivery entitlement to your app.

### Stop

Stopping a background listener will make any changes made on Apple's Health unnoticeable while the app is not on foreground.

You can stop background delivery for specific ``HealthQueryType``.
```swift
func stopBackgroundListener() async {
    do {
        guard let healthKitManager = Point.healthKit else { return }
        try await healthKitManager.disableBackgroundDelivery(for: .heartRate)
    } catch {
        print("Error disabling background delivery: \(error.localizedDescription)")
    }
}
```

Or you can stop all background listeners:
```swift
func stopAllBackgroundListeners() async {
    do {
        guard let healthKitManager = Point.healthKit else { return }
        try await healthKitManager.disableAllBackgroundDelivery()
    } catch {
        print("Error disabling background delivery: \(error.localizedDescription)")
    }
}
```
> Important: Avoid stopping background delivery in the application lifecycle, we recommend using it only on user logout.

## Foreground Listeners
A foreground listener runs a query that monitors Apple's Health while your app is on foreground. They can be used to automatically get and upload new data from Apple's Health to the Point database as soon as they are available.

You must create a listener for each type you wish to listen. Enabling a foreground listener automatically triggers a **Latest Data** sync.

You can start all listeners by calling `enableAllForegroundListeners()`. This will start a foreground listeners for each one of the ``HealthQueryType`` you have requested to use on the SDK set up.

```swift
do {
    try await healthKitManager.enableAllForegroundListeners()
} catch {
    print("Error starting foreground listeners \(error)")
}
```

> The starting date of the listener query is the date and time you create the listener. It won't listen for past data.

To stop all listeners you can call `stopAllForegroundListeners`. To stop a specific listener, you can call `stopListener`

```swift
func stopListener() {
    stopAllForegroundListeners()
    // or
    stopListener(type: .workout)
}
```

Alternatively, if you wish to keep track of the sync result of each new sample, you can call `listen(type: HealthQueryType)`, which returns a [AsyncThrowingStream](https://developer.apple.com/documentation/swift/asyncthrowingstream).

```swift
let workoutListenerTask: Task<(), Error>?

func listenWorkoutSamples() async {
    do {
        let stream = try await healthKitManager.listen(type: .workout)
        workoutListenerTask = Task { @MainActor in
            do {
                for try await sampleResult in stream {
                    print(sampleResult)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    } catch {
        print("Error starting workout foreground listener \(error.localizedDescription)")
    }
}
```

> Canceling the Task which contains the `AsyncThrowingStream` you received will stop the listener.

## Historical Data
**Helper functions to get the user past data, optimized to handle large amounts of data, using multiple Tasks and uploading in batches.**

Fetches and uploads the user past data for all ``HealthQueryType`` defined in the SDK setup. This is executed automatically when you set the user token for the first time in a session, so you don't need to call this function manually unless you turned automatic syncing off. 
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

> Automatic "historical data syncing" is enabled by default. To turn it off, just set `shouldSyncData` parameter as false on the `setAccessToken` method. We strongly recommend to keep it enabled to acquire more accurate and personalized user data.



## Latest Data
**Helper functions to fill the gap from the latest sync until the current date.**

Fetches and uploads the user latest data for a specific type. This is executed automatically when you setup a foreground listener for this type, so you don't need to call this function manually unless you turned automatic syncing off.

```swift
func getLatestDataForType(type: HealthQueryType) async {
    do {
        guard let healthKitManager = Point.healthKit else { return }
        let result = try await healthKitManager.syncLatestData(sampleType: type) 
        print("Latest data result: \(result)")
    } catch {
        print("Error running historical data: \(error.localizedDescription)")
    }
}
```

You can additionally retrieve the latest samples of all ``HealthQueryType`` you have requested permission.
```swift
func getAllRecentData() async {
    do {
        guard let healthKitManager = Point.healthKit else { return }
        let result = try await healthKitManager.syncAllLatestData()
        print("Latest data result: \(result)")
    } catch {
        print("Error running historical data: \(error.localizedDescription)")
    }
}
```

All latest data queries will query samples from the latest sample date up until now. If the latest sample date is older than six months, then the query will be made from six months up until now.

> Automatic "latest data syncing" is enabled as default. To turn it off for a specific type you must set the type value in `shouldSyncLatestDataBeforeListening` dictionary to `false` before setting up the foreground listener. We strongly recommend to keep it enabled to avoid losing user samples.

> All latest data functions are optimized to handle large amounts of data, using multiple Tasks and uploading data in batches.

## Manual Sync
Runs a custom query and sync the result with Point database.

```swift
func syncHeartRate() async -> SyncResult? {
    guard let healthKitManager = Point.healthKit else { return nil }
    do {
        let startDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
        return try await healthKitManager.sync(query: .heartRate(startDate: startDate))
    } catch {
        print(error.localizedDescription)
        return nil
    }
}
```
> Tip: You can manually run any available query using a custom date range and other filters.

## Topics

### HealthKit
- ``HealthKitManager``
- ``HealthQuery``
- ``HealthQueryType``
- ``ActiveEnergyBurnedQuery``
- ``BasalEnergyBurnedQuery``
- ``HeartRateQuery``
- ``HeartRateVariabilitySDNNQuery``
- ``MindfulnessQuery``
- ``RestingHeartRateQuery``
- ``SleepQuery``
- ``StepCountQuery``
- ``Vo2MaxQuery``
- ``WorkoutQuery``

### API Data
- ``SyncResult``
- ``BatchSyncResult``
