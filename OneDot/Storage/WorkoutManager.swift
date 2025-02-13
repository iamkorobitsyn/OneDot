//
//  WorkoutManager.swift
//  OneDot
//
//  Created by Александр Коробицын on 28.01.2025.
//

import Foundation
import HealthKit
import CoreLocation

class WorkoutManager {
    
    static let shared = WorkoutManager()
    private let healthStore = HKHealthStore()
    
    enum InternalError: Error {
        case notAuthorized(Error)
        case workoutIsEmpty
    } 
    
    //MARK: - SaveWorkout
    
    func saveWorkout(activityType: HKWorkoutActivityType,
                     locationType: HKWorkoutSessionLocationType,
                     startDate: Date,
                     duration: Double,
                     energyBurned: Double,
                     distance: Double,
                     coordinates: [CLLocation]) async throws {
        
        
        
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = activityType
        configuration.locationType = locationType
        
        let workoutBuilder = HKWorkoutBuilder(healthStore: healthStore, configuration: configuration, device: nil)
        let routeBuilder = HKWorkoutRouteBuilder(healthStore: healthStore, device: .local())
        
        let energyQuantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: energyBurned)
        let distanceQuantity = HKQuantity(unit: HKUnit.meter(), doubleValue: distance)
        
        let energySample = HKQuantitySample(
            type: HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            quantity: energyQuantity,
            start: startDate,
            end: startDate.addingTimeInterval(duration)
        )
        
        let distanceSample = HKQuantitySample(
            type: HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            quantity: distanceQuantity,
            start: startDate,
            end: startDate.addingTimeInterval(duration)
        )
        
        let meta: [String: Any] = [
                "locationType": "locationType.rawValue"
            ]

        try await requestAuthorization()
        try await workoutBuilder.beginCollection(at: startDate)
        try await workoutBuilder.addSamples([energySample, distanceSample])
        try await workoutBuilder.addMetadata(meta)
        try await workoutBuilder.endCollection(at: startDate.addingTimeInterval(duration))
        
        if let workout = try await workoutBuilder.finishWorkout() {
            try await routeBuilder.insertRouteData(coordinates)
            try await routeBuilder.finishRoute(with: workout, metadata: nil)
        } else {
            throw InternalError.workoutIsEmpty
        }
    }
    
    //MARK: - RequestAuthorization
    
    private func requestAuthorization() async throws {
        
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
        do {
            try await healthStore.statusForAuthorizationRequest(toShare: typesToShare, read: typesToRead)
        } catch {
            throw InternalError.notAuthorized(error)
        }
    }
}
    


