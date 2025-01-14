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
    
    var currentWorkout: Workout?
    
    enum Mode {
        case prepare
        case countdownStart
        case hide
    }
    
    private let modeSwitchButtonLeft: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.disableAutoresizingMask()
        return button
    }()
    
    private let modeSwitchButtonRight: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.disableAutoresizingMask()
        return button
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
    
    
    override func viewDidLoad() {
        setViews()
        setConstraints()
        activateSubviewsHandlers()
        print(currentWorkout?.workoutVCIcon)
    }
    
    private func activateSubviewsHandlers() {
        workoutFooter.workoutModeVCButtonStateHandler = { [weak self] in self?.activateMode(mode: $0) }
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
        
        view.addSubview(workoutFooter)
        view.addSubview(textLabel)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        workoutFooter.activateMode(mode: .prepare)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            modeSwitchButtonLeft.widthAnchor.constraint(equalToConstant: 150),
            modeSwitchButtonLeft.heightAnchor.constraint(equalToConstant: 150),
            modeSwitchButtonLeft.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -75),
            modeSwitchButtonLeft.centerYAnchor.constraint(equalTo: view.centerYAnchor,
                                                          constant: -UIScreen.main.bounds.height / 4),
            
            modeSwitchButtonRight.widthAnchor.constraint(equalToConstant: 150),
            modeSwitchButtonRight.heightAnchor.constraint(equalToConstant: 150),
            modeSwitchButtonRight.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 75),
            modeSwitchButtonRight.centerYAnchor.constraint(equalTo: view.centerYAnchor,
                                                          constant: -UIScreen.main.bounds.height / 4),
            
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
