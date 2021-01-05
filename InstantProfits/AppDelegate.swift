//
//  AppDelegate.swift
//  InstantProfits
//
//  Created by Botosoft Technologies on 11/07/2020.
//  Copyright © 2020 samson. All rights reserved.
//

import UIKit
import Firebase
import OneSignal
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self


        //Remove this method to stop OneSignal Debugging
        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)


        //START OneSignal initialization code
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false, kOSSettingsKeyInAppLaunchURL: false]
        OneSignal.initWithLaunchOptions(launchOptions,
            appId: "bf4684f0-67a6-475f-996a-d8fbf5f961b6",
            handleNotificationReceived: notificationReceivedBlock,
            handleNotificationAction: nil,
            settings: onesignalInitSettings)
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;

        //END OneSignal initializataion code

        
        //UI Testing
//        if let rootWindow = window {
//            let screenSize = DeviceType.iPadPro11.getSize()
//            Projector.display(rootWindow: rootWindow, testingSize: screenSize)
//        }
        
        
        //automatic signin with apple
        if let user = Auth.auth().currentUser{
            
            try! Auth.auth().signOut()
            
//            let storyboard = UIStoryboard(name: "Home", bundle: Bundle.main)
//            let viewController = storyboard.instantiateViewController(withIdentifier: "Home") as! HomeViewController
//            self.window = UIWindow(frame: UIScreen.main.bounds)
//            self.window?.rootViewController = viewController
//            self.window?.makeKeyAndVisible()

        
        }

        return true
    }



    // MARK: UISceneSession Lifecycle

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

    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url)
    }


    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        // ...
        if let error = error {
            // ...
            return
        }

        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
            accessToken: authentication.accessToken)
        // ...
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }

    let notificationReceivedBlock: OSHandleNotificationReceivedBlock = { notification in
        print("Received Notification - \(notification?.payload.notificationID) - \(notification?.payload.title)")
    }


}

