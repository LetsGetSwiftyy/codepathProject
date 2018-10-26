//
//  HKUnit+BeatsPerMinute.swift
//  watchApp Extension
//
//  Created by Francisco Hernanedez on 10/23/18.
//  Copyright © 2018 Francisco Hernanedz. All rights reserved.
//

import HealthKit

extension HKUnit {
    
    static func beatsPerMinute() -> HKUnit {
        return HKUnit.count().unitDivided(by: HKUnit.minute())
    }
    
}
