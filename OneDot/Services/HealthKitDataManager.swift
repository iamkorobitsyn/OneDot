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
    
    func errorHanding(error: HealthKitError) {
        switch error {
            
        case .notAuthorized:
            print("no authotization")
        case .noHealthKitData:
            print("no healthkit data")
        case .noDistanceData:
            print("no distance")
        case .noRouteData:
            print("no route")
        case .noHeartRateData:
            print("no heart rate")
        }
    }
    
    func fetchHealthKitData() async throws -> [HealthKitData] {
        let workoutType: HKWorkoutType = HKWorkoutType.workoutType()
        
        guard let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            throw HealthKitError.noDistanceData
        }
        
        // Запрашиваем авторизацию
        let success = try await requestAuthorization(toRead: [workoutType, distanceType])
        guard success else { throw HealthKitError.notAuthorized }
        
        // Получаем тренировки
        let workouts = try await fetchWorkouts()
        var results: [HealthKitData] = []
        
        for workout in workouts {
            let workoutData = HealthKitData.Workout(workoutType: workout.workoutActivityType.name,
                                                    startDate: workout.startDate,
                                                    endDate: workout.endDate,
                                                    duration: workout.duration)
            
            let distance: Double
            
            do {
                distance = try await fetchWorkoutDistance(for: workout)
            } catch {
                let error = error as! HealthKitError
                errorHanding(error: error)
                distance = 0
            }
            
            let distanceData = HealthKitData.Distance(totalDistance: distance)
            
            let data = HealthKitData(workout: workoutData,
                                     distance: distanceData,
                                     route: nil,
                                     heartRates: nil,
                                     calloriesBurned: nil)
            
            results.append(data)
        }
        
        return results
    }
    
    // MARK: - Private Methods
    
    
    
    private func requestAuthorization(toRead types: Set<HKObjectType>) async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            healthStore.requestAuthorization(toShare: nil, read: types) { success, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: success)
                }
            }
        }
    }
    
    private func fetchWorkouts() async throws -> [HKWorkout] {
        let workoutType: HKWorkoutType = HKWorkoutType.workoutType()
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(sampleType: workoutType,
                                      predicate: nil,
                                      limit: HKObjectQueryNoLimit,
                                      sortDescriptors: [sortDescriptor]) { _, samples, _ in
                if let workouts = samples as? [HKWorkout] {
                    continuation.resume(returning: workouts)
                } else {
                    continuation.resume(throwing: HealthKitError.noHealthKitData)
                }
            }
            
            healthStore.execute(query)
        }
    }
    
    private func fetchWorkoutDistance(for workout: HKWorkout) async throws -> Double {
        guard let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            throw HealthKitError.noDistanceData
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: workout.startDate, end: workout.endDate)
        
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKStatisticsQuery(quantityType: distanceType, quantitySamplePredicate: predicate) { _, result, error in
                if let distance = result?.sumQuantity()?.doubleValue(for: HKUnit.meter()) {
                    continuation.resume(returning: distance)
                } else {
                    continuation.resume(throwing: HealthKitError.noDistanceData)
                }
            }
            
            healthStore.execute(query)
        }
    }
}

//class HealthKitDataManager {
//    
//    static let shared = HealthKitDataManager()
//    
//    private let healthStore: HKHealthStore = HKHealthStore()
//    
//    private init() {}
//    
//    enum HealthKitError: Error {
//        case notAuthorized
//        case noHealthKitData
//        case noDistanceData
//        case noRouteData
//        case noHeartRateData
//    }
//    
//    func fetchHealthkitData(completion: @escaping(Result<[HealthKitData], HealthKitError>) -> Void) {
//        
//        let workoutType: HKWorkoutType = HKWorkoutType.workoutType()
//        
//        guard let distanceType: HKObjectType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) else {
//            completion(.failure(.noDistanceData))
//            return
//        }
//        
//        healthStore.requestAuthorization(toShare: nil, read: [workoutType, distanceType]) { success, error in
//            
//            if success {
//                
//                let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
//                
//                let query = HKSampleQuery(sampleType: workoutType,
//                                          predicate: nil,
//                                          limit: HKObjectQueryNoLimit,
//                                          sortDescriptors: [sortDescriptor]) { _, samples, error in
//                    
//                    if let error = error {
//                        print("Error: \(error.localizedDescription)")
//                        completion(.failure(.noHealthKitData))
//                        return
//                    }
//                    
//                    guard let workouts = samples as? [HKWorkout] else {
//                        completion(.failure(.noHealthKitData))
//                        return
//                    }
//                    
//                    let dispatchGroup = DispatchGroup()
//                    var results: [HealthKitData] = []
//                    
//                    workouts.forEach { workout in
//                        
//                        dispatchGroup.enter()
//                        
//                        let workoutData = HealthKitData.Workout(workoutType: workout.workoutActivityType.name,
//                                                                startDate: workout.startDate,
//                                                                endDate: workout.endDate,
//                                                                duration: workout.duration)
//                        var distanceData = HealthKitData.Distance(totalDistance: 0)
//                        
//                        
//                        
//                        self.fetchWorkoutDistance(for: workout) { distanceResult in
//                            
//                            
//                            
//                            switch distanceResult {
//                                
//                            case .success(let distance):
//                                distanceData.totalDistance = distance
//                            case .failure(let error):
//                                print("Error fetching distance: \(error.localizedDescription)")
//                            }
//                            
//                            
//                            
//                            
//                            dispatchGroup.leave()
//                            print("fetchWorkoutDistance FINISHED")
//                        }
//                        
//                        let data = HealthKitData(workout: workoutData,
//                                                 distance: distanceData,
//                                                 route: nil,
//                                                 heartRates: nil,
//                                                 calloriesBurned: nil)
//                        
//                        results.append(data)
//                        
//                        
//                    }
//                    
//                    
//                    
//                    // Ждем завершения всех асинхронных операций
//                    dispatchGroup.notify(queue: .main) {
//                        print("dispatchGroup FINISHED")
//                        completion(.success(results)) // Возвращаем результат после всех операций
//                    }
//                    
//                }
//                
//                self.healthStore.execute(query)
//                
//            } else {
//                completion(.failure(.notAuthorized))
//            }
//        }
//    }
//    
//    private func fetchWorkoutDistance(for workout: HKWorkout,
//                                      completion: @escaping(Result<Double, HealthKitError>) -> Void) {
//        
//        guard let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else {
//            completion(.failure(.noDistanceData))
//            return
//        }
//        
//        let predicate = HKQuery.predicateForSamples(withStart: workout.startDate, end: workout.endDate)
//        
//        let query = HKStatisticsQuery(quantityType: distanceType, quantitySamplePredicate: predicate) { _, result, _ in
//            
//            if let distance = result?.sumQuantity()?.doubleValue(for: HKUnit.meter()) {
//                completion(.success(distance))
//            } else {
//                completion(.failure(.noDistanceData))
//            }
//        }
//        
//        healthStore.execute(query)
//    }
//}
