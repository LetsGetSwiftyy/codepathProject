//
//  AppDelegate.swift
//  ♥Beats
//
//  Created by Francisco Hernanedez on 10/12/18.
//  Copyright © 2018 Francisco Hernanedz. All rights reserved.
//

import UIKit
import HealthKit
//import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    //    private var rootViewController = ViewController()
    private let healthStore = HKHealthStore()
    var authCallback: SPTAuthCallback!
    var auth: SPTAuth!
    
    var window: UIWindow?
    
    // MARK: - Lifecycle
    
    private func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Authorize access to health data for watch.
        //        window = UIWindow(frame: UIScreen.main.bounds)
        //        window?.rootViewController = rootViewController
        //        window?.makeKeyAndVisible()
        //        applicationShouldRequestHealthAuthorization(application)
        
        auth.clientID = kClientId
        auth.requestedScopes = [SPTAuthStreamingScope]
        auth.redirectURL = URL(fileURLWithPath: kCallbackURL)
        auth.sessionUserDefaultsKey = kSessionUserDefaultsKey;
        
        return true
    }
    
    func applicationShouldRequestHealthAuthorization(_ application: UIApplication) {
        
        healthStore.handleAuthorizationForExtension { success, error in
            if success {
                print(success as Any)
            } else {
                print(error as Any)
            }
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        //        if (rootViewController.appRemote.isConnected) {
        //            rootViewController.appRemote.disconnect()
        //        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        //        if let _ = rootViewController.appRemote.connectionParameters.accessToken {
        //            rootViewController.appRemote.connect()
        //        }
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        // Ask SPTAuth if the URL given is a Spotify authentication callback
        print("The URL: \(url)")
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "sessionUpdated"), object: self)
        
        if SPTAuth.defaultInstance().canHandle(url) {
            SPTAuth.defaultInstance().handleAuthCallback(withTriggeredAuthURL: url) { error, session in
                // This is the callback that'll be triggered when auth is completed (or fails).
                if error != nil {
                    print("*** Auth error: \(error)")
                    return
                }
                else {
                    SPTAuth.defaultInstance().session = session
                }
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "sessionUpdated"), object: self)
            }
        }
        return false
    }
}

