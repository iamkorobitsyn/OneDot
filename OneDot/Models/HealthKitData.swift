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
    var pace: Int
    var climbing: Double
    let heartRate: Double
    var calloriesBurned: Double
    var stepCount: Int
    var cadence: Int
}

struct HealthKitCoordinates {
    let coordinates2D: [CLLocationCoordinate2D]
    let climbing: Double
}

struct HealthkitDataStringRepresentation {
    
    let workoutType: String
    let startDate: String
    let endDate: String
    var duration: String
    var totalDistance: String
    var pace: String
    var climbing: String
    let heartRate: String
    var calloriesBurned: String
    var stepCount: String
    var cadence: String
}

extension HealthKitData {
    
    mutating func updateClimbing(altitube: Double) {
        climbing = altitube
    }
    
    func stringRepresentation() -> HealthkitDataStringRepresentation {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let stringStartDate = dateFormatter.string(from: startDate)
        let stringEndDate = dateFormatter.string(from: endDate)
        
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        let seconds = Int(duration) % 60
        let stringDuration = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        
        let kilometers = totalDistance / 1000
        let roundedKilometers = String(format: "%.2f", kilometers)
        
        let paceMin = pace / 60
        let paceSec = pace % 60

        return HealthkitDataStringRepresentation(
            workoutType: workoutType,
            startDate: stringStartDate,
            endDate: stringEndDate,
            duration: stringDuration,
            totalDistance: "\(roundedKilometers) km",
            pace: String(format: "%02d:%02d", paceMin, paceSec),
            climbing: "\(Int(climbing)) m",
            heartRate: "\(Int(heartRate))",
            calloriesBurned: "\(Int(calloriesBurned))",
            stepCount: "\(stepCount)",
            cadence: "\(cadence)")
    }
}
