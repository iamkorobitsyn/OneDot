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
    var totalDistance: Double
    var pace: Int
    let heartRate: Double
    var calloriesBurned: Double
    var stepCount: Int
    var cadence: Int
}


