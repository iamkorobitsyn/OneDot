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
    }
    
    var workout: Workout? { WorkoutManager.shared.currentWorkout }
    
    private let timerLabel: UILabel = UILabel()
    private let focusLabel: UILabel = UILabel()
    private let workoutModeButtonTitle: UILabel = UILabel()
    private let stopwatchModeButtonTitle: UILabel = UILabel()
    
    private let workoutModeButton: UIButton = UIButton()
    private let stopwatchModeButton: UIButton = UIButton()
    private let eraseButton: UIButton = UIButton()
    
    private let distanceView: DescriptionModuleView = DescriptionModuleView()
    private let caloriesBurnedView: DescriptionModuleView = DescriptionModuleView()
    private let separator: CAShapeLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        backgroundColor = .clear
        
        setViews()
        setConstraints()
    }
    
    override func layoutSubviews() {
        GraphicsService.shared.drawShape(shape: separator, shapeType: .workoutSingleSeparator, view: self)
    }
    
    //MARK: - ActivateMode
    
    func activateMode(mode: Mode) {
        switch mode {
        case .prepare:
            separator.isHidden = true
            updateVisible(views: [focusLabel, workoutModeButtonTitle, stopwatchModeButtonTitle,
                                  workoutModeButton, stopwatchModeButton, self])
            timerLabel.text = "00:00:00"
            focusLabel.text = "Get ready to start and click on the indicator, good luck in training and competitions"
            focusLabel.instance(color: .white, alignment: .center, font: .standartMid)
            distanceView.activateMode(axis: .horizontalExpanded, mode: .distanceTracking, text: "0.00")
            caloriesBurnedView.activateMode(axis: .horizontalExpanded, mode: .caloriesTracking, text: "0")
            updateWorkoutMode(workoutModeIs: UserDefaultsManager.shared.workoutModeIs)
            
        case .countdown:
            updateVisible(views: [focusLabel])
            focusLabel.instance(color: .white, alignment: .center, font: .countDown)
            TimerService.shared.valueHandler = { [weak self] countdown in
                guard let self else {return}
                updateVisibleValues(countdown: countdown, interval: nil, distance: nil, calories: nil)
            }
            
        case .update:
            if UserDefaultsManager.shared.workoutModeIs {
                if UserDefaultsManager.shared.isGeoTracking {
                    separator.isHidden = false
                    updateVisible(views: [timerLabel, distanceView, caloriesBurnedView])
                } else {
                    updateVisible(views: [timerLabel, caloriesBurnedView])
                }
                WorkoutManager.shared.valuesHandler = { [weak self] distance, calories in
                    guard let self else {return}
                    updateVisibleValues(countdown: nil, interval: nil, distance: distance, calories: calories)
                }
            } else {
                updateVisible(views: [timerLabel, eraseButton])
            }
            
            TimerService.shared.valueHandler = { [weak self] timeInterval in
                guard let self else {return}
                updateVisibleValues(countdown: nil, interval: timeInterval, distance: nil, calories: nil)
            }
        }
    }
    
    //MARK: - UpdateVisible
    
    private func updateVisible(views: [UIView]) {
        [timerLabel, focusLabel, workoutModeButtonTitle, stopwatchModeButtonTitle,
         workoutModeButton, stopwatchModeButton, eraseButton, distanceView, caloriesBurnedView].forEach({$0.isHidden = true})
        views.forEach({$0.isHidden = false})
    }
    
    //MARK: - UpdateVisibleValues
    
    private func updateVisibleValues(countdown: Double?, interval: Double?, distance: Double?, calories: Double?) {
        if let countdown = countdown {
            focusLabel.text = "\(Int(countdown))"
        }
        if let interval = interval {
            timerLabel.text = "\(CalculationsService.shared.formatTime(interval))"
        }
        if let distance = distance {
            let kilometers = distance / 1000
            let roundedKilometers = String(format: "%.2f", kilometers)
            distanceView.activateMode(axis: .horizontalExpanded, mode: .distanceTracking, text: "\(roundedKilometers)")
        }
        if let calories = calories {
            caloriesBurnedView.activateMode(axis: .horizontalExpanded, mode: .caloriesTracking, text: "\(Int(calories))")
        }
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
    
    //MARK: - ButtonTapped
    
    @objc private func buttonTapped(_ sender: UIButton) {
        hapticGenerator.selectionChanged()
        
        switch sender {
        case workoutModeButton:
            updateWorkoutMode(workoutModeIs: true)
        case stopwatchModeButton:
            updateWorkoutMode(workoutModeIs: false)
        case eraseButton:
            timerLabel.text = "00:00.00"
            TimerService.shared.timeInterval = 0.0
        default:
            break
        }
    }
    
    //MARK: - SetViews
    
    private func setViews() {
        
        [workoutModeButton, stopwatchModeButton, eraseButton, timerLabel, focusLabel,
         workoutModeButtonTitle, stopwatchModeButtonTitle, distanceView, caloriesBurnedView].forEach { view in
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
            
            distanceView.widthAnchor.constraint(equalToConstant: 200),
            distanceView.heightAnchor.constraint(equalToConstant: 25),
            distanceView.centerXAnchor.constraint(equalTo: centerXAnchor),
            distanceView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -30),
            
            caloriesBurnedView.widthAnchor.constraint(equalToConstant: 200),
            caloriesBurnedView.heightAnchor.constraint(equalToConstant: 25),
            caloriesBurnedView.centerXAnchor.constraint(equalTo: centerXAnchor),
            caloriesBurnedView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 30),
            
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
