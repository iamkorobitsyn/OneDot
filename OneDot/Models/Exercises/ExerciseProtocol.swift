//
//  OnTheStreetProtocol.swift
//  OneDot
//
//  Created by Александр Коробицын on 26.10.2023.
//

import Foundation
import HealthKit

protocol Workout {
    var activityType: HKWorkoutActivityType {get}
    var locationType: HKWorkoutSessionLocationType {get}
    var averageCalBurnedPerSec: Double {get}
    var titleName: String {get}
    var pickerViewIcon: String {get}
    var workoutVCIcon: String {get}
}
