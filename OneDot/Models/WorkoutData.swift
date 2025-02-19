//
//  Workout.swift
//  OneDot
//
//  Created by Александр Коробицын on 09.12.2024.
//

import Foundation

protocol Workout {
    var averageCalBurnedPerSec: Double {get}
    var name: String {get}
    var pickerIconName: String {get}
    var workoutIconName: String {get}
}

struct WorkoutData {
    
    let workoutName: String
    var associatedName: String
    let startDate: Date
    let endDate: Date
    var duration: TimeInterval
    var calloriesBurned: Double
    var distance: Double
    var pace: Int
    let heartRate: Double
    var cadence: Int
    var stepCount: Int
}

struct WorkoutStatistics {
    let duration: String
    let calloriesBurned: String
    let distance: String
    let averagePace: String
    let averageHeartRate: String
    let averageCadence: String
}


