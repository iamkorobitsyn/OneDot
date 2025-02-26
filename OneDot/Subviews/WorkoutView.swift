//
//  WorkoutSplashScreen.swift
//  OneDot
//
//  Created by Александр Коробицын on 12.01.2025.
//

import Foundation
import UIKit

class WorkoutView: UIView {
    
    let hapticGenerator = UISelectionFeedbackGenerator()
    
    enum Mode {
        case prepare
        case countdown
        case update
        case pause
        case end
    }
    
    var workoutVCButtonStateHandler: ((WorkoutVC.Mode) -> ())?
    
    var workout: Workout? { WorkoutManager.shared.currentWorkout }
    
    private let timerLabel: UILabel = UILabel()
    private let focusLabel: UILabel = UILabel()
    private let workoutModeButtonTitle: UILabel = UILabel()
    private let stopwatchModeButtonTitle: UILabel = UILabel()
    
    private let workoutModeButton: UIButton = UIButton()
    private let stopwatchModeButton: UIButton = UIButton()
    private let eraseButton: UIButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        backgroundColor = .clear
        
        setViews()
        setConstraints()
    }
    
    //MARK: - ActivateMode
    
    func activateMode(mode: Mode) {
        switch mode {
            
        case .prepare:
            self.isHidden = false
            [timerLabel, eraseButton].forEach( {$0.isHidden = true} )
            [focusLabel, workoutModeButtonTitle, stopwatchModeButtonTitle,
             workoutModeButton, stopwatchModeButton].forEach( {$0.isHidden = false} )
            focusLabel.text = "Get ready to start and click on the indicator, good luck in training and competitions"
            updateWorkoutMode(workoutModeIs: UserDefaultsManager.shared.workoutModeIs)
            focusLabel.instance(color: .white, alignment: .center, font: .standartMid)
        case .countdown:
            TimerService.shared.valueHandler = { [weak self] in self?.updateCountdown(timeInterval: $0)}
            [timerLabel, eraseButton, workoutModeButton, stopwatchModeButton,
             workoutModeButtonTitle, stopwatchModeButtonTitle].forEach( {$0.isHidden = true} )
            focusLabel.instance(color: .white, alignment: .center, font: .countDown)
        case .update:
            TimerService.shared.valueHandler = { [weak self] in self?.updateTimer(timeInterval: $0)}
            focusLabel.isHidden = true
            timerLabel.isHidden = false
        case .pause:
            print("pause")
        case .end:
            print("save")
        }
    }
    
    //MARK: - UpdateCountdown
    
    private func updateCountdown(timeInterval: Double) {
        focusLabel.text = "\(Int(timeInterval))"
    }
    
    //MARK: - UpdateTimer
    
    private func updateTimer(timeInterval: Double) {
        timerLabel.text = "\(CalculationsService.shared.formatTime(timeInterval))"
    }
    
    //MARK: - WorkoutMode

    private func updateWorkoutMode(workoutModeIs: Bool) {
        if let workout = workout {
            workoutModeButtonTitle.text = workout.name
            workoutModeButton.setImage(UIImage(named: workout.workoutIconName), for: .normal)
            workoutModeButton.setImage(UIImage(named: workout.workoutIconName), for: .highlighted)
        }
        UserDefaultsManager.shared.workoutModeIs = workoutModeIs
        workoutModeButton.layer.borderColor = workoutModeIs ? UIColor.white.cgColor : UIColor.clear.cgColor
        stopwatchModeButton.layer.borderColor = workoutModeIs ? UIColor.clear.cgColor  : UIColor.white.cgColor
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        hapticGenerator.selectionChanged()
        
        switch sender {
        case workoutModeButton:
            updateWorkoutMode(workoutModeIs: true)
        case stopwatchModeButton:
            updateWorkoutMode(workoutModeIs: false)
        case eraseButton:
            workoutVCButtonStateHandler?(.erase)
        default:
            break
        }
    }
    
    //MARK: - SetViews
    
    private func setViews() {
        
        [workoutModeButton, stopwatchModeButton, eraseButton, timerLabel,
         focusLabel, workoutModeButtonTitle, stopwatchModeButtonTitle].forEach { view in
            addSubview(view)
            view.disableAutoresizingMask()
        }
        
        workoutModeButton.layer.cornerRadius = 12
        workoutModeButton.layer.cornerCurve = .continuous
        workoutModeButton.layer.borderWidth = 1.5
        
        stopwatchModeButton.setImage(UIImage(named: "workoutStopWatch"), for: .normal)
        stopwatchModeButton.setImage(UIImage(named: "workoutStopWatch"), for: .highlighted)
        stopwatchModeButton.layer.cornerRadius = 12
        stopwatchModeButton.layer.cornerCurve = .continuous
        stopwatchModeButton.layer.borderWidth = 1.5
        
        eraseButton.setImage(UIImage(named: "FooterErase"), for: .normal)
        
        timerLabel.instance(color: .white, alignment: .center, font: .timerWatch)
        timerLabel.text = "00:00:00"
        
        focusLabel.numberOfLines = 5
        
        workoutModeButtonTitle.instance(color: .white, alignment: .center, font: .standartMin)
        workoutModeButtonTitle.numberOfLines = 2
        
        stopwatchModeButtonTitle.instance(color: .white, alignment: .center, font: .standartMin)
        stopwatchModeButtonTitle.numberOfLines = 2
        stopwatchModeButtonTitle.text = "Stopwatch"
        
        [workoutModeButton, stopwatchModeButton, eraseButton].forEach { button in
            button.addTarget(self, action: #selector(buttonTapped(_ :)), for: .touchUpInside)
        }
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            focusLabel.widthAnchor.constraint(equalToConstant: .barWidth - 100),
            focusLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            focusLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            workoutModeButton.widthAnchor.constraint(equalToConstant: .barWidth / 2),
            workoutModeButton.heightAnchor.constraint(equalToConstant: .barWidth / 2),
            workoutModeButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -.barWidth / 4),
            workoutModeButton.topAnchor.constraint(equalTo: topAnchor, constant: 150),
            
            stopwatchModeButton.widthAnchor.constraint(equalToConstant: .barWidth / 2),
            stopwatchModeButton.heightAnchor.constraint(equalToConstant: .barWidth / 2),
            stopwatchModeButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: .barWidth / 4),
            stopwatchModeButton.topAnchor.constraint(equalTo: topAnchor, constant: 150),
            
            workoutModeButtonTitle.widthAnchor.constraint(equalToConstant: .barWidth / 3),
            workoutModeButtonTitle.heightAnchor.constraint(equalToConstant: 50),
            workoutModeButtonTitle.centerXAnchor.constraint(equalTo: workoutModeButton.centerXAnchor),
            workoutModeButtonTitle.centerYAnchor.constraint(equalTo: workoutModeButton.centerYAnchor, constant: 50),
            
            stopwatchModeButtonTitle.widthAnchor.constraint(equalToConstant: .barWidth / 3),
            stopwatchModeButtonTitle.heightAnchor.constraint(equalToConstant: 50),
            stopwatchModeButtonTitle.centerXAnchor.constraint(equalTo: stopwatchModeButton.centerXAnchor),
            stopwatchModeButtonTitle.centerYAnchor.constraint(equalTo: stopwatchModeButton.centerYAnchor, constant: 50),
            
            timerLabel.widthAnchor.constraint(equalToConstant: .barWidth),
            timerLabel.heightAnchor.constraint(equalToConstant: .barWidth / 2),
            timerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 150),
            
            eraseButton.widthAnchor.constraint(equalToConstant: 42),
            eraseButton.heightAnchor.constraint(equalToConstant: 42),
            eraseButton.centerXAnchor.constraint(equalTo: stopwatchModeButton.centerXAnchor),
            eraseButton.bottomAnchor.constraint(equalTo: stopwatchModeButton.topAnchor)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
