//
//  CalculationsService.swift
//  OneDot
//
//  Created by Александр Коробицын on 27.01.2025.
//

import Foundation

class CalculationsService {
    
    static let shared = CalculationsService()
    private init() {}
    
    typealias UD = UserDefaultsManager
    
    
    //MARK: - GetWorkoutsAverageValues
    
    func getWorkoutStatistics(workoutList: [WorkoutData], segmenterIndex: Int) -> WorkoutStatistics {
        
        let endDate = Date()
        var filteredWorkouts: [WorkoutData] = []
        
        switch segmenterIndex {
        case 0:
            if let startDate = Calendar.current.date(byAdding: .day, value: -7, to: endDate) {
                filteredWorkouts = getFilteredWorkouts(startDate: startDate, endDate: endDate)
            }
        case 1:
            if let startDate = Calendar.current.date(byAdding: .month, value: -1, to: endDate) {
                filteredWorkouts = getFilteredWorkouts(startDate: startDate, endDate: endDate)
            }
        case 2:
            if let startDate = Calendar.current.date(byAdding: .year, value: -1, to: endDate) {
                filteredWorkouts = getFilteredWorkouts(startDate: startDate, endDate: endDate)
            }
        default:
            filteredWorkouts = workoutList
        }
        
        func getFilteredWorkouts(startDate: Date, endDate: Date) -> [WorkoutData] {
            let lastWeekInterval = DateInterval(start: startDate, end: endDate)
            return workoutList.filter { workout in
                    lastWeekInterval.contains(workout.startDate)
                }
        }
  
        
        var duration: TimeInterval = 0
        var caloriesBurned: Double = 0
        var distance: Double = 0
        var pace: Int = 0
        var heartRate: Double = 0
        var cadence: Int = 0
        
        filteredWorkouts.forEach { workout in
            duration += workout.duration
            caloriesBurned += workout.calloriesBurned
            distance += workout.distance
            pace += workout.pace
            heartRate += workout.heartRate
            cadence += workout.cadence
        }

        
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        let seconds = Int(duration) % 60
        let durationRepresentable = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        
        let caloriesRepresentable = String(format: "%.0f", caloriesBurned)
        
        let kilometers = distance / 1000
        let distanceRepresentable = String(format: "%.2f km", kilometers)
        
        pace /= filteredWorkouts.count
        let paceMin = pace / 60
        let paceSec = pace % 60
        let paceRepresentable = String(format: "%02d:%02d", paceMin, paceSec)
        
        heartRate /= Double(filteredWorkouts.count)
        let averageHeartRateRepresentable = String(format: "%.0f", heartRate)
        
        cadence /= filteredWorkouts.count
        let averageCadenceRepresentable = String(cadence)
        
        
        let statistics = WorkoutStatistics(duration: durationRepresentable,
                                           calloriesBurned: caloriesRepresentable,
                                           distance: distanceRepresentable,
                                           averagePace: paceRepresentable,
                                           averageHeartRate: averageHeartRateRepresentable,
                                           averageCadence: averageCadenceRepresentable)
        return statistics

    }
    
    //MARK: - FormatTime
    
    func formatTime(_ timeInterval: TimeInterval) -> String {
        if UserDefaultsManager.shared.workoutModeIs {
            let hours = Int(timeInterval) / 3600
            let minutes = Int(timeInterval) / 60 % 60
            let seconds = Int(timeInterval) % 60
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            let minutes = Int(timeInterval) / 60
            let seconds = Int(timeInterval) % 60
            let milliseconds = Int((timeInterval - Double(Int(timeInterval))) * 100)
            return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
        }
    }
    
    //MARK: - CalculationsTool
    
    func resetValues() {
        UD.shared.calculationsDistanceValue = 0
        UD.shared.calculationsDistanceDecimalValue = 0
        UD.shared.calculationsSpeedValue = 0
        UD.shared.calculationsSpeedDecimalValue = 0
        UD.shared.calculationsPaceMinValue = 0
        UD.shared.calculationsPaceSecValue = 0
        UD.shared.calculationsTimeHValue = 0
        UD.shared.calculationsTimeMinValue = 0
        UD.shared.calculationsTimeSecValue = 0
    }
    
    func calculateDistance() {
        
        let distanceValue = UD.shared.calculationsDistanceValue
        let distanceDecimalValue = UD.shared.calculationsDistanceDecimalValue
        let lengthOfDistance = distanceValue * 1000 + distanceDecimalValue * 100
        
        let paceMinValue = UD.shared.calculationsPaceMinValue
        let paceSecValue = UD.shared.calculationsPaceSecValue
        let paceOfSeconds = paceMinValue * 60 + paceSecValue
        
        let time = paceOfSeconds * lengthOfDistance / 1000
        
        UD.shared.calculationsTimeHValue = time / 3600
        UD.shared.calculationsTimeMinValue = time % 3600 / 60
        UD.shared.calculationsTimeSecValue = time % 3600 % 60
    }
    
