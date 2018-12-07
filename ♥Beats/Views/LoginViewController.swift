//
//  LoginViewController.swift
//  ♥Beats
//
//  Created by Marilyn Florek on 10/29/18.
//  Copyright © 2018 Francisco Hernanedz. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, WebViewControllerDelegate, SFSafariViewControllerDelegate, SPTStoreControllerDelegate {
    
    @IBOutlet weak var spotifyButton: UIButton!
    var authViewController: UIViewController!
    let auth = SPTAuth.defaultInstance()
    var authCallback: SPTAuthCallback!
    var firstLoad: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        auth.clientID = kClientId
        auth.requestedScopes = [SPTAuthStreamingScope]
        auth.redirectURL = URL(fileURLWithPath: kCallbackURL)
//        auth.tokenSwapURL = URL(fileURLWithPath: "https://test-spotify-token-swap.herokuapp.com/token")
        auth.sessionUserDefaultsKey = kSessionUserDefaultsKey;
        
        print("Login view loaded!" )
        NotificationCenter.default.addObserver(self, selector: #selector(sessionUpdatedNotification(notification:)), name: NSNotification.Name(rawValue: "sessionUpdated"), object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let auth = SPTAuth.defaultInstance()
        // Uncomment to turn off native/SSO/flip-flop login flow
        //auth.allowNativeLogin = NO;
        // Check if we have a token at all
        if auth.session == nil {
            return
        }
        // Check if it's still valid
        if (auth.session?.isValid())!{
            // It's still valid, show the player.
            self.showPlayer()
            return
        }
        // Oh noes, the token has expired, if we have a token refresh service set up, we'll call tat one.
        if auth.hasTokenRefreshService {
            self.renewTokenAndShowPlayer()
            return
        }
        // Else, just show login dialog
    }
    
    @IBAction func onLogin(_ sender: Any) {
        self.performSegue(withIdentifier: "loginSegue", sender: nil)
    }
    
    @IBAction func onRegister(_ sender: Any) {
        self.performSegue(withIdentifier: "signUpSegue", sender: nil)
    }
    
    @IBAction func onSpotifyLogin(_ sender: Any) {
        print("Clicked!")
        openLoginPage()
        print("READY")
    }
    
    func openLoginPage()
    {
        auth.clientID = kClientId
        auth.requestedScopes = [SPTAuthStreamingScope]
        auth.redirectURL = URL(string: kCallbackURL)
//        auth.tokenSwapURL = URL(fileURLWithPath: "https://test-spotify-token-swap.herokuapp.com/token")
        auth.sessionUserDefaultsKey = kSessionUserDefaultsKey;

        print("using spotify app authentication")

        if SPTAuth.supportsApplicationAuthentication() {
            UIApplication.shared.openURL(auth.spotifyWebAuthenticationURL())
        } else {
            authViewController = self.getAuthViewController(withURL: auth.spotifyWebAuthenticationURL())
            definesPresentationContext = true
            present(authViewController, animated: true) {
                print("COMPLETED")
            }
        }

        print(auth.clientID as Any)
    }
    
    func getAuthViewController(withURL url: URL) -> UIViewController {
        let webView = WebViewController(url: url)
        webView.delegate = self
        
        return UINavigationController(rootViewController: webView)
    }


    func productViewControllerDidFinish(_ viewController: SPTStoreViewController) {
        print("In store controller function")
    }

    @objc func sessionUpdatedNotification(notification: NSNotification) {
        presentedViewController?.dismiss(animated: true)
        
        
        if (auth.session != nil) && auth.session!.isValid() {
            showPlayer()
        } else {
            print("*** Failed to log in")
        }
    }
        
    func showPlayer()
    {
        self.firstLoad = false;
        self.performSegue(withIdentifier: "loginSegue", sender: nil)
    }

    func renewTokenAndShowPlayer()
    {
        auth.renewSession(auth.session!, callback: { error, session in
            self.auth.session = session
            
            if error != nil {
                if let anError = error {
                    print("*** Error renewing session: \(anError)")
                }
                return
            }
            
            self.showPlayer()
        })
    }
}
