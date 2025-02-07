//
//  WorkoutModeModule.swift
//  OneDot
//
//  Created by Александр Коробицын on 13.01.2025.
//

import Foundation
import MapKit
import UIKit

class WorkoutVC: UIViewController {
    
    let hapticGenerator = UISelectionFeedbackGenerator()
    
    var currentWorkout: Workout
    private var startDate: Date?
    private var timeInterval: TimeInterval?
    private var locationCoordinates: [CLLocationCoordinate2D] = []
    private var totalDistance: Double?
    private var totalCalories: Double?

    enum Mode {
        case prepare
        case countdown
        case start
        case pause
        case erase
        case completion
        case saving
        case hide
    }
    
    private var workoutState: Mode = .prepare
    
    private let header: WorkoutHeaderView = {
        let view = WorkoutHeaderView()
        view.disableAutoresizingMask()
        return view
    }()
    
    private let body: WorkoutBodyView = {
        let view = WorkoutBodyView()
        view.disableAutoresizingMask()
        return view
    }()
    
    private let footer: WorkoutFooterView = {
        let view = WorkoutFooterView()
        view.disableAutoresizingMask()
        return view
    }()

    init(currentWorkout: Workout) {
        self.currentWorkout = currentWorkout
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - DidLoad
    
    override func viewDidLoad() {
        setViews()
        setConstraints()
        activateSubviewsHandlers()
        
        Task {await LocationService.shared.requestAuthorization()}
    }

    private func activateSubviewsHandlers() {
        footer.workoutVCButtonStateHandler =
        { [weak self] in self?.activateMode(mode: $0) }
        
        header.workoutVCButtonStateHandler =
        { [weak self] in self?.activateMode(mode: $0) }
        
        LocationService.shared.didUpdateDistance =
        { [weak self] in self?.totalDistance = $0}
        
        LocationService.shared.didUpdateCoordinates =
        { [weak self] in self?.locationCoordinates.append($0)}
        
        TimerService.shared.workoutVCModeComletion =
        { [weak self] in self?.activateMode(mode: $0)}
        
        TimerService.shared.focusLabelCompletion =
        { [weak self] in self?.body.updateFocusLabel(text: "\($0)", countdownSize: true)}
        
        TimerService.shared.timerLabelCompletion = { [weak self] timeInterval in
            guard let self = self else {return}
            
            self.timeInterval = timeInterval
            
            header.updateTimerLabel(text: CalculationsService.shared.formatTime(timeInterval))
            totalCalories = currentWorkout.averageCalBurnedPerSec * timeInterval

            body.updateTrackingState(isGeoTracking: currentWorkout.checkLocation,
                                     duration: timeInterval,
                                     distance: totalDistance ?? 0,
                                     calories: totalCalories ?? 0)
        }
        
    }
    
    //MARK: - ActivateMode
    
    func activateMode(mode: Mode) {
        workoutState = mode
        
        switch mode {
        case .prepare:
            header.setWorkoutMode(title: currentWorkout.titleName, workoutImageNamed: currentWorkout.workoutVCIcon)
            body.activateMode(mode: .prepare)
            footer.activateMode(mode: .prepare)
            
        case .countdown:
            header.activateMode(mode: .countdown)
            body.activateMode(mode: .countdown)
            footer.activateMode(mode: .hide)
            TimerService.shared.startCountdown()
            
        case .start:
            footer.activateMode(mode: .start)
            hapticGenerator.selectionChanged()
            startDate = Date()
            
            if UserDefaultsManager.shared.isWorkoutMode {
                if UserDefaultsManager.shared.isGeoTracking {
                    LocationService.shared.startTracking()
                    LocationService.shared.recordingCoordinates = true
                }
                TimerService.shared.startTimer(timeInterval: timeInterval ?? 0)
                header.activateMode(mode: .workout)
                body.activateMode(mode: .workout)
            } else {
                TimerService.shared.startStopWatch(timeInterval: timeInterval ?? 0)
                LocationService.shared.stopTracking()
                header.activateMode(mode: .stopWatch)
                body.activateMode(mode: .stopWatch)
            }
            
        case .pause:
            header.activateMode(mode: .pause)
            body.activateMode(mode: .pause)
            footer.activateMode(mode: .pause)
            header.updateTimerLabel(text: CalculationsService.shared.formatTime(timeInterval ?? 0))
            TimerService.shared.clearTimer()
            
        case .erase:
            header.activateMode(mode: .pause)
            body.activateMode(mode: .pause)
            footer.activateMode(mode: .pause)
            TimerService.shared.clearTimer()
            timeInterval = 0
            header.updateTimerLabel(text: CalculationsService.shared.formatTime(timeInterval ?? 0))
            
        case .completion:
            footer.activateMode(mode: .completion)
            body.activateMode(mode: .completion)
            
        case .saving:
            guard let startDate = startDate else {return}
            WorkoutManager.shared.saveWorkout(activityType: .running, locationType: .indoor,
                                              startDate: startDate, duration: 1000, energyBurned: 349,
                                              distance: 10000) { success, error in
                if success {
                       print("Тренировка успешно сохранена в HealthKit.")
                   } else {
                       print("Ошибка сохранения тренировки: \(String(describing: error))")
                   }
            }

            dismiss(animated: false)
            LocationService.shared.stopTracking()
            
        case .hide:
            dismiss(animated: false)
        }
    }
    

    private func hideViews(views: [UIView]) {
        views.forEach({ $0.isHidden = true })
    }
    

    
    //MARK: - SetViews
    
    private func setViews() {
        view.backgroundColor = .myPaletteBlue
        view.addSubview(body)
        view.addSubview(header)
        view.addSubview(footer)
        activateMode(mode: .prepare)
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            header.widthAnchor.constraint(equalToConstant: .barWidth),
            header.heightAnchor.constraint(equalToConstant: .barWidth / 2 + 150),
            header.topAnchor.constraint(equalTo: view.topAnchor),
            header.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            body.topAnchor.constraint(equalTo: view.topAnchor),
            body.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            body.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            body.leadingAnchor.constraint(equalTo: view.leadingAnchor),

            footer.widthAnchor.constraint(equalToConstant: .barWidth),
            footer.heightAnchor.constraint(equalToConstant: .bottomBarHeight),
            footer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            footer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
    
}
