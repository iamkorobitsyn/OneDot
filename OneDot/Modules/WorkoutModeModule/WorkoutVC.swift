//
//  WorkoutModeModule.swift
//  OneDot
//
//  Created by Александр Коробицын on 13.01.2025.
//

import Foundation
import UIKit

class WorkoutVC: UIViewController {
    
    let hapticGenerator = UISelectionFeedbackGenerator()
    
    var currentWorkout: Workout
    var currentDistance: Double?
    var currentCalories: Double?
    
    private var locationManager = WorkoutManager()

    enum Mode {
        case prepare
        case countdown
        case start
        case pause
        case erase
        case hide
        case completion
        case saving
    }
    
    private var timer: Timer?
    private var timeInterval: TimeInterval = 0
    
    private var currentMode: Mode = .prepare
    
    private let header: WorkoutHeader = {
        let view = WorkoutHeader()
        view.disableAutoresizingMask()
        return view
    }()
    
    private let body: WorkoutView = {
        let view = WorkoutView()
        view.disableAutoresizingMask()
        return view
    }()
    
    private let footer: WorkoutFooter = {
        let view = WorkoutFooter()
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
        
        locationManager.requestAuthorization()
               
               locationManager.didUpdateDistance = { result in

                       self.currentDistance = result

               }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        footer.activateMode(mode: .prepare)
    }

    private func activateSubviewsHandlers() {
        footer.workoutVCButtonStateHandler = { [weak self] in self?.activateMode(mode: $0) }
        header.workoutVCButtonStateHandler = { [weak self] in self?.activateMode(mode: $0) }
    }
    
    //MARK: - ActivateMode
    
    func activateMode(mode: Mode) {
        switch mode {
        case .prepare:
            header.setWorkoutMode(title: currentWorkout.titleName,
                                         workoutImageNamed: currentWorkout.workoutVCIcon)
            body.activateMode(mode: .prepare)
            footer.activateMode(mode: .prepare)
            
        case .countdown:
            hapticGenerator.selectionChanged()
            currentMode = .countdown
            header.activateMode(mode: .countdown)
            body.activateMode(mode: .countdown)
            footer.activateMode(mode: .hide)
            updatingTimer()
        case .start:
            hapticGenerator.selectionChanged()
            currentMode = .start
            if UserDefaultsManager.shared.isWorkoutMode {
                header.activateMode(mode: .workout)
                body.activateMode(mode: .workout)
                footer.activateMode(mode: .start)
                locationManager.startTracking()
            } else {
                header.activateMode(mode: .stopWatch)
                body.activateMode(mode: .stopWatch)
                footer.activateMode(mode: .start)
            }
            updatingTimer()
        case .pause:
            hapticGenerator.selectionChanged()
            currentMode = .pause
            header.activateMode(mode: .pause)
            body.activateMode(mode: .pause)
            footer.activateMode(mode: .pause)
            updatingTimer()
        case .erase:
            hapticGenerator.selectionChanged()
            currentMode = .pause
            header.activateMode(mode: .pause)
            body.activateMode(mode: .pause)
            footer.activateMode(mode: .pause)
            timeInterval = 0
            updatingTimer()
        case .hide:
            dismiss(animated: false)
        case .completion:
            footer.activateMode(mode: .completion)
            body.activateMode(mode: .completion)
            timer?.invalidate()
        case .saving:
            print("saveWorkout")
            dismiss(animated: false)
            locationManager.stopTracking()
        }
    }
    
    //MARK: - UpdatingTimer
    
    private func updatingTimer() {
        
        timer?.invalidate()
        timer = nil
        
        switch currentMode {
        case .countdown:
            timeInterval = 3
            body.updateFocusLabel(text: "3", countdownSize: true)
            
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
                
                self.timeInterval -= 1
                self.body.updateFocusLabel(text: "\(Int(self.timeInterval))", countdownSize: true)
                
                if self.timeInterval == 0 {
                    self.activateMode(mode: .start)
                }
            })

        case .start:
            
            body.updateTrackingState(isGeoTracking: currentWorkout.checkLocation,
                                     duration: timeInterval,
                                     distance: currentDistance ?? 0,
                                     calories: currentCalories ?? 0)

            if UserDefaultsManager.shared.isWorkoutMode {
                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
                    
                    guard let self = self else { return }
                    timeInterval += 1
                    header.updateTimerLabel(text: formatTime(timeInterval))
                    
                    currentCalories = currentWorkout.averageCalBurnedPerSec * timeInterval

                    body.updateTrackingState(isGeoTracking: currentWorkout.checkLocation,
                                             duration: timeInterval,
                                             distance: currentDistance ?? 0,
                                             calories: currentCalories ?? 0)

                }
            } else {
                timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] timer in
                    guard let self = self else { return }
                    timeInterval += 0.01
                    header.updateTimerLabel(text: formatTime(timeInterval))
                }
            }
            
        case .pause:
                header.updateTimerLabel(text: formatTime(timeInterval))

        default:
            break
        }
    }
    
    //MARK: - FormatTime
    
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        if UserDefaultsManager.shared.isWorkoutMode {
            let hours = Int(timeInterval) / 3600
            let minutes = Int(timeInterval) / 60 % 60
            let seconds = Int(timeInterval) % 60
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            let minutes = Int(timeInterval) / 60
            let seconds = Int(timeInterval) % 60
            let milliseconds = Int((timeInterval - Double(Int(timeInterval))) * 100)
            return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
        }
    }

    private func hideViews(views: [UIView]) {
        views.forEach({ $0.isHidden = true })
    }
    
    
    //MARK: - Resume Timer
    
    func resumeTimer() {
        updatingTimer()
        currentMode = .start
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
