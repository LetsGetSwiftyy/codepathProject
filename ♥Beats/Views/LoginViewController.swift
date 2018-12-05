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
    var firstLoad: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Login view loaded!" )
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLogin(_ sender: Any) {
        self.performSegue(withIdentifier: "loginSegue", sender: nil)
    }
    
    @IBAction func onRegister(_ sender: Any) {
        self.performSegue(withIdentifier: "signUpSegue", sender: nil)
    }
    
    @IBAction func onSpotifyLogin(_ sender: Any) {
        print("Clicked!")
        openLoginPage();
    }
    
    func openLoginPage()
    {
        let auth = SPTAuth.defaultInstance()
        auth.clientID = "5fee3fd264af4f0b811d1508c0604473"
        auth.requestedScopes = [SPTAuthStreamingScope]
        auth.redirectURL = URL(fileURLWithPath: kCallbackURL)
        auth.tokenSwapURL = URL(fileURLWithPath: "https://test-spotify-token-swap.herokuapp.com/token")
        auth.sessionUserDefaultsKey = kSessionUserDefaultsKey;
        
        print("using spotify app authentication")
        
        if SPTAuth.supportsApplicationAuthentication() {
            UIApplication.shared.canOpenURL(auth.spotifyAppAuthenticationURL())
        } else {
            authViewController = authViewController(with: SPTAuth.defaultInstance().spotifyWebAuthenticationURL())
            definesPresentationContext = true
            present(authViewController, animated: true) {
                print("COMPLETED")
            }
        }
        
        print(auth.clientID as Any)
    
    }
    
    func authViewController(with url: URL?) -> UIViewController? {
        var viewController: UIViewController?
        if SFSafariViewController.self != nil {
            var safari: SFSafariViewController? = nil
            if let anUrl = url {
                safari = SFSafariViewController(url: anUrl)
            }
            safari?.delegate = self
            viewController = safari
        } else {
            var webView: WebViewController? = nil
            if let anUrl = url {
                webView = WebViewController(url: anUrl)
            }
            webView?.delegate = self
            if let aView = webView {
                viewController = UINavigationController(rootViewController: aView)
            }
        }
        viewController?.modalPresentationStyle = .pageSheet
        return viewController
    }


    func productViewControllerDidFinish(_ viewController: SPTStoreViewController) {
        print("In store controller function")
    }

    func sessionUpdatedNotification(_ notification: Notification?) {
        let auth = SPTAuth.defaultInstance()
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
        let auth = SPTAuth.defaultInstance()
        
        auth.renewSession(auth.session!, callback: { error, session in
            auth.session = session
            
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
