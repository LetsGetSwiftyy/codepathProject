//
//  HeartInterfaceController.swift
//  watchApp Extension
//
//  Created by Marilyn Florek on 10/23/18.
//  Copyright © 2018 Francisco Hernanedz. All rights reserved.
//

import WatchKit
import HealthKit
import Foundation

class HeartInterfaceController: WKInterfaceController {
//    @IBOutlet var heartImageView: WKInterfaceMovie!
    
    
    @IBOutlet var heartImageView: WKInterfaceGroup!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        heartBeating()
        heartImageView.setBackgroundImageNamed("heart-")
        heartImageView.startAnimatingWithImages(in: NSMakeRange(0, 7), duration: 1, repeatCount: -1)

    }
    
    func heartBeating() {
        heartImageView.startAnimating()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
