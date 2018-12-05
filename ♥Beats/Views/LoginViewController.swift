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
//        self.present(authViewController, animated: true) {
//            self.performSegue(withIdentifier: "loginSegue", sender: nil)
//        }
        
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

}
