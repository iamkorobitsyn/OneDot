//
//  OnTheStreetExercises.swift
//  OneDot
//
//  Created by Александр Коробицын on 26.10.2023.
//

import Foundation
import HealthKit

class Swimming: Workout {
    let type: HKWorkoutActivityType = HKWorkoutActivityType.swimming
    let checkLocation: Bool = true
    let titleName: String = "SWIMMING"
    let pickerViewIcon: String = "SwimmingGray"
    let workoutVCIcon: String = "SwimmingWhite"
}

class Paddle: Workout {
    let type: HKWorkoutActivityType = HKWorkoutActivityType.paddleSports
    let checkLocation: Bool = true
    let titleName: String = "PADDLE"
    let pickerViewIcon: String = "PaddleGray"
    let workoutVCIcon: String = "PaddleWhite"
}

class Hiking: Workout {
    let type: HKWorkoutActivityType = HKWorkoutActivityType.hiking
    let checkLocation: Bool = true
    let titleName: String = "HIKING"
    let pickerViewIcon: String = "HikingGray"
    let workoutVCIcon: String = "HikingWhite"
}

class Running: Workout {
    let type: HKWorkoutActivityType = HKWorkoutActivityType.running
    let checkLocation: Bool = true
    let titleName: String = "RUNNING"
    let pickerViewIcon: String = "RunningGray"
    let workoutVCIcon: String = "RunningWhite"
}

class Cycling: Workout {
    let type: HKWorkoutActivityType = HKWorkoutActivityType.cycling
    let checkLocation: Bool = true
    var titleName: String = "CYCLING"
    var pickerViewIcon: String = "CycleGray"
    let workoutVCIcon: String = "CycleWhite"
}

class Board: Workout {
    let type: HKWorkoutActivityType = HKWorkoutActivityType.skatingSports
    let checkLocation: Bool = true
    let titleName: String = "BOARD"
    let pickerViewIcon: String = "BoardGray"
    let workoutVCIcon: String = "BoardWhite"
}

class RollerSkates: Workout {
    let type: HKWorkoutActivityType = HKWorkoutActivityType.skatingSports
    let checkLocation: Bool = true
    let titleName: String = "ROLLER SKATES"
    let pickerViewIcon: String = "RollerSkatesGray"
    let workoutVCIcon: String = "RollerSkatesWhite"
}

class Skates: Workout {
    let type: HKWorkoutActivityType = HKWorkoutActivityType.skatingSports
    let checkLocation: Bool = true
    let titleName: String = "SKATES"
    let pickerViewIcon: String = "SkatesGray"
    let workoutVCIcon: String = "SkatesWhite"
}

class Skis: Workout {
    let type: HKWorkoutActivityType = HKWorkoutActivityType.snowSports
    let checkLocation: Bool = true
    let titleName: String = "SKIS"
    let pickerViewIcon: String = "SkisGray"
    let workoutVCIcon: String = "SkisWhite"
}

class Snowboard: Workout {
    let type: HKWorkoutActivityType = HKWorkoutActivityType.snowboarding
    let checkLocation: Bool = true
    let titleName: String = "SNOWBOARD"
    let pickerViewIcon: String = "SnowboardGray"
    let workoutVCIcon: String = "SnowboardWhite"
}
