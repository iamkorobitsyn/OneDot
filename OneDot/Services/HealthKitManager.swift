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
        guard let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)
                
        else { throw HealthKitError.invalidHealthKitType }
        let routeType = HKSeriesType.workoutRoute()
        
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)
        else { throw HealthKitError.invalidHealthKitType }
        
        guard let climbingType = HKObjectType.quantityType(forIdentifier: .flightsClimbed)
        else {throw HealthKitError.invalidHealthKitType}
        
        
        try await withCheckedThrowingContinuation { continuation in
            healthStore.requestAuthorization(toShare: nil, read: [workoutType, distanceType, routeType, heartRateType, climbingType]) { success, error in
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
        
        guard let climbingType = HKObjectType.quantityType(forIdentifier: .flightsClimbed) else {
            throw HealthKitError.invalidHealthKitType
        }
        
        let routeType = HKSeriesType.workoutRoute()
        
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
            
            // Получаем статистику по этажам
            let climbing = workout.statistics(for: climbingType)
            let climbingData = climbing?.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0.0
            
            // Преобразуем количество этажей в высоту (метры). Обычно 1 этаж = 3 метра
            let heightInMeters = climbingData * 3.0 // 1 этаж ≈ 3 метра
            
            // Выводим информацию для отладки
            print("Workout: \(workout.workoutActivityType.name), Climbing: \(climbingData) floors, \(heightInMeters) meters")
            
            let route = workout.statistics(for: routeType)
            
            // Создаем объект данных о тренировке
            let data = HealthKitData(workoutType: workout.workoutActivityType.name,
                                     startDate: workout.startDate,
                                     endDate: workout.endDate,
                                     duration: workout.duration,
                                     totalDistance: distanceData,
                                     climb: heightInMeters,
                                     heartRate: heartRateData,
                                     calloriesBurned: activeEnergyBurnedData)
            
            // Добавляем данные в массив
            healthKitData.append(data)
        }
        
        return healthKitData
    }
    
    
    
    
    
    
    private func fetchWorkoutRoute(workout: HKWorkout) async throws -> HKWorkoutRoute? {
        let routeType = HKSeriesType.workoutRoute()
        
        let predicate = HKQuery.predicateForSamples(withStart: workout.startDate, end: workout.endDate)
        
        return try await withCheckedThrowingContinuation { continuation in

            let query = HKSampleQuery(sampleType: routeType, predicate: predicate, limit: 1, sortDescriptors: nil) { _, samples, _ in

                if let route = samples?.first as? HKWorkoutRoute {
                    continuation.resume(returning: route)
                } else {
                    continuation.resume(returning: nil)
                }
            }

            healthStore.execute(query)
        }
    }
    
    private func fetchRouteData(for route: HKWorkoutRoute) async throws -> [CLLocation] {
        var locations: [CLLocation] = []
        
        return try await withCheckedThrowingContinuation { continuation in

            let query = HKWorkoutRouteQuery(route: route) { query, routeLocations, done, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                if let routeLocations = routeLocations {
                    locations.append(contentsOf: routeLocations)
                }
                
                // Если все точки загружены, завершаем выполнение
                if done {
                    continuation.resume(returning: locations)
                }
            }
            
            // Выполняем запрос
            healthStore.execute(query)
        }
    }
    
}
