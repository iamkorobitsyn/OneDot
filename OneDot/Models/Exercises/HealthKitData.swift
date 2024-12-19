//
//  Workout.swift
//  OneDot
//
//  Created by Александр Коробицын on 09.12.2024.
//

import Foundation
import CoreLocation

struct HealthKitData {
    
    let workoutType: String
    let startDate: Date
    let endDate: Date
    var duration: TimeInterval
    var totalDistance: Double?
    let heartRate: Double?
    var calloriesBurned: Double?
}
