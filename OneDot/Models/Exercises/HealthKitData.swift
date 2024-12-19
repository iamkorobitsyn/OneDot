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
    var totalDistance: Double
    var climb: Double
    let heartRate: Double
    var calloriesBurned: Double
    
}

struct HealthkitDataStringRepresentation {
    
    let workoutType: String
    let startDate: String
    let endDate: String
    var duration: String
    var totalDistance: String
    var climb: String
    let heartRate: String
    var calloriesBurned: String
    
}

extension HealthKitData {
    
    func stringRepresentation() -> HealthkitDataStringRepresentation {
        
        let stringWorkoutType = workoutType
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let stringStartDate = dateFormatter.string(from: startDate)
        let stringEndDate = dateFormatter.string(from: endDate)
        
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        let seconds = Int(duration) % 60
        let stringDuration = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        
        let kilometers = totalDistance / 1000
        let roundedKilometers = String(format: "%.1f", kilometers)
        let stringTotalDistance = "\(roundedKilometers) km"
        
        let stringClimb = "\(climb)"
        
        let stringHeartRate = "\(Int(heartRate))"
        
        let stringCalloriesBurned = "\(Int(calloriesBurned))"
        
        return HealthkitDataStringRepresentation(
            workoutType: stringWorkoutType,
            startDate: stringStartDate,
            endDate: stringEndDate,
            duration: stringDuration,
            totalDistance: stringTotalDistance,
            climb: stringClimb,
            heartRate: stringHeartRate,
            calloriesBurned: stringCalloriesBurned)
    }
}
