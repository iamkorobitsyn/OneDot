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
    
    var startDate: Date?
    var currentWorkout: Workout?
    private lazy var timeInterval: TimeInterval = 0.0
    private lazy var totalCalories: Double = 0.0
    private lazy var totalDistance: Double = 0.0
    private lazy var locationCoordinates: [CLLocation] = []
    
    
    enum InternalError: Error {
        case notAuthorized(Error)
        case workoutIsEmpty
    }
    
    private func workoutTypeRepresentable(name: String) -> HKWorkoutActivityType {
        switch name {
        case "Swimming": return .swimming
        case "Paddle": return .paddleSports
        case "Hiking": return .hiking
        case "Running": return .running
        case "Cycling": return .cycling
        case "Board": return .skatingSports
        case "Roller skates": return .skatingSports
        case "Skates": return .skatingSports
        case "Skis": return .crossCountrySkiing
        case "Snowboard": return .snowboarding
            
        case "Swimming pool": return .swimming
        case "Stepper": return .stairClimbing
        case "Treadmill": return .running
        case "Exercise bike": return .cycling
        case "Recumbent bike": return .cycling
        case "Strength training": return .traditionalStrengthTraining
        case "Fusion workout": return .functionalStrengthTraining
        case "Stretching": return .flexibility
        case "Yoga": return .yoga
        default:
            break
        }
        return .other
    }
    
    
    //MARK: - ClearWorkout
    
    func clearValues() {
        currentWorkout = nil
        startDate = nil
        timeInterval = 0.0
        totalCalories = 0.0
        locationCoordinates = []
        totalDistance = 0.0
    }
    
    //MARK: - UpdateWorkout
    
    func updateWorkout(timeInterval: Double) {
        self.timeInterval = timeInterval
        if let workout = currentWorkout { totalCalories = timeInterval * workout.averageCalBurnedPerSec }
        totalDistance = LocationService.shared.totalDistance
        locationCoordinates = LocationService.shared.locations
    }
    
    //MARK: - SaveWorkout
    
    func saveWorkout(name: String,
                     startDate: Date,
                     duration: Double,
                     energyBurned: Double,
                     distance: Double,
                     coordinates: [CLLocation]) async throws {
        
        
        
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = workoutTypeRepresentable(name: name)
        
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
        
        let metadata: [String: Any] = ["name": name]

        try await requestAuthorization()
        try await workoutBuilder.beginCollection(at: startDate)
        try await workoutBuilder.addSamples([energySample, distanceSample])
        try await workoutBuilder.addMetadata(metadata)
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
    


