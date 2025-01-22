//
//  WorkoutManager.swift
//  OneDot
//
//  Created by Александр Коробицын on 22.01.2025.
//

import Foundation
import HealthKit

class WorkoutSession: HKWorkoutSession {
    
    let healthStore: HKHealthStore?
    
    
    init(healthStore: HKHealthStore, configuration workoutConfiguration: HKWorkoutConfiguration) throws {
        let workoutConfiguration = HKWorkoutConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
