//
//  SignUpViewController.swift
//  ♥Beats
//
//  Created by Marilyn Florek on 10/29/18.
//  Copyright © 2018 Francisco Hernanedz. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onRegister(_ sender: Any) {
        self.performSegue(withIdentifier: "registeredSegue", sender: nil)
    }
    
}
