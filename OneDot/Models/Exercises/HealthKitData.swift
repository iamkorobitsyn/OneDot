//
//  Workout.swift
//  OneDot
//
//  Created by Александр Коробицын on 09.12.2024.
//

import Foundation
import CoreLocation

struct HealthKitData {
    struct Workout {
        let workoutType: String
        let startDate: Date
        let endDate: Date

        var duration: TimeInterval
        var totalDistance: Double?
        var calloriesBurned: Double
    }
    
    struct HeartRate {
        let timestamp: Date?
        let bpm: Double?
    }
    
    struct Route {
        let locations: [CLLocation]?
    }
    
    var workout: Workout
    let heartRates: HeartRate?
    let route: Route?
}
