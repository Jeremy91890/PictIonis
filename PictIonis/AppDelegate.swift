//
//  AppDelegate.swift
//  PictIonis
//
//  Created by Jeremy Debelleix on 06/07/2018.
//  Copyright © 2018 ETNA. All rights reserved.
//

import UIKit
import Firebase
import XCGLogger
import GoogleSignIn
import TwitterKit
import FBSDKLoginKit

let log: XCGLogger      = XCGLogger.default
var navigation = UINavigationController()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()

        // Google+ Auth
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self

        // Twitter Auth
        TWTRTwitter.sharedInstance().start(withConsumerKey: "eECvhgNkqeLVhVkrqC50S0Y4f", consumerSecret: "Xlt4ZF2fmGr6X6AON97CoDW2sFZlIKezrRa0dMOfHaMqSh8dWQ")

        let defaultStore = Firestore.firestore()

        log.debug("default firestore : \(defaultStore)")

        Database.database().isPersistenceEnabled = true

        let uid = UserDefaults.standard.value(forKey: "uid") as? String

        var mainViewController: UIViewController = MainMenuViewController()

        if uid != nil {
            mainViewController = MainMenuViewController()
        }

        navigation = UINavigationController(rootViewController: mainViewController)
        navigation.interactivePopGestureRecognizer!.isEnabled = false

        // Set the root view controller of the app's window
        window!.rootViewController = navigation

        // Make the window visible
        window!.makeKeyAndVisible()

        UIApplication.shared.isStatusBarHidden = true

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any]) -> Bool {

        TWTRTwitter.sharedInstance().application(application, open: url, options: options)

        FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: nil)

        return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:])

    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {

        if let error = error {
            log.error(error)
            return
        }

        guard let authentication = user.authentication else { return }

        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)

        Auth.auth().signInAndRetrieveData(with: credential) { (userInfo, error) in

            if let error = error {
                log.error(error)
                return
            }

            guard let user = userInfo?.user else {
                log.error("no user")
                return
            }

            log.debug("\(String(describing: user.email)) connected")

            UserDefaults.standard.setValue("Google+", forKey: "connectionWay")
            UserDefaults.standard.setValue(user.email, forKey: "userMail")
            UserDefaults.standard.setValue(user.uid, forKey: "uid")
            UserDefaults.standard.setValue("0", forKey: "caregiverId")
            UserDefaults.standard.setValue("0", forKey: "patientId")

            let navigationController = UINavigationController(rootViewController: MainMenuViewController())
            navigationController.interactivePopGestureRecognizer!.isEnabled = false
            navigationController.navigationBar.isHidden = true

            self.window!.rootViewController = navigationController

        }

    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }


}

