//
//  LoginViewController.swift
//  ♥Beats
//
//  Created by Marilyn Florek on 10/29/18.
//  Copyright © 2018 Francisco Hernanedz. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var spotifyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        spotifyButton = ConnectSpotifyButton(title: "Connect To Spotify")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLogin(_ sender: Any) {
        self.performSegue(withIdentifier: "loginSegue", sender: nil)
    }
    
    @IBAction func onRegister(_ sender: Any) {
        self.performSegue(withIdentifier: "signUpSegue", sender: nil)
    }
    
}
