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
        
        auth.clientID = "5fee3fd264af4f0b811d1508c0604473"
        auth.requestedScopes = [SPTAuthStreamingScope]
        auth.redirectURL = URL(fileURLWithPath: kCallbackURL)
        auth.tokenSwapURL = URL(fileURLWithPath: "https://test-spotify-token-swap.herokuapp.com/token")
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

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
//        rootViewController.sessionManager.application(app, open: url, options: options)//
//        if (authCallback != nil) {
//            (error: NSError, session: SPTSession) in do {
//                if (error) {
//                    print("*** Auth error: %@", error);
//                } else {
//                    auth.session = session;
//
//                }
//
//                authCallbackprint("session updated")
//
//            }
//        }
        
        /*
         Handle the callback from the authentication service. -[SPAuth -canHandleURL:]
         helps us filter out URLs that aren't authentication URLs (i.e., URLs you use elsewhere in your application).
         */
        
        if (auth.canHandle(url)) {
            auth.handleAuthCallback(withTriggeredAuthURL: url, callback: authCallback)
            return true;
        }
        
        return false;
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
    
}

