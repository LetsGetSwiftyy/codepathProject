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
    var firstload: Bool!
    
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
        print("Logging in...")
        let auth = SPTAuth()
        self.authViewController = self.authViewControllerWithURL(url: auth.spotifyWebAuthenticationURL() as NSURL)
        self.definesPresentationContext = true
        self.present(authViewController, animated: true) {
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
            print("FINISHED")
        }
        
        self.performSegue(withIdentifier: "loginSegue", sender: nil)
        
    }
    
    func authViewControllerWithURL(url: NSURL) -> UIViewController
    {
        var viewController = UIViewController()
        let webView = WebViewController(url: url as URL)
        webView.delegate = self
        viewController = UINavigationController.init(rootViewController: webView)
        viewController.modalPresentationStyle = UIModalPresentationStyle.pageSheet
        return viewController
    }

    func productViewControllerDidFinish(_ viewController: SPTStoreViewController) {
        print("In store controller function")
    }

    func sessionUpdatedNotification(notification: NSNotification )
    {
        var auth = SPTAuth.defaultInstance()
        self.presentedViewController?.dismiss(animated: true, completion:nil)
//
//    if (auth.session && [auth.session isValid]) {
//    self.statusLabel.text = @"";
//    [self showPlayer];
//    } else {
//    self.statusLabel.text = @"Login failed.";
//    NSLog(@"*** Failed to log in");
//    }
//    }
    
    func showPlayer()
    {
        self.firstLoad = false;
        self.performSegue(withIdentifier: "loginSegue", sender: nil)
    }

    func renewTokenAndShowPlayer()
    {
        var auth = SPTAuth.defaultInstance()

        auth.renewSession(auth.session, callback: (error: NSError, session: SPTSession), {
            auth.session = session;

        if (error) {
            NSLog(@"*** Error renewing session: %@", error);
            return;
        }
            
            showPlayer()

        };
    }
}
