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
        
        heartBeating()
        heartViewImage.image = UIImage(named: "heart-")
        range = NSMakeRange(0, 7);
        array.subarray(with: range)
        heartViewImage.animationImages = array as! [UIImage]
        heartViewImage.animationRepeatCount = -1
        heartViewImage.animationDuration = 1
    }
    
    func heartBeating() {
        heartViewImage.startAnimating()
    }
}
