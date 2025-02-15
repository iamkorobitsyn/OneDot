//
//  InTheRoomExercises.swift
//  OneDot
//
//  Created by Александр Коробицын on 26.10.2023.
//

import Foundation

class SwimmingPool: Workout {
    let averageCalBurnedPerSec: Double = 0.158
    let name: String = "Swimming pool"
    let pickerIconName: String = "SwimmingPoolGray"
    let workoutIconName: String = "SwimmingPoolWhite"
}

class Stepper: Workout {
    let averageCalBurnedPerSec: Double = 0.143
    let name: String = "Stepper"
    let pickerIconName: String = "StepperGray"
    let workoutIconName: String = "StepperWhite"
}

class Treadmill: Workout {
    let averageCalBurnedPerSec: Double = 0.211
    let name: String = "Treadmill"
    let pickerIconName: String = "TreadmillGray"
    let workoutIconName: String = "TreadmillWhite"
}

class ExerciseBike: Workout {
    let averageCalBurnedPerSec: Double = 0.133
    let name: String = "Exercise bike"
    let pickerIconName: String = "ExerciseBikeGray"
    let workoutIconName: String = "ExerciseBikeWhite"
}

class RecumbentExercise: Workout {
    let averageCalBurnedPerSec: Double = 0.107
    let name: String = "Recumbent bike"
    let pickerIconName: String = "RecumbentBikeGray"
    let workoutIconName: String = "RecumbentBikeWhite"
}

class StrengthTraining: Workout {
    let averageCalBurnedPerSec: Double = 0.098
    let name: String = "Strength training"
    let pickerIconName: String = "StrengthTrainingGray"
    let workoutIconName: String = "StrengthTrainingWhite"
}

class FusionWorkout: Workout {
    let averageCalBurnedPerSec: Double = 0.120
    let name: String = "Fusion workout"
    let pickerIconName: String = "FusionWorkoutGray"
    let workoutIconName: String = "FusionWorkoutWhite"
}

class Stretching: Workout {
    let averageCalBurnedPerSec: Double = 0.053
    let name: String = "Stretching"
    let pickerIconName: String = "StretchingGray"
    let workoutIconName: String = "StretchingWhite"
}

class Yoga: Workout {
    let averageCalBurnedPerSec: Double = 0.047
    let name: String = "Yoga"
    let pickerIconName: String = "YogaGray"
    let workoutIconName: String = "YogaWhite"
}


