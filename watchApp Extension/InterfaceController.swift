//
//  InterfaceController.swift
//  watchApp Extension
//
//  Created by Francisco Hernanedez on 10/23/18.
//  Copyright © 2018 Francisco Hernanedz. All rights reserved.
//

import WatchKit
import WatchConnectivity

class InterfaceController: WKInterfaceController {
    
    // MARK: - Outlets
    
    @IBOutlet var heartRateLabel: WKInterfaceLabel!
    @IBOutlet var controlButton: WKInterfaceButton!
    @IBOutlet var displayLabel: WKInterfaceLabel!
    
    var HeartBeat: String?
    var session : WCSession?
    var timer = Timer()
    
    // MARK: - Properties
    
    private let workoutManager = WorkoutManager()
    
    // MARK: - Lifecycle
    
    override func willActivate() {
        super.willActivate()
        
        // Configure workout manager.
        workoutManager.delegate = self
    }
    override init(){
        
        //  super class init
        super.init()
        
        //  if WCSession is supported
        if WCSession.isSupported() {    //  it is supported
            
            //  get default session
            session = WCSession.default
            
            //  set delegate
            session!.delegate = self
            
            //  activate session
            session!.activate()
        } else {
            
            print("Watch does not support WCSession")
        }
    }
    
    // MARK: - Actions
    
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
    
    @IBAction func didTapSend() {
        sendHeartBeat()
    }
    
    
    func sendHeartBeat(){
        //  if WCSession is reachable
        if session!.isReachable {     //  it is reachable
            
            //  create the interactive message
            let message : [String : Any]
            message = [
                "Type":"HeartBeat",
                "Content":HeartBeat
            ]
            
            //  send message
            session!.sendMessage(message, replyHandler: {(_ replyMessage: [String: Any]) -> Void in
                
                print("ReplyHandler called = \(replyMessage)")}, errorHandler: { (error) -> Void in
                    print("Watch send HeartBeat failed with error \(error)")})
            
            
            
            print("Watch send HeartBeat \(String(describing: HeartBeat))")
            
        } else{                 //  it is not reachable
            
            print("WCSession is not reachable")
        }
    }
    
}




// MARK: - WCSessionDelegate

extension InterfaceController: WCSessionDelegate{
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
    }
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
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
        heartRateLabel.setText(String(format: "%.0f", newHeartRate.bpm))
        HeartBeat = String(format: "%.0f", newHeartRate.bpm)
    }
    
}
