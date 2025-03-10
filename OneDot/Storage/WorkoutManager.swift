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
    var valuesHandler: ((Double, Double) -> Void)?
    
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
        valuesHandler?(totalDistance, totalCalories)
    }
    
    //MARK: - SaveWorkout
    
    func saveWorkout() async throws {

        
        guard let date = startDate else {return}
        guard let workout = currentWorkout else {return}
        
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = workoutTypeRepresentable(name: workout.name)
        
        let workoutBuilder = HKWorkoutBuilder(healthStore: healthStore, configuration: configuration, device: nil)
        let routeBuilder = HKWorkoutRouteBuilder(healthStore: healthStore, device: .local())
        
        let energyQuantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: totalCalories)
        let distanceQuantity = HKQuantity(unit: HKUnit.meter(), doubleValue: totalDistance)
        
        let energySample = HKQuantitySample(
            type: HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            quantity: energyQuantity,
            start: date,
            end: date.addingTimeInterval(timeInterval)
        )
        
        let distanceSample = HKQuantitySample(
            type: HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            quantity: distanceQuantity,
            start: date,
            end: date.addingTimeInterval(timeInterval)
        )
        
        let metadata: [String: Any] = ["name": workout.name]

        try await requestAuthorization()
        try await workoutBuilder.beginCollection(at: date)
        try await workoutBuilder.addSamples([energySample, distanceSample])
        try await workoutBuilder.addMetadata(metadata)
        try await workoutBuilder.endCollection(at: date.addingTimeInterval(timeInterval))
        
        if let workout = try await workoutBuilder.finishWorkout() {
            try await routeBuilder.insertRouteData(locationCoordinates)
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
    


