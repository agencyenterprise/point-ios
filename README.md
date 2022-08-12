# PointSDK
Access comprehensive health and fitness user data collected from across multiple wearable devices.

## Overview

Point SDK provides an easy, “plug-and-play” way for you to get access to the full-range of user health metrics powered by Point.

With Point SDK, you can:

- Collect user health and fitness data through Apple HealthKit and have it processed by Point.
- Decide the granularity of health and fitness data you would like to use from the wearable devices, depending on your app needs.
- Retrieve digested health metrics in a normalized, consistent data format across all devices

Point SDK provides a high-level interface for you to setup some listeners on your app, which will be watching for new wearables data coming from Apple HealthKit and proceed to process this data asynchronously.

Point is continually deriving new health metrics, health score updates, personalized health insights, and workout recommendations based on the wearables data, and you can retrieve those through our SDK at any time to deliver a custom experience to your users.


## Installation

### Swift Package Manager

Open the following menu item in Xcode:

**File > Add Packages...**

In the **Search or Enter Package URL** search box enter this URL: 

```text
https://github.com/agencyenterprise/point-ios
```

Then, select the dependency rule and press **Add Package**.

> 💡 For further reference on SPM, check its [official documentation](https://developer.apple.com/documentation/swift_packages/adding_package_dependencies_to_your_app).

### Cocoapods

Add the following line to your `Podfile`:

```ruby
pod 'PointSDK', '~> 0.2.6'
```

Then, run `pod install`.

> 💡 For further reference on Cocoapods, check their [official documentation](https://guides.cocoapods.org/using/getting-started.html).

## Documentation

The SDK package is shipped with a Xcode friendly DocC documentation.

You can also check the complete documentation here: https://agencyenterprise.github.io/point-ios/documentation/pointsdk

Additionally, there  is a Reference App on this repository that you can use as an example of how to use the SDK.
