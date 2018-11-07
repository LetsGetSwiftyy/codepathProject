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
class AppDelegate: UIResponder, UIApplicationDelegate, SPTSessionManagerDelegate {
    
    // MARK: - Properties
    //
    
    private let healthStore = HKHealthStore()
    
    var window: UIWindow?
    
    // MARK: - Lifecycle
    
    private func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //FirebaseApp.configure()
        return true
    }
    
    func applicationShouldRequestHealthAuthorization(_ application: UIApplication) {
        // Authorize access to health data for watch.
        healthStore.handleAuthorizationForExtension { success, error in
            print(success)
        }
    }
    
    let SpotifyClientID = "Heartbeat Project"
    let SpotifyRedirectURL = URL(string: "spotify-ios-quick-start://spotify-login-callback")!
    
    lazy var configuration = SPTConfiguration(
        clientID: SpotifyClientID,
        redirectURL: SpotifyRedirectURL
    )
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        print("success", session)
    }
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print("fail", error)
    }
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        print("renewed", session)
    }
    
}

