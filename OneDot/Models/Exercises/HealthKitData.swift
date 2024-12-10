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
    }
    
    struct Distance {
        var totalDistance: Double?
    }
    
    struct Route {
        let locations: [CLLocation]?
    }
    
    struct HeartRate {
        let timestamp: Date?
        let bpm: Double?
    }
    
    struct CalloriesBurned {
        var calloriesBurned: Double?
    }
    
    let workout: Workout
    let distance: Distance?
    let route: Route?
    let heartRates: HeartRate?
    let calloriesBurned: CalloriesBurned?
}
