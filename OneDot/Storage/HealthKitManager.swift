//
//  HealthKitDataManager.swift
//  OneDot
//
//  Created by Александр Коробицын on 09.12.2024.
//

import Foundation
import HealthKit
import CoreLocation

class HealthKitManager {
    
    static let shared = HealthKitManager()
    
    private let healthStore: HKHealthStore = HKHealthStore()
    
    private init() {}
    
    enum HealthKitError: Error {
        case notAuthorized
        case invalidHealthKitType(description: String)
        case noWorkoutData(description: String)
        case noRouteData(description: String)
        case noClimbingData(description: String)
    }
    
    func errorHandling(error: HealthKitError) {
        switch error {
        case .notAuthorized:
            print("not authothorized")
        case .invalidHealthKitType(let description):
            print("invalid healtkit type, \(description)")
        case .noWorkoutData(let description):
            print("no healthkit data \(description)")
        case .noRouteData(let description):
            print("no route data, \(description)")
        case .noClimbingData(let description):
            print("no climbing data, \(description)")
            
        }
    }
    
    
    //MARK: - FetchHealthKitDataList
    
    func fetchHealthKitDataList() async throws -> [WorkoutData] {
        
        let workoutType = HKWorkoutType.workoutType()
        try await checkAuthorizationStatus()
        let hKWorkouts = try await fetchHKWorkouts(workoutType: workoutType)
        let healthKitDataList = try await convertHKWorkoutsInWorkoutDataList(workouts: hKWorkouts)
        return healthKitDataList
    }
    
