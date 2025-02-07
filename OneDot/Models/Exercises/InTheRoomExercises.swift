//
//  InTheRoomExercises.swift
//  OneDot
//
//  Created by Александр Коробицын on 26.10.2023.
//

import Foundation
import HealthKit

class SwimmingPool: Workout {
    let type: HKWorkoutActivityType = HKWorkoutActivityType.swimming
    let checkLocation: Bool = false
    let averageCalBurnedPerSec: Double = 0.158
    let titleName: String = "SWIMMING POOL"
    let pickerViewIcon: String = "SwimmingPoolGray"
    let workoutVCIcon: String = "SwimmingPoolWhite"
}

class Stepper: Workout {
    let type: HKWorkoutActivityType = HKWorkoutActivityType.stepTraining
    let checkLocation: Bool = false
    let averageCalBurnedPerSec: Double = 0.143
    let titleName: String = "STEPPER"
    let pickerViewIcon: String = "StepperGray"
    let workoutVCIcon: String = "StepperWhite"
}

class Treadmill: Workout {
    let type: HKWorkoutActivityType = HKWorkoutActivityType.running
    let checkLocation: Bool = false
    let averageCalBurnedPerSec: Double = 0.211
    let titleName: String = "TREADMILL"
    let pickerViewIcon: String = "TreadmillGray"
    let workoutVCIcon: String = "TreadmillWhite"
}

class ExerciseBike: Workout {
    let type: HKWorkoutActivityType = HKWorkoutActivityType.cycling
    let checkLocation: Bool = false
    let averageCalBurnedPerSec: Double = 0.133
    let titleName: String = "EXERCISE BIKE"
    let pickerViewIcon: String = "ExerciseBikeGray"
    let workoutVCIcon: String = "ExerciseBikeWhite"
}

class RecumbentExercise: Workout {
    let type: HKWorkoutActivityType = HKWorkoutActivityType.cycling
    let checkLocation: Bool = false
    let averageCalBurnedPerSec: Double = 0.107
    let titleName: String = "RECUMBENT BIKE"
    let pickerViewIcon: String = "RecumbentBikeGray"
    let workoutVCIcon: String = "RecumbentBikeWhite"
}

class StrengthTraining: Workout {
    let type: HKWorkoutActivityType = HKWorkoutActivityType.traditionalStrengthTraining
    let checkLocation: Bool = false
    let averageCalBurnedPerSec: Double = 0.098
    let titleName: String = "STRENGTH TRAINING"
    let pickerViewIcon: String = "StrengthTrainingGray"
    let workoutVCIcon: String = "StrengthTrainingWhite"
}

class FusionWorkout: Workout {
    let type: HKWorkoutActivityType = HKWorkoutActivityType.functionalStrengthTraining
    let checkLocation: Bool = false
    let averageCalBurnedPerSec: Double = 0.120
    let titleName: String = "FUSION WORKOUT"
    let pickerViewIcon: String = "FusionWorkoutGray"
    let workoutVCIcon: String = "FusionWorkoutWhite"
}

class Stretching: Workout {
    let type: HKWorkoutActivityType = HKWorkoutActivityType.gymnastics
    let checkLocation: Bool = false
    let averageCalBurnedPerSec: Double = 0.053
    let titleName: String = "STRETCHING"
    let pickerViewIcon: String = "StretchingGray"
    let workoutVCIcon: String = "StretchingWhite"
}

class Yoga: Workout {
    let type: HKWorkoutActivityType = HKWorkoutActivityType.yoga
    let checkLocation: Bool = false
    let averageCalBurnedPerSec: Double = 0.047
    let titleName: String = "YOGA"
    let pickerViewIcon: String = "YogaGray"
    let workoutVCIcon: String = "YogaWhite"
}


