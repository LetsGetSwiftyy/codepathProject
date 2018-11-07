//
//  ViewController.swift
//  ♥Beats
//
//  Created by Francisco Hernanedez on 10/12/18.
//  Copyright © 2018 Francisco Hernanedz. All rights reserved.
//



import UIKit

class ViewController: UIViewController, SPTAppRemoteDelegate, SPTSessionManagerDelegate, SPTAppRemotePlayerStateDelegate {
    
    //  Spotify API Vars
    let SpotifyClientID = ProcessInfo.processInfo.environment["CLIENT_ID"]!
    let SpotifyRedirectURL = URL(string: "spotify-ios-quick-start://spotify-login-callback")!
    let spotifyConnectButton = ConnectSpotifyButton(title: "Connect To Spotify")
    
    

    //Configuration For SPTSessionManager
    lazy var configuration = SPTConfiguration(
        clientID: SpotifyClientID,
        redirectURL: SpotifyRedirectURL
    )
    
    var authorized: Bool!
    fileprivate let trackID = "spotify:track:6bjYPIzpMjFhlYbgPhi8AP"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(spotifyConnectButton)
        spotifyConnectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spotifyConnectButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        spotifyConnectButton.sizeToFit()
        spotifyConnectButton.addTarget(self, action: #selector(didTapConnect(_:)), for: .touchUpInside)
        authorized = false
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    //connectButton IBAction Instead:
    @objc func didTapConnect(_ button: UIButton) {
        /*
         Scopes let you specify exactly what types of data your application wants to
         access, and the set of scopes you pass in your call determines what access
         permissions the user is asked to grant.
         For more information, see https://developer.spotify.com/web-api/using-scopes/.
         */
        let scope: SPTScope = [.appRemoteControl, .playlistReadPrivate]
        sessionManager.initiateSession(with: scope, options: .clientOnly)
        print("Success!")
        self.performSegue(withIdentifier: "playlistSegue", sender: nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func authorizeTapped(_ sender: Any) {
        authorized = HealthKitManager.authorizeHealthKit()
    }
    
    
    //init appRemote
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: self.configuration, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()
    
    
    //setup Spotify Token Swap
    lazy var sessionManager: SPTSessionManager = {
        if let tokenSwapURL = URL(string: "https://test-spotify-token-swap.herokuapp.com/token"),
            let tokenRefreshURL = URL(string: "https://test-spotify-token-swap.herokuapp.com/api/refresh_token") {
            self.configuration.tokenSwapURL = tokenSwapURL
            self.configuration.tokenRefreshURL = tokenRefreshURL
            self.configuration.playURI = "spotify:track:6bjYPIzpMjFhlYbgPhi8AP"
        }
        let manager = SPTSessionManager(configuration: self.configuration, delegate: self)
        return manager
    }()
    
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        
        self.appRemote.playerAPI?.delegate = self
        self.appRemote.playerAPI?.subscribe(toPlayerState: { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
        })
        
        // Want to play a new track?
        // self.appRemote.playerAPI?.play("spotify:track:13WO20hoD72L0J13WTQWlT", callback: { (result, error) in
        //     if let error = error {
        //         print(error.localizedDescription)
        //     }
        // })
        print("connected")
        
    }
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        self.appRemote.connectionParameters.accessToken = session.accessToken
        self.appRemote.connect()
        print("success", session)
    }
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print("fail", error)
    }
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        print("renewed", session)
    }
    
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        print("player state changed")
        print("isPaused", playerState.isPaused)
        print("track.uri", playerState.track.uri)
        print("track.name", playerState.track.name)
        print("track.imageIdentifier", playerState.track.imageIdentifier)
        print("track.artist.name", playerState.track.artist.name)
        print("track.album.name", playerState.track.album.name)
        print("track.isSaved", playerState.track.isSaved)
        print("playbackSpeed", playerState.playbackSpeed)
        print("playbackOptions.isShuffling", playerState.playbackOptions.isShuffling)
        print("playbackOptions.repeatMode", playerState.playbackOptions.repeatMode.hashValue)
        print("playbackPosition", playerState.playbackPosition)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        if self.appRemote.isConnected {
            self.appRemote.disconnect()
        }
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
        if let _ = self.appRemote.connectionParameters.accessToken {
            self.appRemote.connect()
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    //TODO: protocol Stubs
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("disconnected")
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("failed")
    }
    
    
    
    
    
}
