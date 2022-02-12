//
//  AppDelegate.swift
//  Arak
//
//  Created by Abed Qassim on 21/02/2021.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import FirebaseMessaging
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    LocaleManager.setup()
    IQKeyboardManager.shared.enable = true
    FirebaseApp.configure()
    GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
    if Helper.appLanguage == nil {
        Helper.appLanguage = "en"
        LocaleManager.apply(identifier: Helper.appLanguage ?? "en")
    }
    for family in UIFont.familyNames {
        print("\(family)")

        for name in UIFont.fontNames(forFamilyName: family) {
            print("\(name)")
        }
    }
    if let font = UIFont(name: "DroidArabicKufi-Bold", size: 14) {
      let attributes = [NSAttributedString.Key.font: font]
      UINavigationBar.appearance().titleTextAttributes = attributes
    }

    UNUserNotificationCenter.current().delegate = self
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
      (granted, error) in
      guard granted else { return }
      DispatchQueue.main.async {
        UIApplication.shared.registerForRemoteNotifications()
      }
    }

    return true
  }
  @available(iOS 9.0, *)
  func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
    -> Bool {
    return GIDSignIn.sharedInstance().handle(url)
  }

//  func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any])
//          -> Bool {
//              let facebookResponse = ApplicationDelegate.shared.application(application, open: url, options: options)
//              let googleResponse = GIDSignIn.sharedInstance().handle(url)
//              return facebookResponse || googleResponse
//      }

  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    // 1. Convert device token to string
    let tokenParts = deviceToken.map { data -> String in
      return String(format: "%02.2hhx", data)
    }
    let token = tokenParts.joined()
    // 2. Print device token to use for PNs payloads
    print("Device Token: \(token)")
    let bundleID = Bundle.main.bundleIdentifier;
    print("Bundle ID: \(token) \(bundleID)");
    // 3. Save the token to local storeage and post to app server to generate Push Notification. ...
    print("FCM TOKEN:\(Messaging.messaging().fcmToken)");
    Messaging.messaging().apnsToken = deviceToken
  }

  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("failed to register for remote notifications: \(error.localizedDescription)")
  }
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {

    print("Received push notification: \(userInfo)")
    let aps = userInfo["aps"] as! [String: Any]
    print("\(aps)")
  }

  @available(iOS 13.0, *)
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
  @available(iOS 13.0, *)
  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }


}


extension AppDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter,
           willPresent notification: UNNotification,
           withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
      completionHandler([.alert, .badge, .sound])

    }

}