    func checkAuthorizationStatus() async throws {
        let workoutType = HKWorkoutType.workoutType()  // Тип тренировки
        let routeType = HKSeriesType.workoutRoute()    // Тип маршрута тренировки

        guard let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)
        else { throw HealthKitManager.HealthKitError.invalidHealthKitType(description: "no distance type") }

        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)
        else { throw HealthKitManager.HealthKitError.invalidHealthKitType(description: "no heart rate type") }

        guard let energyBurnedType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)
        else { throw HealthKitManager.HealthKitError.invalidHealthKitType(description: "no energy burned type") }

        let authStatus = healthStore.authorizationStatus(for: workoutType)
        if authStatus != .sharingAuthorized {
            throw HealthKitManager.HealthKitError.notAuthorized
        }

        try await withCheckedThrowingContinuation { continuation in
            healthStore.requestAuthorization(
                toShare: [energyBurnedType, routeType, workoutType],  // Добавляем workoutType для маршрута тренировки
                read: [workoutType, distanceType, routeType, heartRateType]  // Убедитесь, что workoutType для тренировки также добавлен в read
            ) { success, error in
                if success {
                    continuation.resume()
                } else {
                    continuation.resume(throwing: HealthKitManager.HealthKitError.notAuthorized)
                }
            }
        }
    }
    
    
    
    //MARK: - FetchHKWorkouts
    
    private func fetchHKWorkouts(workoutType: HKWorkoutType) async throws -> [HKWorkout] {
        
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(sampleType: workoutType,
                                      predicate: nil,
                                      limit: HKObjectQueryNoLimit,
                                      sortDescriptors: [sortDescriptor]) { _, samples, _ in
                if let samples = samples as? [HKWorkout] {
                    continuation.resume(returning: samples)
                } else {
                    continuation.resume(throwing: HealthKitError.noWorkoutData(description: "\(#function)"))
                }
            }
            healthStore.execute(query)
        }
    }
    
    
    //MARK: - ConvertHKWorkoutsInHKDataList
    
    
    private func convertHKWorkoutsInWorkoutDataList(workouts: [HKWorkout]) async throws -> [WorkoutData] {
        var healthKitData: [WorkoutData] = []
        
        guard let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            throw HealthKitError.invalidHealthKitType(description: "no distance type")
        }
        
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            throw HealthKitError.invalidHealthKitType(description: "no heart rate type")
        }
        
        guard let activeEnergyBurned = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            throw HealthKitError.invalidHealthKitType(description: "no energy burned type")
        }
        
        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            throw HealthKitError.invalidHealthKitType(description: "no step count type")
        }
        
        for workout in workouts {
            
            var associatedName: String = ""
            
            if let metadata = workout.metadata?["name"] as? String {
                associatedName = metadata
            } else {
                associatedName = workout.workoutActivityType.name
            }
            
            let distance = workout.statistics(for: distanceType)
            let distanceData = distance?.sumQuantity()?.doubleValue(for: HKUnit.meter()) ?? 0
            
            let heartRate = workout.statistics(for: heartRateType)
            let heartRateData = heartRate?.averageQuantity()?.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())) ?? 0.0
            
            let activeEnergy = workout.statistics(for: activeEnergyBurned)
            let activeEnergyBurnedData = activeEnergy?.sumQuantity()?.doubleValue(for: HKUnit.largeCalorie()) ?? 0
            
            let stepCount = workout.statistics(for: stepCountType)
            let stepCountData = stepCount?.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0
            
            let averageCadence = calculateCadence(stepCount: stepCountData, workoutDuration: workout.duration)
            
            let pace = calculatePace(workoutDuration: workout.duration, distance: distanceData)
            
            let data = WorkoutData(workoutName: workout.workoutActivityType.name,
                                     associatedName: associatedName,
                                     startDate: workout.startDate,
                                     endDate: workout.endDate,
                                     duration: workout.duration,
                                     totalDistance: distanceData,
                                     pace: pace,
                                     heartRate: heartRateData,
                                     calloriesBurned: activeEnergyBurnedData,
                                     stepCount: Int(stepCountData),
                                     cadence: averageCadence
                                     )
            
            healthKitData.append(data)
        }
        
        return healthKitData
    }
    
    
    //MARK: - CalculateCadence
    
    private func calculateCadence(stepCount: Double, workoutDuration: TimeInterval) -> Int {
        guard workoutDuration != 0, stepCount != 0 else {
            return 0
        }
        
        let stepPerSecond = stepCount / workoutDuration
        let cadence = Int(stepPerSecond * 60)
        
        return cadence
    }
    
    private func calculatePace(workoutDuration: TimeInterval, distance: Double) -> Int {
        guard workoutDuration != 0, distance != 0 else {
            return 0
        }
        
        let meterTime = workoutDuration / distance
        let paceInSeconds = Int(meterTime * 1000)
        return paceInSeconds
        
    }
    
    
    
    //MARK: - GetHealthKitCoordinates
    
    func getClimbing(locations: [CLLocation]) async throws -> Double {
        
        var climbingDataList: [Double] = []
        
        locations.forEach { coordinate in
            climbingDataList.append(coordinate.altitude)
        }
        
        let climbingDataAverage: Double
        if let minClimb = climbingDataList.min(), let maxClimb = climbingDataList.max() {
            climbingDataAverage = maxClimb - minClimb
        } else {
            climbingDataAverage = 0
            throw HealthKitError.noClimbingData(description: "\(#function)")
        }
        
        return climbingDataAverage
    }
    
    //MARK: - ReturnCLLocation
    
    func getRoute(workout: WorkoutData) async throws -> [CLLocation] {

        let routeType = HKSeriesType.workoutRoute()
        let predicate = HKQuery.predicateForSamples(withStart: workout.startDate, end: workout.endDate)
        
        return try await withCheckedThrowingContinuation { continuation in
            
            let query = HKSampleQuery(sampleType: routeType, predicate: predicate, limit: 1, sortDescriptors: nil) { _, samples, error in
                if let route = samples?.first as? HKWorkoutRoute {
                    
                    var allLocations: [CLLocation] = []
                    let routeQuery = HKWorkoutRouteQuery(route: route) { _, locations, done, error in
                        
                        if let locations = locations {
                            allLocations.append(contentsOf: locations)
                            
                            if done {
                                continuation.resume(returning: allLocations)
                            }
                        }
                    }
                    self.healthStore.execute(routeQuery)
                    
                } else {
                    continuation.resume(throwing: HealthKitError.noRouteData(description: "no route"))
                }
            }
            healthStore.execute(query)
        }
    }
}
