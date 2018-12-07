//
//  ViewController.swift
//  ♥Beats
//
//  Created by Francisco Hernanedez on 10/12/18.
//  Copyright © 2018 Francisco Hernanedz. All rights reserved.
//



import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func authorizeTapped(_ sender: Any) {
        HealthKitManager.authorizeHealthKit()
    }
    
    
}
