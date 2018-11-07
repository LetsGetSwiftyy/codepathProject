//
//  HeartViewController.swift
//  ♥Beats
//
//  Created by Marilyn Florek on 10/26/18.
//  Copyright © 2018 Francisco Hernanedz. All rights reserved.
//

import UIKit

class HeartViewController: UIViewController {
    @IBOutlet weak var heartViewImage: UIImageView!
    var range: NSRange!
    var array: NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heartViewImage.image = UIImage(named: "heart-")
        let imgListArray :NSMutableArray = []
        for countValue in 0...6
        {
            let strImageName : String = "heart-\(countValue).png"
            let image  = UIImage(named:strImageName)
            imgListArray .add(image!)
        }
        
        self.heartViewImage.animationImages = imgListArray as? [UIImage];
        self.heartViewImage.animationDuration = 1.0
        self.heartViewImage.startAnimating()
    }
}
