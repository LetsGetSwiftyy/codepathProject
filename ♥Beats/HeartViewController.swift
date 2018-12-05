//
//  HeartViewController.swift
//  ♥Beats
//
//  Created by Marilyn Florek on 10/26/18.
//  Copyright © 2018 Francisco Hernanedz. All rights reserved.
//

import UIKit
import AVFoundation

var player: SPTAudioStreamingController!

class HeartViewController: UIViewController, SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate {
    @IBOutlet weak var heartViewImage: UIImageView!
    var range: NSRange!
    var array: NSArray!
    
    @IBOutlet weak var playBtn: UIButton!
    let pause = UIImage(named: "pause")
    let play = UIImage(named: "play")
    var buttonClicked = true;
    @IBOutlet weak var forwardBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var songName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        heartViewImage.image = UIImage(named: "heart-")
//        let imgListArray :NSMutableArray = []
//        for countValue in 0...6
//        {
//            let strImageName : String = "heart-\(countValue).png"
//            let image  = UIImage(named:strImageName)
//            imgListArray .add(image!)
//        }
        
//        self.heartViewImage.animationImages = imgListArray as? [UIImage];
//        self.heartViewImage.animationDuration = 1.0
//        self.heartViewImage.startAnimating()
    }
    
    @IBAction func onPlay(_ sender: Any) {
        player.setIsPlaying(!player.playbackState.isPlaying) { (error: Error?) in
            print(error as Any)
        }
        
        if buttonClicked == false {
            (sender as! UIButton).setImage(self.pause,for: UIControlState.normal);
            buttonClicked = true;
        } else {
            (sender as! UIButton).setImage(self.play,for: UIControlState.normal);
            buttonClicked = false;
        }
    }
    
    @IBAction func onForwardClick(_ sender: Any) {
        player.skipNext { (error: Error?) in
            print(error as Any)
        }
    }
    
    @IBAction func onBackClick(_ sender: Any) {
        player.skipPrevious{ (error: Error?) in
            print(error as Any)
        }
    }
    
}
