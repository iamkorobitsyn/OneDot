//
//  WorkoutManager.swift
//  OneDot
//
//  Created by Александр Коробицын on 28.01.2025.
//

import Foundation
import HealthKit

class WorkoutManager {
    
    static let shared = WorkoutManager()
    
    private let healthStore = HKHealthStore()
    
    // Функция для записи тренировки с данными в HealthKit
    func saveWorkout(distance: Double, energyBurned: Double, duration: Double, activityType: HKWorkoutActivityType, completion: @escaping (Bool, Error?) -> Void) {
        
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = activityType
        
        let workoutBuilder = HKWorkoutBuilder(healthStore: healthStore, configuration: workoutConfiguration, device: nil)
        let startDate = Date()
        let endDate = startDate.addingTimeInterval(duration)
        
        // Создаем объекты для данных о калориях и дистанции
        let energyQuantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: energyBurned)
        let distanceQuantity = HKQuantity(unit: HKUnit.meter(), doubleValue: distance)

        // Создаем образцы данных (samples)
        let energySample = HKQuantitySample(type: HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!, quantity: energyQuantity, start: startDate, end: endDate)
        let distanceSample = HKQuantitySample(type: HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!, quantity: distanceQuantity, start: startDate, end: endDate)

        Task {
            do {
                // Добавляем данные в builder
                try await checkAuthorizationStatus()
                
                try await workoutBuilder.addSamples([energySample])

                // Завершаем тренировку
                let workout = HKWorkout(activityType: activityType, start: startDate, end: endDate, workoutEvents: [], totalEnergyBurned: energyQuantity, totalDistance: distanceQuantity, device: nil, metadata: nil)

                // Сохраняем тренировку в HealthKit
                try await healthStore.save(workout)

                // Завершаем тренировку в builder
                try await workoutBuilder.finishWorkout()

                // Если все прошло успешно, вызываем completion с успехом
                completion(true, nil)
            } catch {
                // В случае ошибки вызываем completion с ошибкой
                completion(false, error)
            }
        }
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

    func isHealthKitAuthorized() -> Bool {
        let workoutType = HKWorkoutType.workoutType()
        return HKHealthStore.isHealthDataAvailable() &&
               healthStore.authorizationStatus(for: workoutType) == .sharingAuthorized
    }
}
