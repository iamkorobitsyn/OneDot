//
//  WorkoutModeHeader.swift
//  OneDot
//
//  Created by Александр Коробицын on 15.01.2025.
//

import Foundation
import UIKit

class WorkoutHeaderView: UIView {
    
    let hapticGenerator = UISelectionFeedbackGenerator()
    
    enum Mode {
        case prepare
        case countdown
        case workout
        case stopWatch
        case pause
    }
    
    var workoutVCButtonStateHandler: ((WorkoutVC.Mode) -> ())?
    
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
    
    private let workoutTitle: UILabel = {
        let label = UILabel()
        label.instance(color: .white, alignment: .center, font: .standartMid)
        label.disableAutoresizingMask()
        return label
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
        label.text = "Workout Mode"
        return label
    }()
    
    private let rightButtonTitle: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.instance(color: .white, alignment: .center, font: .standartMin)
        label.numberOfLines = 2
        label.text = "Stopwatch Mode"
        return label
    }()
    

    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setViews()
        setConstraints()
        activateMode(mode: .prepare)
    }
    
    //MARK: - ActivateMode
    
    func activateMode(mode: Mode) {
        switch mode {
        case .prepare:
            clearVisibleViews()
            modeSwitchButtonLeft.isHidden = false
            modeSwitchButtonRight.isHidden = false
            eraseButton.isHidden = true
            leftButtonTitle.isHidden = false
            rightButtonTitle.isHidden = false
        case .countdown:
            clearVisibleViews()
        case .workout:
            clearVisibleViews()
            workoutTitle.isHidden = false
            timerLabel.isHidden = false
        case .stopWatch:
            clearVisibleViews()
            timerLabel.isHidden = false
            eraseButton.isHidden = false
        case .pause:
            clearVisibleViews()
            timerLabel.isHidden = false
            eraseButton.isHidden = UserDefaultsManager.shared.isWorkoutMode
        }
    }
    
    //MARK: - UpdateTimerLabel
    
    func updateTimerLabel(text: String) {
        timerLabel.text = text
    }
    
    //MARK: - ClearVisibleViews
    
    private func clearVisibleViews() {
        [workoutTitle, timerLabel, modeSwitchButtonLeft, modeSwitchButtonRight, eraseButton,
         leftButtonTitle, rightButtonTitle].forEach({$0.isHidden = true})
    }
    
    //MARK: - WorkoutMode
    
    func setWorkoutMode(title: String, workoutImageNamed: String) {
        workoutTitle.text = title
        
        modeSwitchButtonLeft.setImage(UIImage(named: workoutImageNamed), for: .normal)
        modeSwitchButtonLeft.setImage(UIImage(named: workoutImageNamed), for: .highlighted)
        
        let status = UserDefaultsManager.shared.isWorkoutMode
        modeSwitchButtonLeft.layer.borderColor = status ? UIColor.white.cgColor : UIColor.clear.cgColor
        modeSwitchButtonRight.layer.borderColor = status ? UIColor.clear.cgColor  : UIColor.white.cgColor
    }

    private func updateWorkoutMode() {
        
        UserDefaultsManager.shared.isWorkoutMode = modeSwitchButtonLeft.isTouchInside ? true : false
        UserDefaultsManager.shared.isWorkoutMode = modeSwitchButtonRight.isTouchInside ? false : true
        
        let status = UserDefaultsManager.shared.isWorkoutMode
        modeSwitchButtonLeft.layer.borderColor = status ? UIColor.white.cgColor : UIColor.clear.cgColor
        modeSwitchButtonRight.layer.borderColor = status ? UIColor.clear.cgColor  : UIColor.white.cgColor
    }
    
    @objc private func buttonTapped() {
        hapticGenerator.selectionChanged()
        
        switch true {
        case modeSwitchButtonLeft.isTouchInside, modeSwitchButtonRight.isTouchInside:
            updateWorkoutMode()
        case eraseButton.isTouchInside:
            workoutVCButtonStateHandler?(.erase)
        default:
            break
        }
    }
    
    //MARK: - SetViews
    
    private func setViews() {
        
        addSubview(modeSwitchButtonLeft)
        addSubview(modeSwitchButtonRight)
        modeSwitchButtonLeft.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        modeSwitchButtonRight.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        eraseButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        addSubview(leftButtonTitle)
        addSubview(rightButtonTitle)
        addSubview(timerLabel)
        addSubview(eraseButton)
        addSubview(workoutTitle)
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            workoutTitle.widthAnchor.constraint(equalToConstant: .barWidth),
            workoutTitle.heightAnchor.constraint(equalToConstant: 20),
            workoutTitle.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            workoutTitle.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            modeSwitchButtonLeft.widthAnchor.constraint(equalToConstant: .barWidth / 2),
            modeSwitchButtonLeft.heightAnchor.constraint(equalToConstant: .barWidth / 2),
            modeSwitchButtonLeft.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -.barWidth / 4),
            modeSwitchButtonLeft.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            modeSwitchButtonRight.widthAnchor.constraint(equalToConstant: .barWidth / 2),
            modeSwitchButtonRight.heightAnchor.constraint(equalToConstant: .barWidth / 2),
            modeSwitchButtonRight.centerXAnchor.constraint(equalTo: centerXAnchor, constant: .barWidth / 4),
            modeSwitchButtonRight.bottomAnchor.constraint(equalTo: bottomAnchor),
            
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
