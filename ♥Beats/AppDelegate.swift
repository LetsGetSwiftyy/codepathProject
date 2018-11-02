//
//  AppDelegate.swift
//  ♥Beats
//
//  Created by Francisco Hernanedez on 10/12/18.
//  Copyright © 2018 Francisco Hernanedz. All rights reserved.
//

import UIKit
import HealthKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SPTSessionManagerDelegate {
    
    // MARK: - Properties
    //
    
    private let healthStore = HKHealthStore()
    
    //Spotify Setup
    
    let SpotifyClientID = ProcessInfo.processInfo.environment["CLIENT_ID"]!
    let SpotifyRedirectURL = URL(string: "spotify-ios-quick-start://spotify-login-callback")!
    
    lazy var configuration = SPTConfiguration(
        clientID: SpotifyClientID,
        redirectURL: SpotifyRedirectURL
    )
    
    
    //setup Spotify Token Swap
    lazy var sessionManager: SPTSessionManager = {
        if let tokenSwapURL = URL(string: "https://test-spotify-token-swap.herokuapp.com/token"),
            let tokenRefreshURL = URL(string: "https://test-spotify-token-swap.herokuapp.com/api/refresh_token") {
            self.configuration.tokenSwapURL = tokenSwapURL
            self.configuration.tokenRefreshURL = tokenRefreshURL
            self.configuration.playURI = ""
        }
        let manager = SPTSessionManager(configuration: self.configuration, delegate: self)
        return manager
    }()
    
    
    
    
    
    var window: UIWindow?
    
    // MARK: - Lifecycle
    
    private func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }
    
    func applicationShouldRequestHealthAuthorization(_ application: UIApplication) {
        // Authorize access to health data for watch.
        healthStore.handleAuthorizationForExtension { success, error in
            print(success)
        }
    }
    
    
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

