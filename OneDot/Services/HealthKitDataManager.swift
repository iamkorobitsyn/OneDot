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
        case invalidHealthKitType
        case notAuthorized
        case noHealthKitData
        case noDistanceData
        case noRouteData
        case noHeartRateData
    }
    
    func errorHanding(error: HealthKitError) {
        switch error {
        case .invalidHealthKitType:
            print("invalid healtkit type")
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
        
        let workoutType = HKWorkoutType.workoutType()
        guard let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)
        else { throw HealthKitError.invalidHealthKitType }
        
        do {
            
            try await healthStore.requestAuthorization(toShare: [], read: [workoutType, distanceType])
            
            let workouts = try await fetchWorkouts(workoutType: workoutType)
            
            let healthKitData = try await convertWorkouts(workouts: workouts)
            
            return healthKitData
            
        } catch {
            throw HealthKitError.notAuthorized
        }
    }
    
    private func fetchWorkouts(workoutType: HKWorkoutType) async throws -> [HKWorkout] {
        
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
    
    private func fetchWorkoutDistance(workout: HKWorkout) async throws -> Double {
        guard let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)
        else { throw HealthKitError.noDistanceData }
        
        let predicate = HKQuery.predicateForSamples(withStart: workout.startDate, end: workout.endDate)
        
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKStatisticsQuery(quantityType: distanceType, quantitySamplePredicate: predicate) { _, result, _ in
                if let distance = result?.sumQuantity()?.doubleValue(for: HKUnit.meter()) {
                    continuation.resume(returning: distance)
                } else {
                    continuation.resume(throwing: HealthKitError.noDistanceData)
                }
            }
            healthStore.execute(query)
        }
    }
    
    private func convertWorkouts(workouts: [HKWorkout]) async throws -> [HealthKitData] {
        var results: [HealthKitData] = []
        
        for workout in workouts {
            let workoutData = HealthKitData.Workout(workoutType: workout.workoutActivityType.name,
                                                    startDate: workout.startDate,
                                                    endDate: workout.endDate,
                                                    duration: workout.duration)
            
            let distance = try await fetchWorkoutDistance(workout: workout)
            
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
}
