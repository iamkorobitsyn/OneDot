//
//  WorkoutManager.swift
//  OneDot
//
//  Created by Александр Коробицын on 22.01.2025.
//

import CoreLocation

// Менеджер для отслеживания геопозиции и вычисления дистанции
class LocationManager: NSObject, CLLocationManagerDelegate {
    
    // Свойства
    private var locationManager: CLLocationManager
    private var lastLocation: CLLocation?
    private var totalDistance: Double
    
    // Замыкание, которое будет вызываться каждый раз при обновлении местоположения
    var didUpdateDistance: ((Double) -> Void)?
    
    // Инициализатор
    override init() {
        self.locationManager = CLLocationManager()
        self.lastLocation = nil
        self.totalDistance = 0.0
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 5 // срабатывает каждые 10 метров
    }
    
    // Запрашиваем разрешение на использование местоположения
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    // Запускаем отслеживание местоположения
    func startTracking() {
        locationManager.startUpdatingLocation()
        print("start tracking")
    }
    
    // Останавливаем отслеживание местоположения
    func stopTracking() {
        locationManager.stopUpdatingLocation()
        print("stop tracking")
    }
    
    // Получаем общее пройденное расстояние
    func getTotalDistance() -> Double {
        return totalDistance
    }
    
    // CLLocationManagerDelegate: Обработчик обновлений местоположения
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }

        // Если это не первая точка, вычисляем расстояние
        if let lastLocation = lastLocation {
            let distance = lastLocation.distance(from: currentLocation)
            totalDistance += distance
        }
        
        

        // Обновляем последнюю точку
        lastLocation = currentLocation
        
        // Вызываем замыкание для обновления UI или другого функционала
        didUpdateDistance?(totalDistance)
    }
    
    // CLLocationManagerDelegate: Обработчик ошибок
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Ошибка при получении местоположения: \(error.localizedDescription)")
    }
}
