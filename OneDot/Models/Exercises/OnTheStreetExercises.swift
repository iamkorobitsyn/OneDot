//
//  OnTheStreetExercises.swift
//  OneDot
//
//  Created by Александр Коробицын on 26.10.2023.
//

import Foundation

class Swimming: Workout {
    let averageCalBurnedPerSec: Double = 0.175
    let name: String = "Swimming"
    let pickerIconName: String = "SwimmingGray"
    let workoutIconName: String = "SwimmingWhite"
}

class Paddle: Workout {
    let averageCalBurnedPerSec: Double = 0.126
    let name: String = "Paddle"
    let pickerIconName: String = "PaddleGray"
    let workoutIconName: String = "PaddleWhite"
}

class Hiking: Workout {
    let averageCalBurnedPerSec: Double = 0.116
    let name: String = "Hiking"
    let pickerIconName: String = "HikingGray"
    let workoutIconName: String = "HikingWhite"
}

class Running: Workout {
    let averageCalBurnedPerSec: Double = 0.229
    let name: String = "Running"
    let pickerIconName: String = "RunningGray"
    let workoutIconName: String = "RunningWhite"
}

class Cycling: Workout {
    let averageCalBurnedPerSec: Double = 0.156
    var name: String = "Cycling"
    var pickerIconName: String = "CycleGray"
    let workoutIconName: String = "CycleWhite"
}

class Board: Workout {
    let averageCalBurnedPerSec: Double = 0.087
    let name: String = "Board"
    let pickerIconName: String = "BoardGray"
    let workoutIconName: String = "BoardWhite"
}

class RollerSkates: Workout {
    let averageCalBurnedPerSec: Double = 0.143
    let name: String = "Roller skates"
    let pickerIconName: String = "RollerSkatesGray"
    let workoutIconName: String = "RollerSkatesWhite"
}

class Skates: Workout {
    let averageCalBurnedPerSec: Double = 0.133
    let name: String = "Skates"
    let pickerIconName: String = "SkatesGray"
    let workoutIconName: String = "SkatesWhite"
}

class Skis: Workout {
    let averageCalBurnedPerSec: Double = 0.166
    let name: String = "Skis"
    let pickerIconName: String = "SkisGray"
    let workoutIconName: String = "SkisWhite"
}

class Snowboard: Workout {
    let averageCalBurnedPerSec: Double = 0.116
    let name: String = "Snowboard"
    let pickerIconName: String = "SnowboardGray"
    let workoutIconName: String = "SnowboardWhite"
}
