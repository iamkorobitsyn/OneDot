//
//  OnTheStreetExercises.swift
//  OneDot
//
//  Created by Александр Коробицын on 26.10.2023.
//

import Foundation
import HealthKit

class Swimming: Workout {
    let activityType: HKWorkoutActivityType = HKWorkoutActivityType.swimming
    let locationType: HKWorkoutSessionLocationType = .outdoor
    let averageCalBurnedPerSec: Double = 0.175
    let titleName: String = "SWIMMING"
    let pickerViewIcon: String = "SwimmingGray"
    let workoutVCIcon: String = "SwimmingWhite"
}

class Paddle: Workout {
    let activityType: HKWorkoutActivityType = HKWorkoutActivityType.paddleSports
    let locationType: HKWorkoutSessionLocationType = .outdoor
    let averageCalBurnedPerSec: Double = 0.126
    let titleName: String = "PADDLE"
    let pickerViewIcon: String = "PaddleGray"
    let workoutVCIcon: String = "PaddleWhite"
}

class Hiking: Workout {
    let activityType: HKWorkoutActivityType = HKWorkoutActivityType.hiking
    let locationType: HKWorkoutSessionLocationType = .outdoor
    let averageCalBurnedPerSec: Double = 0.116
    let titleName: String = "HIKING"
    let pickerViewIcon: String = "HikingGray"
    let workoutVCIcon: String = "HikingWhite"
}

class Running: Workout {
    let activityType: HKWorkoutActivityType = HKWorkoutActivityType.running
    let locationType: HKWorkoutSessionLocationType = .outdoor
    let averageCalBurnedPerSec: Double = 0.229
    let titleName: String = "RUNNING"
    let pickerViewIcon: String = "RunningGray"
    let workoutVCIcon: String = "RunningWhite"
}

class Cycling: Workout {
    let activityType: HKWorkoutActivityType = HKWorkoutActivityType.cycling
    let locationType: HKWorkoutSessionLocationType = .outdoor
    let averageCalBurnedPerSec: Double = 0.156
    var titleName: String = "CYCLING"
    var pickerViewIcon: String = "CycleGray"
    let workoutVCIcon: String = "CycleWhite"
}

class Board: Workout {
    let activityType: HKWorkoutActivityType = HKWorkoutActivityType.skatingSports
    let locationType: HKWorkoutSessionLocationType = .outdoor
    let averageCalBurnedPerSec: Double = 0.087
    let titleName: String = "BOARD"
    let pickerViewIcon: String = "BoardGray"
    let workoutVCIcon: String = "BoardWhite"
}

class RollerSkates: Workout {
    let activityType: HKWorkoutActivityType = HKWorkoutActivityType.skatingSports
    let locationType: HKWorkoutSessionLocationType = .outdoor
    let averageCalBurnedPerSec: Double = 0.143
    let titleName: String = "ROLLER SKATES"
    let pickerViewIcon: String = "RollerSkatesGray"
    let workoutVCIcon: String = "RollerSkatesWhite"
}

class Skates: Workout {
    let activityType: HKWorkoutActivityType = HKWorkoutActivityType.skatingSports
    let locationType: HKWorkoutSessionLocationType = .outdoor
    let averageCalBurnedPerSec: Double = 0.133
    let titleName: String = "SKATES"
    let pickerViewIcon: String = "SkatesGray"
    let workoutVCIcon: String = "SkatesWhite"
}

class Skis: Workout {
    let activityType: HKWorkoutActivityType = HKWorkoutActivityType.snowSports
    let locationType: HKWorkoutSessionLocationType = .outdoor
    let averageCalBurnedPerSec: Double = 0.166
    let titleName: String = "SKIS"
    let pickerViewIcon: String = "SkisGray"
    let workoutVCIcon: String = "SkisWhite"
}

class Snowboard: Workout {
    let activityType: HKWorkoutActivityType = HKWorkoutActivityType.snowboarding
    let locationType: HKWorkoutSessionLocationType = .outdoor
    let averageCalBurnedPerSec: Double = 0.116
    let titleName: String = "SNOWBOARD"
    let pickerViewIcon: String = "SnowboardGray"
    let workoutVCIcon: String = "SnowboardWhite"
}
