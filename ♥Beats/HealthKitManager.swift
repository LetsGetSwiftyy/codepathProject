//
//  HealthKitManager.swift
//  ♥Beats
//
//  Created by Francisco Hernanedez on 10/23/18.
//  Copyright © 2018 Francisco Hernanedz. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitManager: NSObject {
    
    static let healthKitStore = HKHealthStore()
    
    static func authorizeHealthKit() -> Bool {
        
        var authorized: Bool!
        
        let healthKitTypes: Set = [
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!
        ]
        
        healthKitStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { (success, error) in
            if success {
                authorized = true
            }
            else
            {
                authorized = false
            }
        }
        
        return authorized
    }
}
