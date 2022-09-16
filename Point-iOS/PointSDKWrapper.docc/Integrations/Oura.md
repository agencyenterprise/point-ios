# Oura Integration

Use Point SDK to allow your users to integrate their Point and Oura accounts.

## Overview

When you integrate your app with Oura, Point Health Service will subscribe to Oura to collect the end-user data and generate metrics. However, we must provide a way for the user to authenticate their account and give Point authorization to subscribe to Oura data.

This article will cover all steps necessary to provide full Oura integration to your Point-powered application.

1. Integrate your app with Oura.

2. Create a custom URL for your app in Xcode.

3. Set up the SDK with your Oura Client ID.

4. Call the Oura authentication method.

> As this integration is mostly done in Point's backend, it is available regardless of device type.

## Oura Integration

The first step to using Oura within Point SDK is integrating your app with Oura. We have a step-by-step tutorial [here](https://www.areyouonpoint.co/docs/integration-oura).

## Setting Up

Calling ``Point/setupOuraIntegration(ouraClientId:)`` will instantiate ``OuraIntegrationManager`` within the SDK and it will be available for you to use.

```swift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Point.verbose = true
        Point.setup(
            clientId: "Your Client ID",
            clientSecret: "Your Client Secret",
            environment: appEnvironment
        )
        Point.setupOuraIntegration(ouraClientId: "Your Oura Client ID")
        ...
    }
    ...
}
```

> Tip: Your Oura Client ID is provided by Oura when you create your Oura app integration.

> Important: You also must have a user token set to handle your user's Oura authentication. Check <doc:GettingStarted> for more information.

## Authentication

Each user will need to individually authenticate their Oura account within Point SDK and give Point permission to get their Oura data. This is done on an Oura's web page, although the SDK is capable of loading a browser session that displays the authentication page. After some simple project setup, all you will need to do is call an SDK method when you wish to trigger the authentication flow.

### Create a custom URL

As the authentication is handled by a browser session, the browser must know how to handle the control back to your app. For this, we can use a custom URL scheme that, when called by the browser, redirects to your app and dismisses the browser.

1. Go to your project settings and select your app target.
2. Under the `Info` tab, look for URL Types and click "+" to add a new one.
3. In the Identifier field, enter your app's Bundle ID.
4. In the URL Schemes field, enter the scheme you used in the `callbackURL` when creating your app integration with Oura. For example, if your `callbackURL` is "https:<span>//</span>exampleApp/auth", use "exampleApp".
![Custom URL.](CustomUrl.png)

For more information, check the official docs: [Defining a Custom URL Scheme for Your App](https://developer.apple.com/documentation/xcode/defining-a-custom-url-scheme-for-your-app)

### Authenticating

To display the authentication web page, call ``OuraIntegrationManager/authenticate(scopes:callbackURLScheme:)``. 

When you call this function your app will display a browser with the Oura authentication web page. If the user successfully authenticates, the browser will be dismissed and the control will be handled back to your app.

> Tip: The `callbackUrlScheme` parameter is the scheme created in the previous section.

```swift
func authenticate() async {
    do {
        guard let ouraManager = Point.ouraManager else {
            print("Oura integration was not set up")
            return
        }
        try await ouraManager.authenticate(callbackURLScheme: "yourapp")
    } catch {
        print(error)
    }
}
```

If you wish to select specific Oura scopes, use the `scopes` parameter. All scopes are selected by default. Check [Oura Official Documentation](https://cloud.ouraring.com/docs/authentication) to know more about scopes.

```swift
func authenticate() async {
    do {
        guard let ouraManager = Point.ouraManager else {
            print("Oura client ID was not set when setting up the SDK")
            return
        }
        try await ouraManager.authenticate(scopes: [.heartrate, .workout], callbackURLScheme: "yourapp")
    } catch {
        print(error)
    }
}
```

> The user will be requested to provide authorization for each scope subscription, so data will be collected only if the user provides authorization.

After successful authentication, Point will retroactively retrieve one year of Oura data. After this, the subscriptions are created and Point will be notified for each new user data. No further action is necessary for the SDK. Check <doc:PointAPI> to know how to have access to Point's generated metrics.

### Revoke

You can revoke all Oura subscriptions of the user by calling ``OuraIntegrationManager/revoke()``.

```swift
func revoke() async {
    do {
        try await Point.ouraManager?.revoke()
    } catch {
        print(error)
    }
}
```

After calling this, Point Health Service will stop receiving new data from Oura.

### Check User Status

You can use ``OuraIntegrationManager/getUserAuthenticationStatus()`` to know what is the current authentication status for your user. If ``OuraIntegrationManager/UserIntegrationStatus/active`` is true, your user has already authenticated and Point is collecting their data. You can also check what types of data are being collected by checking ``OuraIntegrationManager/UserIntegrationStatus/scopes``.

```swift
func getCurrentStatus() async {
    guard let manager = Point.ouraManager else { return }
    do {
        let status = try await manager.getUserAuthenticationStatus()
        print("Current status is: \(status?.active)")
        print("Authorized scopes are: \(status?.scopes)")
    } catch {
        print(error)
    }
}
```
