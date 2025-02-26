//
//  TimerService.swift
//  OneDot
//
//  Created by Александр Коробицын on 26.01.2025.
//

import Foundation


class TimerService {
    
    static let shared = TimerService()
    
    lazy var timeInterval = 0.0
    private var timer: Timer?
    private var workoutModeIs: Bool { UserDefaultsManager.shared.workoutModeIs }
    
    
    
    var dashboardModeHandler: ((DashboardVC.Mode) -> Void)?
    var valueHandler: ((Double) -> Void)?
    
    private init() {}
    
    func clearTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func startCountdown() {
        
        clearTimer()
        timeInterval = 3.0
        valueHandler?(timeInterval)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] timer in
            guard let self = self else { return }
            
            timeInterval -= 1
            valueHandler?(timeInterval)
            
            if timeInterval == 0 {
                dashboardModeHandler?(.start)
            }
        })
    }
    
    func startTimer() {
        clearTimer()
        if workoutModeIs {
            valueHandler?(timeInterval)
            
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
                guard let self = self else { return }
                
                timeInterval += 1
                valueHandler?(timeInterval)
                let distance = LocationService.shared.totalDistance
                let locations = LocationService.shared.locations
                WorkoutManager.shared.updateWorkout(timeInterval: timeInterval, totalDistance: distance, locations: locations)
            }
        } else {
            valueHandler?(timeInterval)
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] timer in
                guard let self = self else { return }
                timeInterval += 0.01
                valueHandler?(timeInterval)
            }
        }
    }
}