    func calculateSpeed() {
        
        let distanceValue = UD.shared.calculationsDistanceValue
        let distanceDecimalValue = UD.shared.calculationsDistanceDecimalValue
        let lengthOfDistance = Double(distanceValue * 1000 + distanceDecimalValue * 100)
        
        let speedValue = UD.shared.calculationsSpeedValue
        let speedDecimalValue = UD.shared.calculationsSpeedDecimalValue
        let distancePerSecond = Double(speedValue * 1000 + speedDecimalValue * 100) / 3600
        
        let timeOfSeconds = lengthOfDistance / distancePerSecond
        let secondsPerDistance = timeOfSeconds / lengthOfDistance * 1000

        if UD.shared.calculationsSpeedValue != 0 || UD.shared.calculationsSpeedDecimalValue != 0 {
            UD.shared.calculationsTimeHValue = Int(timeOfSeconds) / 3600
            UD.shared.calculationsTimeMinValue = Int(timeOfSeconds) % 3600 / 60
            UD.shared.calculationsTimeSecValue = Int(timeOfSeconds) % 3600 % 60
            
            UD.shared.calculationsPaceMinValue = Int(secondsPerDistance) / 60
            UD.shared.calculationsPaceSecValue = Int(secondsPerDistance) % 60
        } else {
            UD.shared.calculationsTimeHValue = 0
            UD.shared.calculationsTimeMinValue = 0
            UD.shared.calculationsTimeSecValue = 0
            
            UD.shared.calculationsPaceMinValue = 0
            UD.shared.calculationsPaceSecValue = 0
        }
    }
    
    func calculatePace() {
        
        let distanceValue = UD.shared.calculationsDistanceValue
        let distanceDecimalValue = UD.shared.calculationsDistanceDecimalValue
        let lengthOfDistance = Double(distanceValue * 1000 + distanceDecimalValue * 100)
        
        let paceMinValue = UD.shared.calculationsPaceMinValue
        let paceSecValue = UD.shared.calculationsPaceSecValue
        let secondsPerDistance = Double(paceMinValue * 60 + paceSecValue) / 1000
        
        let timeOfSeconds = secondsPerDistance * lengthOfDistance
        let distancePerHour = lengthOfDistance / timeOfSeconds * 60 * 60

        if paceMinValue != 0 || paceSecValue != 0 {
            UD.shared.calculationsTimeHValue = Int(timeOfSeconds) / 3600
            UD.shared.calculationsTimeMinValue = Int(timeOfSeconds) % 3600 / 60
            UD.shared.calculationsTimeSecValue = Int(timeOfSeconds) % 3600 % 60
            
            UD.shared.calculationsSpeedValue = Int(distancePerHour / 1000)
            UD.shared.calculationsSpeedDecimalValue = Int(distancePerHour) % 1000 / 100
            
        } else {
            UD.shared.calculationsTimeHValue = 0
            UD.shared.calculationsTimeMinValue = 0
            UD.shared.calculationsTimeSecValue = 0
            
            UD.shared.calculationsSpeedValue = 0
            UD.shared.calculationsSpeedDecimalValue = 0
        }
    }
    
    func calculateTime() {
        
        let distanceValue = UD.shared.calculationsDistanceValue
        let distanceDecimalValue = UD.shared.calculationsDistanceDecimalValue
        let lengthOfDistance = Double(distanceValue * 1000 + distanceDecimalValue * 100)
        
        let timeHValue = UD.shared.calculationsTimeHValue
        let timeMinValue = UD.shared.calculationsTimeMinValue
        let timeSecValue = UD.shared.calculationsTimeSecValue
        let timeOfSeconds = Double(timeHValue * 3600 + timeMinValue * 60 + timeSecValue)

        let distancePerHour = lengthOfDistance / timeOfSeconds * 60 * 60
        let secondsPerDistance = timeOfSeconds / lengthOfDistance * 1000
        
        if timeHValue != 0 || timeMinValue != 0 || timeSecValue != 0 {
            UD.shared.calculationsSpeedValue = Int(distancePerHour / 1000)
            UD.shared.calculationsSpeedDecimalValue = Int(distancePerHour) % 1000 / 100
            
            UD.shared.calculationsPaceMinValue = Int(secondsPerDistance) / 60
            UD.shared.calculationsPaceSecValue = Int(secondsPerDistance) % 60
        } else {
            UD.shared.calculationsSpeedValue = 0
            UD.shared.calculationsSpeedDecimalValue = 0
            
            UD.shared.calculationsPaceMinValue = 0
            UD.shared.calculationsPaceSecValue = 0
        }
    }
}
