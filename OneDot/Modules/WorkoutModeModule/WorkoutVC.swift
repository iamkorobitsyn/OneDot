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
    private var startDate: Date = Date()
    private var timeInterval: TimeInterval = 0.0
    private var totalCalories: Double = 0.0
    private var locationCoordinates: [CLLocation] = []
    private var totalDistance: Double = 0.0
    

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
    
//    private let footer: FooterBarView = {
//        let view = FooterBarView()
//        view.disableAutoresizingMask()
//        return view
//    }()
    
    private let footerSeparator: CAShapeLayer = CAShapeLayer()

    init(currentWorkout: Workout) {
        self.currentWorkout = currentWorkout
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - DidLoad
    
    override func viewDidLoad() {
        UIApplication.shared.isIdleTimerDisabled = true
        view.backgroundColor = .red
        setViews()
        setConstraints()
        activateSubviewsHandlers()
        
        Task {await LocationService.shared.requestAuthorization()}
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        GraphicsService.shared.drawShape(shape: footerSeparator, shapeType: .footerSingleSeparator, view: footer)
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.isIdleTimerDisabled = false
    }

    private func activateSubviewsHandlers() {
//        footer.workoutVCButtonStateHandler =
//        { [weak self] in self?.activateMode(mode: $0) }
        
        header.workoutVCButtonStateHandler =
        { [weak self] in self?.activateMode(mode: $0) }
        
//        LocationService.shared.didUpdateDistance =
//        { [weak self] in self?.totalDistance = $0}
//        
//        LocationService.shared.didUpdateCoordinates =
//        { [weak self] in self?.locationCoordinates.append($0)}
        
//        TimerService.shared.workoutVCModeComletion =
//        { [weak self] in self?.activateMode(mode: $0)}
        
//        TimerService.shared.focusLabelCompletion =
//        { [weak self] in self?.body.updateFocusLabel(text: "\($0)", countdownSize: true)}
        
//        TimerService.shared.timerStateHandler = { [weak self] in
//            guard let self else { return }
//            
//            timeInterval += 1
//            
//            totalCalories = currentWorkout.averageCalBurnedPerSec * timeInterval
//            header.updateTimerLabel(text: CalculationsService.shared.formatTime(timeInterval))
//            
//
//            body.updateTrackingState(isGeoTracking: true,
//                                     duration: timeInterval,
//                                     distance: totalDistance,
//                                     calories: totalCalories)
//        }
        
    }
    
    //MARK: - ActivateMode
    
    func activateMode(mode: Mode) {
        workoutState = mode
        
        switch mode {
        case .prepare:
            header.setWorkoutMode(title: currentWorkout.name, workoutImageNamed: currentWorkout.workoutIconName)
            body.activateMode(mode: .prepare)
//            footer.activateMode(mode: .prepare)
            
        case .countdown:
            header.activateMode(mode: .countdown)
            body.activateMode(mode: .countdown)
//            footer.activateMode(mode: .hide)
            TimerService.shared.startCountdown()
            
        case .start:
//            footer.activateMode(mode: .start)
            hapticGenerator.selectionChanged()
            startDate = .now
            
//            if UserDefaultsManager.shared.workoutModeIs {
//                if UserDefaultsManager.shared.isGeoTracking {
//                    LocationService.shared.startTracking()
//                    LocationService.shared.recording = true
//                }
//                TimerService.shared.startTimer()
//                header.activateMode(mode: .workout)
//                body.activateMode(mode: .workout)
//            } else {
//                TimerService.shared.startStopWatch(timeInterval: timeInterval)
//                LocationService.shared.stopTracking()
//                header.activateMode(mode: .stopWatch)
//                body.activateMode(mode: .stopWatch)
//            }
            
        case .pause:
            header.activateMode(mode: .pause)
            body.activateMode(mode: .pause)
//            footer.activateMode(mode: .pause)
            header.updateTimerLabel(text: CalculationsService.shared.formatTime(timeInterval))
            TimerService.shared.clearTimer()
            
        case .erase:
            header.activateMode(mode: .pause)
            body.activateMode(mode: .pause)
//            footer.activateMode(mode: .pause)
            TimerService.shared.clearTimer()
            timeInterval = 0
            header.updateTimerLabel(text: CalculationsService.shared.formatTime(timeInterval))
            
        case .completion:
//            footer.activateMode(mode: .completion)
            body.activateMode(mode: .completion)
            
        case .saving:
            
            Task {
                do {
                    try await WorkoutManager.shared.saveWorkout(name: currentWorkout.name,
                                                                startDate: startDate,
                                                                duration: timeInterval,
                                                                energyBurned: totalCalories,
                                                                distance: totalDistance,
                                                                coordinates: locationCoordinates)
                } catch {
                    if let error = error as? WorkoutManager.InternalError {
                        switch error {
                            
                        case .notAuthorized(let description):
                            print("not authorized")
                            print("\(description)")
                        case .workoutIsEmpty:
                            print("workout is empty")
                        }
                    }
                }
                dismiss(animated: false)
                LocationService.shared.stopTracking()
                TimerService.shared.clearTimer()
            }

            
            
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
//        view.addSubview(footer)
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

//            footer.widthAnchor.constraint(equalToConstant: .barWidth),
//            footer.heightAnchor.constraint(equalToConstant: .bottomBarHeight),
//            footer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            footer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
    
}
