//
//  WorkoutModeModule.swift
//  OneDot
//
//  Created by Александр Коробицын on 13.01.2025.
//

import Foundation
import UIKit

class WorkoutModeVC: UIViewController {
    
    private let workoutFooter: WorkoutFooter = {
        let view = WorkoutFooter()
        view.disableAutoresizingMask()
        return view
    }()
    
    var currentWorkout: Workout
    
    enum Mode {
        case prepare
        case countdownStart
        case hide
    }
    
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
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.instance(color: .white, alignment: .center, font: .standartMid)
        label.text = "Get ready to start and click on the indicator, good luck in training and competitions"
        label.numberOfLines = 5
        return label
    }()
    
    private let countDownLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        return label
    }()
    
    init(currentWorkout: Workout) {
        self.currentWorkout = currentWorkout
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        setViews()
        setConstraints()
        activateSubviewsHandlers()
        
        modeSwitchButtonRight.configuration?.titlePadding = 40
        modeSwitchButtonLeft.setImage(UIImage(named: currentWorkout.workoutVCIcon), for: .normal)
        modeSwitchButtonLeft.setImage(UIImage(named: currentWorkout.workoutVCIcon), for: .highlighted)
        modeSwitchButtonRight.setImage(UIImage(named: "workoutStopWatch"), for: .normal)
        modeSwitchButtonRight.setImage(UIImage(named: "workoutStopWatch"), for: .highlighted)
        updateButtons(workoutModeStatus: UserDefaultsManager.shared.isWorkoutMode)
    }
    
    
    private func activateSubviewsHandlers() {
        workoutFooter.workoutModeVCButtonStateHandler = { [weak self] in self?.activateMode(mode: $0) }
    }
    
    private func updateButtons(workoutModeStatus: Bool) {
        modeSwitchButtonLeft.layer.borderColor = workoutModeStatus ? UIColor.white.cgColor : UIColor.clear.cgColor
        modeSwitchButtonRight.layer.borderColor = workoutModeStatus ? UIColor.clear.cgColor  : UIColor.white.cgColor
    }
    
    @objc private func buttonTapped() {
        UserDefaultsManager.shared.isWorkoutMode = modeSwitchButtonLeft.isTouchInside ? true : false
        UserDefaultsManager.shared.isWorkoutMode = modeSwitchButtonRight.isTouchInside ? false : true
        updateButtons(workoutModeStatus: UserDefaultsManager.shared.isWorkoutMode)
    }
    
    
    func activateMode(mode: Mode) {
        switch mode {
            
        case .prepare:
            view.isHidden = false
        case .countdownStart:
            view.isHidden = false
        case .hide:
            dismiss(animated: false)
        }
    }
    
    private func setViews() {
        view.backgroundColor = .myPaletteBlue
        
        view.addSubview(modeSwitchButtonLeft)
        view.addSubview(modeSwitchButtonRight)
        modeSwitchButtonLeft.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        modeSwitchButtonRight.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        view.addSubview(leftButtonTitle)
        view.addSubview(rightButtonTitle)
        
        view.addSubview(workoutFooter)
        view.addSubview(textLabel)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        workoutFooter.activateMode(mode: .prepare)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            modeSwitchButtonLeft.widthAnchor.constraint(equalToConstant: .barWidth / 2),
            modeSwitchButtonLeft.heightAnchor.constraint(equalToConstant: .barWidth / 2),
            modeSwitchButtonLeft.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -.barWidth / 4),
            modeSwitchButtonLeft.centerYAnchor.constraint(equalTo: view.centerYAnchor,
                                                          constant: -UIScreen.main.bounds.height / 4),
            
            modeSwitchButtonRight.widthAnchor.constraint(equalToConstant: .barWidth / 2),
            modeSwitchButtonRight.heightAnchor.constraint(equalToConstant: .barWidth / 2),
            modeSwitchButtonRight.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: .barWidth / 4),
            modeSwitchButtonRight.centerYAnchor.constraint(equalTo: view.centerYAnchor,
                                                          constant: -UIScreen.main.bounds.height / 4),
            
            leftButtonTitle.widthAnchor.constraint(equalToConstant: .barWidth / 3),
            leftButtonTitle.heightAnchor.constraint(equalToConstant: 50),
            leftButtonTitle.centerXAnchor.constraint(equalTo: modeSwitchButtonLeft.centerXAnchor),
            leftButtonTitle.centerYAnchor.constraint(equalTo: modeSwitchButtonLeft.centerYAnchor, constant: 50),
            
            rightButtonTitle.widthAnchor.constraint(equalToConstant: .barWidth / 3),
            rightButtonTitle.heightAnchor.constraint(equalToConstant: 50),
            rightButtonTitle.centerXAnchor.constraint(equalTo: modeSwitchButtonRight.centerXAnchor),
            rightButtonTitle.centerYAnchor.constraint(equalTo: modeSwitchButtonRight.centerYAnchor, constant: 50),
            
            textLabel.widthAnchor.constraint(equalToConstant: .barWidth - 100),
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            workoutFooter.widthAnchor.constraint(equalToConstant: .barWidth),
            workoutFooter.heightAnchor.constraint(equalToConstant: .bottomBarHeight),
            workoutFooter.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            workoutFooter.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
    
}
