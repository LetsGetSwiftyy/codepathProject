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
    @IBOutlet var heartRateLabel: WKInterfaceLabel!
    @IBOutlet var controlButton: WKInterfaceButton!
    @IBOutlet var heartImageView: WKInterfaceGroup!
    
    private let workoutManager = WorkoutManager()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    
        heartBeating()
    }
    
    func heartBeating() {
        heartImageView.setBackgroundImageNamed("heart-")
        heartImageView.startAnimatingWithImages(in: NSMakeRange(0, 7), duration: 0.5, repeatCount: -1)
    }

    override func willActivate() {
        super.willActivate()
        
        // Configure workout manager.
        workoutManager.delegate = self as? WorkoutManagerDelegate
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func didTapButton() {
        switch workoutManager.state {
        case .started:
            // Stop current workout.
            workoutManager.stop()
            print("Stopped")
            break
        case .stopped:
            // Start new workout.
            workoutManager.start()
            print("Started")
            break
        }
    }

}

// MARK: - Workout Manager Delegate

extension InterfaceController: WorkoutManagerDelegate {
    
    func workoutManager(_ manager: WorkoutManager, didChangeStateTo newState: WorkoutState) {
        // Update title of control button.
        controlButton.setTitle(newState.actionText())
    }
    
    func workoutManager(_ manager: WorkoutManager, didChangeHeartRateTo newHeartRate: HeartRate) {
        // Update heart rate label.
        //controlButton.setTitle(String(format: "%.0f", newHeartRate.bpm))
    }
    
}
