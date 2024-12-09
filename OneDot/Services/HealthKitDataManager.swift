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
    private let workoutType: HKWorkoutType = HKWorkoutType.workoutType()
    
    private init() {}
    
    enum HealthKitError: Error {
        case notAuthorized
        case noHealthKitData
        case noDistanceData
        case noRouteData
        case noHeartRateData
    }
    
    func fetchHealthkitData(completion: @escaping(Result<[HealthKitData], HealthKitError>) -> Void) {
        

        healthStore.requestAuthorization(toShare: nil, read: [workoutType]) { success, error in
            if success {
                
                var healthKitData: [HealthKitData] = []
                
                let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
                
                let query = HKSampleQuery(sampleType: self.workoutType,
                                          predicate: nil,
                                          limit: HKObjectQueryNoLimit,
                                          sortDescriptors: [sortDescriptor]) { _, samples, error in
                    
                    if let error = error {
                        completion(.failure(.noHealthKitData))
                    }
                    
                    guard let workouts = samples as? [HKWorkout] else { return }
                    
                    workouts.forEach { result in
                        
                        guard let energyType = result.totalEnergyBurned else {
                            return
                        }


                        let healthRate = HealthKitData.HeartRate(timestamp: nil, bpm: nil)
                        let route = HealthKitData.Route(locations: nil)
                        var workout = HealthKitData.Workout(workoutType: result.workoutActivityType.name,
                                                            startDate: result.startDate,
                                                            endDate: result.endDate,
                                                            duration: result.duration,
                                                            calloriesBurned: energyType.doubleValue(for: .kilocalorie()))
                        
                        self.fetchWorkoutDistance(for: result) { result in
                            switch result {
                                
                            case .success(let distance):
                                workout.totalDistance = distance
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                        
                        
                        
                        let dat = HealthKitData(workout: workout, heartRates: healthRate, route: route)
                        
                        healthKitData.append(dat)
                        
                        
                    }
                    completion(.success(healthKitData))
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
        
        let query = HKStatisticsQuery(quantityType: distanceType, quantitySamplePredicate: predicate) { _, result, error in
            if let error = error {
                        print("Ошибка при выполнении запроса: \(error.localizedDescription)")
                        completion(.failure(.noDistanceData))
                        return
                    }
                    
                    if let distance = result?.sumQuantity()?.doubleValue(for: HKUnit.meter()) {
                        completion(.success(distance))
                    } else {
                        completion(.failure(.noDistanceData))
                    }
        }
        
        healthStore.execute(query)
        
    }
}
