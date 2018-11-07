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

    
    private var rootViewController = ViewController()
    private let healthStore = HKHealthStore()

    var window: UIWindow?
    
    // MARK: - Lifecycle
    
    private func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Authorize access to health data for watch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        return true
    }
    
//    func applicationShouldRequestHealthAuthorization(_ application: UIApplication) {
//
//        healthStore.handleAuthorizationForExtension { success, error in
//            print(success)
//        }
//    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        rootViewController.sessionManager.application(app, open: url, options: options)
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        if (rootViewController.appRemote.isConnected) {
            rootViewController.appRemote.disconnect()
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if let _ = rootViewController.appRemote.connectionParameters.accessToken {
            rootViewController.appRemote.connect()
        }
    }
    
}

