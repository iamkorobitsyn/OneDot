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
        case countdown(Int)
        case start(Double)
        case pause
        case end
    }
    
    var workoutVCButtonStateHandler: ((WorkoutVC.Mode) -> ())?
    
    var workout: Workout?
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.instance(color: .white, alignment: .center, font: .timerWatch)
        label.text = "00:00:00"
        return label
    }()
    
    private let eraseButton: UIButton = {
        let button = UIButton()
        button.disableAutoresizingMask()
        button.setImage(UIImage(named: "FooterErase"), for: .normal)
        return button
    }()
    
    private let modeSwitchButtonLeft: UIButton = {
        let button = UIButton()
        button.disableAutoresizingMask()
        button.layer.cornerRadius = 12
        button.layer.cornerCurve = .continuous
        button.layer.borderWidth = 1.5
        return button
    }()
    
    private let modeSwitchButtonRight: UIButton = {
        let button = UIButton()
        button.disableAutoresizingMask()
        button.setImage(UIImage(named: "workoutStopWatch"), for: .normal)
        button.setImage(UIImage(named: "workoutStopWatch"), for: .highlighted)
        button.layer.cornerRadius = 12
        button.layer.cornerCurve = .continuous
        button.layer.borderWidth = 1.5
        return button
    }()
    
    private let leftButtonTitle: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.instance(color: .white, alignment: .center, font: .standartMin)
        label.numberOfLines = 2
        return label
    }()
    
    private let rightButtonTitle: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.instance(color: .white, alignment: .center, font: .standartMin)
        label.numberOfLines = 2
        label.text = "Stopwatch"
        return label
    }()
    
    private let focusLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.text = "Get ready to start and click on the indicator, good luck in training and competitions"
        label.numberOfLines = 5
        return label
    }()
    
    private let countDownLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        backgroundColor = .clear
        addSubview(focusLabel)
        
        setViews()
        setConstraints()
        
    }
    
    //MARK: - ActivateMode
    
    func activateMode(mode: Mode) {
        switch mode {
            
        case .prepare:
            self.isHidden = false
            [timerLabel, eraseButton].forEach( {$0.isHidden = true} )
            updateWorkoutMode(workoutModeIs: UserDefaultsManager.shared.isWorkoutMode)
            focusLabel.instance(color: .white, alignment: .center, font: .standartMid)
        case .countdown(let value):
            [timerLabel, eraseButton, modeSwitchButtonLeft, modeSwitchButtonRight,
             leftButtonTitle, rightButtonTitle].forEach( {$0.isHidden = true} )
            focusLabel.instance(color: .white, alignment: .center, font: .countDown)
            focusLabel.text = "\(value)"
        case .start(let value):
            timerLabel.isHidden = false
            focusLabel.isHidden = true
        case .pause:
            print("pause")
        case .end:
            print("save")
        }
    }
    
    //MARK: - UpdateTimerLabel
    
    private func updateTimerLabel(text: String) {
        timerLabel.text = text
    }
    
    //MARK: - ClearVisibleViews
    
    private func clearVisibleViews() {
        [timerLabel, modeSwitchButtonLeft, modeSwitchButtonRight, eraseButton,
         leftButtonTitle, rightButtonTitle].forEach({$0.isHidden = true})
    }
    
    //MARK: - WorkoutMode

    private func updateWorkoutMode(workoutModeIs: Bool) {
        if let workout = workout {
            leftButtonTitle.text = workout.name
            modeSwitchButtonLeft.setImage(UIImage(named: workout.workoutIconName), for: .normal)
            modeSwitchButtonLeft.setImage(UIImage(named: workout.workoutIconName), for: .highlighted)
        }
        UserDefaultsManager.shared.isWorkoutMode = workoutModeIs
        modeSwitchButtonLeft.layer.borderColor = workoutModeIs ? UIColor.white.cgColor : UIColor.clear.cgColor
        modeSwitchButtonRight.layer.borderColor = workoutModeIs ? UIColor.clear.cgColor  : UIColor.white.cgColor
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        hapticGenerator.selectionChanged()
        
        switch sender {
        case modeSwitchButtonLeft:
            updateWorkoutMode(workoutModeIs: true)
        case modeSwitchButtonRight:
            updateWorkoutMode(workoutModeIs: false)
        case eraseButton:
            workoutVCButtonStateHandler?(.erase)
        default:
            break
        }
    }
    
    //MARK: - SetViews
    
    private func setViews() {
        
        addSubview(modeSwitchButtonLeft)
        addSubview(modeSwitchButtonRight)
        modeSwitchButtonLeft.addTarget(self, action: #selector(buttonTapped(_ :)), for: .touchUpInside)
        modeSwitchButtonRight.addTarget(self, action: #selector(buttonTapped(_ :)), for: .touchUpInside)
        eraseButton.addTarget(self, action: #selector(buttonTapped(_ :)), for: .touchUpInside)

        addSubview(leftButtonTitle)
        addSubview(rightButtonTitle)
        addSubview(timerLabel)
        addSubview(eraseButton)
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            focusLabel.widthAnchor.constraint(equalToConstant: .barWidth - 100),
            focusLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            focusLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            modeSwitchButtonLeft.widthAnchor.constraint(equalToConstant: .barWidth / 2),
            modeSwitchButtonLeft.heightAnchor.constraint(equalToConstant: .barWidth / 2),
            modeSwitchButtonLeft.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -.barWidth / 4),
            modeSwitchButtonLeft.topAnchor.constraint(equalTo: topAnchor, constant: 150),
            
            modeSwitchButtonRight.widthAnchor.constraint(equalToConstant: .barWidth / 2),
            modeSwitchButtonRight.heightAnchor.constraint(equalToConstant: .barWidth / 2),
            modeSwitchButtonRight.centerXAnchor.constraint(equalTo: centerXAnchor, constant: .barWidth / 4),
            modeSwitchButtonRight.topAnchor.constraint(equalTo: topAnchor, constant: 150),
            
            leftButtonTitle.widthAnchor.constraint(equalToConstant: .barWidth / 3),
            leftButtonTitle.heightAnchor.constraint(equalToConstant: 50),
            leftButtonTitle.centerXAnchor.constraint(equalTo: modeSwitchButtonLeft.centerXAnchor),
            leftButtonTitle.centerYAnchor.constraint(equalTo: modeSwitchButtonLeft.centerYAnchor, constant: 50),
            
            rightButtonTitle.widthAnchor.constraint(equalToConstant: .barWidth / 3),
            rightButtonTitle.heightAnchor.constraint(equalToConstant: 50),
            rightButtonTitle.centerXAnchor.constraint(equalTo: modeSwitchButtonRight.centerXAnchor),
            rightButtonTitle.centerYAnchor.constraint(equalTo: modeSwitchButtonRight.centerYAnchor, constant: 50),
            
            timerLabel.widthAnchor.constraint(equalToConstant: .barWidth),
            timerLabel.heightAnchor.constraint(equalToConstant: .barWidth / 2),
            timerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timerLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            eraseButton.widthAnchor.constraint(equalToConstant: 42),
            eraseButton.heightAnchor.constraint(equalToConstant: 42),
            eraseButton.centerXAnchor.constraint(equalTo: modeSwitchButtonRight.centerXAnchor),
            eraseButton.bottomAnchor.constraint(equalTo: modeSwitchButtonRight.topAnchor)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
