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
    
    //MARK: - FetchHealthKitDataList
    
    func fetchHealthKitDataList() async throws -> [HealthKitData] {
        
        let workoutType = HKWorkoutType.workoutType()
        let routeType = HKSeriesType.workoutRoute()
        
        guard let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)
        else { throw HealthKitError.invalidHealthKitType }
        
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)
        else { throw HealthKitError.invalidHealthKitType }
        
        try await withCheckedThrowingContinuation { continuation in
            healthStore.requestAuthorization(toShare: nil, read: [workoutType,
                                                                  distanceType,
                                                                  routeType,
                                                                  heartRateType]) { success, error in
                if success {
                    continuation.resume()
                } else {
                    continuation.resume(throwing: HealthKitError.notAuthorized)
                }
            }
        }
        
        let workouts = try await fetchWorkouts(workoutType: workoutType)
        
        let healthKitDataList = try await convertWorkouts(workouts: workouts)
        
        return healthKitDataList
        
    }
    
    //MARK: - FetchWorkouts
    
    private func fetchWorkouts(workoutType: HKWorkoutType) async throws -> [HKWorkout] {
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(sampleType: workoutType,
                                      predicate: nil,
                                      limit: HKObjectQueryNoLimit,
                                      sortDescriptors: [sortDescriptor]) { _, samples, _ in
                if let samples = samples as? [HKWorkout] {
                    continuation.resume(returning: samples)
                } else {
                    continuation.resume(throwing: HealthKitError.noHealthKitData)
                }
            }
            healthStore.execute(query)
        }
    }
    
    
    //MARK: - ConvertWorkouts
    
    
    private func convertWorkouts(workouts: [HKWorkout]) async throws -> [HealthKitData] {
        var healthKitData: [HealthKitData] = []
        
        // Проверяем типы данных
        guard let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            throw HealthKitError.invalidHealthKitType
        }
        
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            throw HealthKitError.invalidHealthKitType
        }
        
        guard let activeEnergyBurned = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            throw HealthKitError.invalidHealthKitType
        }
        
        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            throw HealthKitError.invalidHealthKitType
        }
        
        // Проходим по всем тренировкам
        for workout in workouts {
                
                // Получаем статистику по расстоянию
                let distance = workout.statistics(for: distanceType)
                let distanceData = distance?.sumQuantity()?.doubleValue(for: HKUnit.meter()) ?? 0
                
                // Получаем статистику по сердечному ритму
                let heartRate = workout.statistics(for: heartRateType)
                let heartRateData = heartRate?.averageQuantity()?.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())) ?? 0.0
                
                // Получаем статистику по сожженным калориям
                let activeEnergy = workout.statistics(for: activeEnergyBurned)
                let activeEnergyBurnedData = activeEnergy?.sumQuantity()?.doubleValue(for: HKUnit.largeCalorie()) ?? 0
                
                let stepCount = workout.statistics(for: stepCountType)
                let stepCountData = stepCount?.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0
                
                let averageCadence = calculateCadence(stepCount: stepCountData, workoutDuration: workout.duration)
            
                let pace = calculatePace(workoutDuration: workout.duration, distance: distanceData)
              
                    

                // Создаем объект данных о тренировке
                let data = HealthKitData(workoutType: workout.workoutActivityType.name,
                                         startDate: workout.startDate,
                                         endDate: workout.endDate,
                                         duration: workout.duration,
                                         totalDistance: distanceData,
                                         pace: pace,
                                         climbing: 0.0,
                                         heartRate: heartRateData,
                                         calloriesBurned: activeEnergyBurnedData,
                                         stepCount: Int(stepCountData),
                                         cadence: averageCadence)
                
                // Добавляем данные в массив
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
    
    func getCoordinates(data: HealthKitData) async throws -> HealthKitCoordinates {
        var coordinate2D: [CLLocationCoordinate2D] = []
        var climbingData: [Double] = []
        
        let locations = try await getCLLocations(workout: data)
        
        locations.forEach { loc in
            coordinate2D.append(loc.coordinate)
            climbingData.append(loc.altitude)
        }
        
        let climbingDataAverage: Double
        if let minClimb = climbingData.min(), let maxClimb = climbingData.max() {
            climbingDataAverage = maxClimb - minClimb
        } else {
            climbingDataAverage = 0
        }

        let healthKitCoordinates = HealthKitCoordinates(coordinates2D: coordinate2D, climbing: climbingDataAverage)
        
        return healthKitCoordinates
    }
    
    //MARK: - ReturnCLLocation
    
    private func getCLLocations(workout: HealthKitData) async throws -> [CLLocation] {
        
        let routeType = HKSeriesType.workoutRoute()
        
        let predicate = HKQuery.predicateForSamples(withStart: workout.startDate, end: workout.endDate)
        
        return try await withCheckedThrowingContinuation { continuation in

            let query = HKSampleQuery(sampleType: routeType, predicate: predicate, limit: 1, sortDescriptors: nil) { _, samples, error in

                Task {
                    if let route = samples?.first as? HKWorkoutRoute {
                        let locations = try await self.getRouteData(for: route)
                        continuation.resume(returning: locations)
                    } else {
                        continuation.resume(throwing: HealthKitError.noRouteData)
                    }
                }
            }
            healthStore.execute(query)
        }
    }
    
    private func getRouteData(for route: HKWorkoutRoute) async throws -> [CLLocation] {
        var locations: [CLLocation] = []
        
        return try await withCheckedThrowingContinuation { continuation in

            let query = HKWorkoutRouteQuery(route: route) { query, routeLocations, done, error in
                
                if let routeLocations = routeLocations { locations.append(contentsOf: routeLocations) }
                if done { continuation.resume(returning: locations) }
                if let error = error { continuation.resume(throwing: error) }
            }
            healthStore.execute(query)
        }
    }
    
}
