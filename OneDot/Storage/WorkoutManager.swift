//
//  WorkoutManager.swift
//  OneDot
//
//  Created by Александр Коробицын on 28.01.2025.
//

import Foundation
import HealthKit

class WorkoutManager {
    
    static let shared = WorkoutManager()
    
    private let healthStore = HKHealthStore()
    
    // Функция для записи тренировки с данными в HealthKit
    func saveWorkout(activityType: HKWorkoutActivityType, locationType: HKWorkoutSessionLocationType,
                     startDate: Date, duration: Double, energyBurned: Double,
                     distance: Double,
                     completion: @escaping (Bool, Error?) -> Void) {
        
        let typesToShare: Set<HKSampleType> = [
            HKObjectType.workoutType(),
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
        ]

        let typesToRead: Set<HKObjectType> = [
            HKObjectType.workoutType(),
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
        ]

        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
            if success {
                
                let configuration = HKWorkoutConfiguration()
                configuration.activityType = activityType
                configuration.locationType = locationType
                
                let builder = HKWorkoutBuilder(healthStore: self.healthStore, configuration: configuration, device: nil)
                let startDate = startDate
                let endDate = startDate.addingTimeInterval(duration)
                
                builder.beginCollection(withStart: startDate) { success, error in
                    if success {
                        
                        let energyQuantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: energyBurned)
                        let distanceQuantity = HKQuantity(unit: HKUnit.meter(), doubleValue: distance)
                        
                        let energySample = HKQuantitySample(
                            type: HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
                            quantity: energyQuantity,
                            start: startDate,
                            end: endDate
                        )
                        
                        let distanceSample = HKQuantitySample(
                            type: HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                            quantity: distanceQuantity,
                            start: startDate,
                            end: endDate
                        )
                        
                        builder.add([energySample, distanceSample]) { success, error in
                            if success {
                                print("Данные добавлены.")
                                
                                builder.endCollection(withEnd: endDate) { success, error in
                                    if success {
                                        builder.finishWorkout { workout, error in
                                            if let workout = workout {
                                                print("Тренировка сохранена: \(workout)")
                                                completion(true, nil)
                                            } else {
                                                print("Ошибка при сохранении тренировки: \(String(describing: error))")
                                                completion(false, error)
                                            }
                                        }
                                    } else {
                                        print("Ошибка при завершении сбора данных: \(String(describing: error))")
                                        completion(false, error)
                                    }
                                }
                            } else {
                                print("Ошибка при добавлении данных: \(String(describing: error))")
                                completion(false, error)
                            }
                        }
                    } else {
                        print("Ошибка при начале сбора данных: \(String(describing: error))")
                        completion(false, error)
                    }
                }
            } else {
                print("Ошибка при запросе разрешений: \(String(describing: error))")
                completion(false, error)
            }
        }
    }
}
