//
//  FactoryExercises.swift
//  OneDot
//
//  Created by Александр Коробицын on 26.10.2023.
//

import Foundation

class FactoryWorkouts {
    
    func get(isGeoTracking: Bool) -> [Workout] {
        if isGeoTracking {
            var exerciseList = [Workout]()
            
            let swimming = Swimming()
            exerciseList.append(swimming)
            
            let paddle = Paddle()
            exerciseList.append(paddle)
            
            let hiking = Hiking()
            exerciseList.append(hiking)
            
            let running = Running()
            exerciseList.append(running)
            
            let bycicle = Cycling()
            exerciseList.append(bycicle)
            
            let board = Board()
            exerciseList.append(board)
            
            let rollerSkates = RollerSkates()
            exerciseList.append(rollerSkates)
            
            let skates = Skates()
            exerciseList.append(skates)
            
            let skis = Skis()
            exerciseList.append(skis)
            
            let snowboard = Snowboard()
            exerciseList.append(snowboard)
            
            return exerciseList
        } else {
            var exerciseList = [Workout]()
            
            let swimmingPool = SwimmingPool()
            exerciseList.append(swimmingPool)
            
            let stepper = Stepper()
            exerciseList.append(stepper)
            
            let treadmill = Treadmill()
            exerciseList.append(treadmill)
            
            let exerciseBike = ExerciseBike()
            exerciseList.append(exerciseBike)
            
            let recumbentExercise = RecumbentExercise()
            exerciseList.append(recumbentExercise)
            
            let strengthTraining = StrengthTraining()
            exerciseList.append(strengthTraining)
            
            let fusionWorkout = FusionWorkout()
            exerciseList.append(fusionWorkout)
            
            let stretching = Stretching()
            exerciseList.append(stretching)
            
            let yoga = Yoga()
            exerciseList.append(yoga)
            
            return exerciseList
        }
    }
}
