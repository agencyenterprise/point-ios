# Healthkit Integration

Learn how to integrate your app with Apple's Healthkit and start using Point SDK to collect and upload Health data.

## Overview

Apple's [HealthKit](https://developer.apple.com/documentation/healthkit) provides a central repository for health and fitness data on iPhone and Apple Watch. With a quick setup, you can enable a Healthkit integration with your app, allowing Point SDK to collect data from Healthkit and upload it to Point's database to be processed.

> Healthkit stores all user data on the user's device, so all data collection happens locally, on the device. This means that this integration is only possible in iPhone devices, as other devices don't provide support for Healthkit.

## Setting Up your Project

**Before you start using Point SDK, you must perform the following changes to your Xcode project settings:**

1. Enable **HealthKit capabilities** in your app. 

2. Add permissions configuration

### Enable HealthKit capabilities

In Xcode, select the project and add the HealthKit capability.
It is highly recommended that you also enable **Background Delivery** and **Background fetch** capabilities.
![Project capabilities.](Project-config.png)
For a detailed discussion about enabling Health Kit capabilities, see [Configure HealthKit](https://help.apple.com/xcode/mac/current/#/dev1a5823416) at the official Xcode Help.

### Permissions configuration

You must provide a message to the user explaining why the app is requesting permission to read samples from the HealthKit store.
To do so, set the [NSHealthShareUsageDescription](https://developer.apple.com/documentation/bundleresources/information_property_list/nshealthshareusagedescription) key to customize this message. 
For projects created using Xcode 13 or later, set these keys in the Target Properties list on the app’s Info tab. 
For projects created with Xcode 12 or earlier, set these keys in the apps Info.plist file. 
For more information, see [Information Property List](https://developer.apple.com/documentation/bundleresources/information_property_list).

## Next Steps

Point SDK provides an abstraction of the main functionalities from Apple's [HealthKit](https://developer.apple.com/documentation/healthkit) in order to collect and upload health samples in an optimized and easy-to-implement way. Check <doc:PointHealthKit> for detailed instructions.
