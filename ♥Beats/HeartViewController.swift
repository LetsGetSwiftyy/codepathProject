//
//  HeartViewController.swift
//  ♥Beats
//
//  Created by Marilyn Florek on 10/26/18.
//  Copyright © 2018 Francisco Hernanedz. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

//var SPTAudioStreamingController.sharedInstance(): SPTAudioStreamingController!

class HeartViewController: UIViewController, SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate {
    @IBOutlet weak var heartViewImage: UIImageView!
    
    var range: NSRange!
    var array: NSArray!
    let auth = SPTAuth.defaultInstance()
    
    @IBOutlet weak var playBtn: UIButton!
    let pause = UIImage(named: "pause")
    let play = UIImage(named: "play")
    var buttonClicked = true;
    @IBOutlet weak var forwardBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var track: UIProgressView!
    let audioSession = AVAudioSession.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.songName.text = "Nothing Playing"
        self.artistName.text = "No Artist"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleNewSession()
    }

    func updateUI() {
        if SPTAudioStreamingController.sharedInstance().metadata == nil || SPTAudioStreamingController.sharedInstance().metadata.currentTrack == nil {
            self.heartViewImage.image = nil
            return
        }
        self.forwardBtn.isEnabled = SPTAudioStreamingController.sharedInstance().metadata.nextTrack != nil
        self.backBtn.isEnabled = SPTAudioStreamingController.sharedInstance().metadata.prevTrack != nil
        self.songName.text = SPTAudioStreamingController.sharedInstance().metadata.currentTrack?.name
        self.artistName.text = SPTAudioStreamingController.sharedInstance().metadata.currentTrack?.artistName
        
        SPTTrack.track(withURI: URL(string: SPTAudioStreamingController.sharedInstance().metadata.currentTrack!.uri)!, accessToken: auth.session!.accessToken, market: nil) { error, result in
            
            if let track = result as? SPTTrack {
                let imageURL = track.album.largestCover.imageURL
                if imageURL == nil {
                    print("Album \(track.album) doesn't have any images!")
                    self.heartViewImage.image = nil
                    return
                }
                DispatchQueue.global().async {
                    do {
                        let imageData = try Data(contentsOf: imageURL, options: [])
                        let image = UIImage(data: imageData)
                        // …and back to the main queue to display the image.
                        DispatchQueue.main.async {
//                            self.spinner.stopAnimating()
                            self.heartViewImage.image = image
                            if image == nil {
                                print("Couldn't load cover image with error: \(error as Any)")
                                return
                            }
                        }
                        
//                        let blurred = self.applyBlur(on: image!, withRadius: 10.0)
//                        DispatchQueue.main.async {
//                            self.backgroundImg.image = blurred
//                        }
                        
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        
    }
    
    func handleNewSession() {
        print("New session")
        do {
            print("Inside the handle new session do")
            try SPTAudioStreamingController.sharedInstance().start(withClientId: auth.clientID!, audioController: nil, allowCaching: true)
            SPTAudioStreamingController.sharedInstance().delegate = self
            SPTAudioStreamingController.sharedInstance().playbackDelegate = self
            SPTAudioStreamingController.sharedInstance().diskCache = SPTDiskCache() /* caapacity: 1024 * 1024 * 64 */
            SPTAudioStreamingController.sharedInstance().login(withAccessToken: (auth.session?.accessToken)!)
        } catch let error {
            let alert = UIAlertController(title: "Error init", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.closeSession()
        }
    }

    
    @IBAction func onPlay(_ sender: Any) {
        print("PLAY CLICKED")
        SPTAudioStreamingController.sharedInstance().setIsPlaying(!SPTAudioStreamingController.sharedInstance().playbackState.isPlaying, callback: nil)

        if SPTAudioStreamingController.sharedInstance().playbackState.isPlaying {
            (sender as! UIButton).setImage(self.pause,for: UIControlState.normal);
            buttonClicked = true;
        } else {
            (sender as! UIButton).setImage(self.play,for: UIControlState.normal);
            buttonClicked = false;
        }
    }
    
    @IBAction func onForwardClick(_ sender: Any) {
        SPTAudioStreamingController.sharedInstance().skipNext { (error: Error?) in
        }
    }
    
    @IBAction func onBackClick(_ sender: Any) {
        SPTAudioStreamingController.sharedInstance().skipPrevious{ (error: Error?) in
        }
    }
    
    func closeSession() {
        do {
            try SPTAudioStreamingController.sharedInstance().stop()
            auth.session = nil
//            _ = self.navigationController!.popViewController(animated: true)
        } catch let error {
            let alert = UIAlertController(title: "Error deinit", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController, didReceiveMessage message: String) {
        let alert = UIAlertController(title: "Message from Spotify", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController, didChangePlaybackStatus isPlaying: Bool) {
        print("is playing = \(isPlaying)")
        if isPlaying {
            self.activateAudioSession()
        }
        else {
            self.deactivateAudioSession()
        }
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController, didChange metadata: SPTPlaybackMetadata) {
        self.updateUI()
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController, didReceive event: SpPlaybackEvent, withName name: String) {
        print("didReceivePlaybackEvent: \(event) \(name)")
        print("isPlaying=\(SPTAudioStreamingController.sharedInstance().playbackState.isPlaying) isRepeating=\(SPTAudioStreamingController.sharedInstance().playbackState.isRepeating) isShuffling=\(SPTAudioStreamingController.sharedInstance().playbackState.isShuffling) isActiveDevice=\(SPTAudioStreamingController.sharedInstance().playbackState.isActiveDevice) positionMs=\(SPTAudioStreamingController.sharedInstance().playbackState.position)")
    }
    
    func audioStreamingDidLogout(_ audioStreaming: SPTAudioStreamingController) {
        self.closeSession()
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController, didReceiveError error: Error?) {
        print("didReceiveError: \(error!.localizedDescription)")
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController, didChangePosition position: TimeInterval) {
        let positionDouble = Double(position)
        let durationDouble = Double(SPTAudioStreamingController.sharedInstance().metadata.currentTrack!.duration)
//        self.progressSlider.value = Float(positionDouble / durationDouble)
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController, didStartPlayingTrack trackUri: String) {
        print("Starting \(trackUri)")
        print("Source \(SPTAudioStreamingController.sharedInstance().metadata.currentTrack?.playbackSourceUri)")
        // If context is a single track and the uri of the actual track being played is different
        // than we can assume that relink has happended.
        let isRelinked = SPTAudioStreamingController.sharedInstance().metadata.currentTrack!.playbackSourceUri.contains("spotify:track") && !(SPTAudioStreamingController.sharedInstance().metadata.currentTrack!.playbackSourceUri == trackUri)
        print("Relinked \(isRelinked)")
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController, didStopPlayingTrack trackUri: String) {
        print("Finishing: \(trackUri)")
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController) {
        self.updateUI()
        print("Audio Streaming Did Login")
        SPTAudioStreamingController.sharedInstance().playSpotifyURI("spotify:user:spotify:playlist:37i9dQZF1DWSJHnPb1f0X3", startingWith: 0, startingWithPosition: 10) { error in
            if error != nil {
                print("*** failed to play: \(error)")
                return
            }
        }
    }
    
    func activateAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch let error {
            print("Audio Session activate error: \(error.localizedDescription)")
        }
    }
    
    func deactivateAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        }
        catch let error {
            print("Audio Session deactivate error: \(error.localizedDescription)")
        }
    }
    
    func applyBlur(on imageToBlur: UIImage, withRadius blurRadius: CGFloat) -> UIImage {
        let originalImage = CIImage(cgImage: imageToBlur.cgImage!)
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(originalImage, forKey: "inputImage")
        filter?.setValue(blurRadius, forKey: "inputRadius")
        let outputImage = filter?.outputImage
        let context = CIContext(options: nil)
        let outImage = context.createCGImage(outputImage!, from: outputImage!.extent)
        let ret = UIImage(cgImage: outImage!)
        return ret
    }
}
