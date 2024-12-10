//
//  HealthKitDataManager.swift
//  OneDot
//
//  Created by Александр Коробицын on 09.12.2024.
//

import Foundation
import HealthKit
import CoreLocation

class HealthKitDataManager {
    
    static let shared = HealthKitDataManager()
    
    private let healthStore: HKHealthStore = HKHealthStore()
    
    private init() {}
    
    enum HealthKitError: Error {
        case notAuthorized
        case noHealthKitData
        case noDistanceData
        case noRouteData
        case noHeartRateData
    }
    
    func fetchHealthkitData(completion: @escaping(Result<[HealthKitData], HealthKitError>) -> Void) {
        
        let workoutType: HKWorkoutType = HKWorkoutType.workoutType()
        
        guard let distanceType: HKObjectType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            completion(.failure(.noDistanceData))
            return
        }
        
        healthStore.requestAuthorization(toShare: nil, read: [workoutType, distanceType]) { success, error in
            
            if success {
                
                let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
                
                let query = HKSampleQuery(sampleType: workoutType,
                                          predicate: nil,
                                          limit: HKObjectQueryNoLimit,
                                          sortDescriptors: [sortDescriptor]) { _, samples, error in
                    
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                        completion(.failure(.noHealthKitData))
                        return
                    }
                    
                    guard let workouts = samples as? [HKWorkout] else {
                        completion(.failure(.noHealthKitData))
                        return
                    }
                    
                    let dispatchGroup = DispatchGroup()
                    var results: [HealthKitData] = []
                    
                    workouts.forEach { workout in
                        
                        
                        let workoutData = HealthKitData.Workout(workoutType: workout.workoutActivityType.name,
                                                                startDate: workout.startDate,
                                                                endDate: workout.endDate,
                                                                duration: workout.duration)
                        var distanceData = HealthKitData.Distance(totalDistance: 0)
                        
                        
                        
                        self.fetchWorkoutDistance(for: workout) { distanceResult in
                            
                            dispatchGroup.enter()
                            
                            switch distanceResult {
                                
                            case .success(let distance):
                                distanceData.totalDistance = distance
                            case .failure(let error):
                                print("Error fetching distance: \(error.localizedDescription)")
                            }
                            
                            
                            
                            
                            dispatchGroup.leave()
                            print("fetchWorkoutDistance FINISHED")
                        }
                        
                        let data = HealthKitData(workout: workoutData,
                                                 distance: distanceData,
                                                 route: nil,
                                                 heartRates: nil,
                                                 calloriesBurned: nil)
                        
                        results.append(data)
                        
                        
                    }
                    
                    
                    
                    // Ждем завершения всех асинхронных операций
                    dispatchGroup.notify(queue: .main) {
                        print("dispatchGroup FINISHED")
                        completion(.success(results)) // Возвращаем результат после всех операций
                    }
                    
                }
                
                self.healthStore.execute(query)
                
            } else {
                completion(.failure(.notAuthorized))
            }
        }
    }
    
    private func fetchWorkoutDistance(for workout: HKWorkout,
                                      completion: @escaping(Result<Double, HealthKitError>) -> Void) {
        
        guard let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            completion(.failure(.noDistanceData))
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: workout.startDate, end: workout.endDate)
        
        let query = HKStatisticsQuery(quantityType: distanceType, quantitySamplePredicate: predicate) { _, result, _ in
            
            if let distance = result?.sumQuantity()?.doubleValue(for: HKUnit.meter()) {
                completion(.success(distance))
            } else {
                completion(.failure(.noDistanceData))
            }
        }
        
        healthStore.execute(query)
    }
}
