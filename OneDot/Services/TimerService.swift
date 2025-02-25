//
//  TimerService.swift
//  OneDot
//
//  Created by Александр Коробицын on 26.01.2025.
//

import Foundation


class TimerService {
    
    static let shared = TimerService()
    
    var timer: Timer?
    
//    var workoutVCModeComletion: ((WorkoutVC.Mode) -> Void)?
    
//    var focusLabelCompletion: ((Int) -> Void)?
    var dashboardModeHandler: ((DashboardVC.Mode) -> Void)?
    
    var timerStateHandler: (() -> Void)?
    
    private init() {}
    
    func clearTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func startCountdown() {
        
        clearTimer()
        var timeInterval = 3
        
        dashboardModeHandler?(.workoutCountDown(Int(timeInterval)))
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] timer in
            guard let self = self else { return }
            
            timeInterval -= 1
            dashboardModeHandler?(.workoutCountDown(Int(timeInterval)))
            
            if timeInterval == 0 {
                startTimer()
            }
        })
    }
    
    func startTimer() {
        clearTimer()
//        var timeInterval = timeInterval
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
//            timeInterval += 1
            dashboardModeHandler?(.workoutStart(timer.timeInterval))
            print(timer.timeInterval)

        }
    }
    
    func startStopWatch(timeInterval: Double) {
        clearTimer()
        var timeInterval = timeInterval
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            timeInterval += 0.01
            timerStateHandler?()
        }
    }
}
