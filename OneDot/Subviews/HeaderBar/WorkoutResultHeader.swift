//
//  WorkoutResultHeader.swift
//  OneDot
//
//  Created by Александр Коробицын on 16.12.2024.
//

import Foundation
import UIKit

class WorkoutResultHeader: UIVisualEffectView {
    
    private let workoutIcon: UIImageView = {
        let view = UIImageView()
        view.disableAutoresizingMask()
        view.image = UIImage(named: "AORunning")
        return view
    }()
    
    private let workoutDateLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.textAlignment = .right
        label.textColor = .myPaletteGold
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold, width: .compressed)
        label.text = "ВТ. 17 ДЕК."
        return label
    }()

    let leadingStack: UIStackView = {
        let stackView = UIStackView()
        stackView.disableAutoresizingMask()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()
    
    let trailingStack: UIStackView = {
        let stackView = UIStackView()
        stackView.disableAutoresizingMask()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()
    
    enum Mode {
        case dynamicWorkout
        case staticWorkout
    }
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
    }

    
    func activateMode(mode: Mode) {
        effect = UIBlurEffect(style: .light)
        clipsToBounds = true
        layer.customBorder(bord: true, corner: .min)
        
        contentView.addSubview(workoutIcon)
        contentView.addSubview(workoutDateLabel)
        
        contentView.addSubview(leadingStack)
        contentView.addSubview(trailingStack)
        
        
        
        switch mode {
        case .dynamicWorkout:
            let distanceView = WorkoutResultModule()
            distanceView.activateMode(axis: .x, mode: .distance, result: "10.02 km")
            let climbView = WorkoutResultModule()
            climbView.activateMode(axis: .x, mode: .climb, result: "123 m")
            let caloriesView = WorkoutResultModule()
            caloriesView.activateMode(axis: .x, mode: .calories, result: "345 Kcal")
            let stepsView = WorkoutResultModule()
            stepsView.activateMode(axis: .x, mode: .steps, result: "3458")
            
            [distanceView, climbView, caloriesView, stepsView].forEach({leadingStack.addArrangedSubview($0)})
            
            let timeView = WorkoutResultModule()
            timeView.activateMode(axis: .x, mode: .time, result: "59:04:34")
            let paceView = WorkoutResultModule()
            paceView.activateMode(axis: .x, mode: .pace, result: "5:49 / km")
            let heartRateView = WorkoutResultModule()
            heartRateView.activateMode(axis: .x, mode: .heartRate, result: "147")
            let cadenceView = WorkoutResultModule()
            cadenceView.activateMode(axis: .x, mode: .cadence, result: "162")
            
            [timeView, paceView, heartRateView, cadenceView].forEach({trailingStack.addArrangedSubview($0)})
            
            setConstraints(mode: mode)
            
        case .staticWorkout:
            let timeView = WorkoutResultModule()
            timeView.activateMode(axis: .x, mode: .time, result: "59:04:34")
            let heartRateView = WorkoutResultModule()
            heartRateView.activateMode(axis: .x, mode: .heartRate, result: "147")
            
            [timeView, heartRateView].forEach({leadingStack.addArrangedSubview($0)})
            
            let caloriesView = WorkoutResultModule()
            caloriesView.activateMode(axis: .x, mode: .calories, result: "345 Kcal")
            
            [caloriesView].forEach({trailingStack.addArrangedSubview($0)})
            
            setConstraints(mode: mode)
        }
    }
    
    private func setConstraints(mode: Mode) {
        switch mode {
            
        case .dynamicWorkout:
            NSLayoutConstraint.activate([
                leadingStack.widthAnchor.constraint(equalToConstant: 150),
                leadingStack.heightAnchor.constraint(equalToConstant: 120),
                leadingStack.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -95),
                leadingStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
                
                trailingStack.widthAnchor.constraint(equalToConstant: 150),
                trailingStack.heightAnchor.constraint(equalToConstant: 120),
                trailingStack.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 90),
                trailingStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
            ])
        case .staticWorkout:
            NSLayoutConstraint.activate([
                leadingStack.widthAnchor.constraint(equalToConstant: 150),
                leadingStack.heightAnchor.constraint(equalToConstant: 60),
                leadingStack.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -95),
                leadingStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
                
                trailingStack.widthAnchor.constraint(equalToConstant: 150),
                trailingStack.heightAnchor.constraint(equalToConstant: 30),
                trailingStack.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 90),
                trailingStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -70)
            ])
        }
        
        NSLayoutConstraint.activate([
            workoutIcon.widthAnchor.constraint(equalToConstant: .iconSide),
            workoutIcon.heightAnchor.constraint(equalToConstant: .iconSide),
            workoutIcon.leadingAnchor.constraint(equalTo: leadingStack.leadingAnchor, constant: -10),
            workoutIcon.bottomAnchor.constraint(equalTo: leadingStack.topAnchor, constant: -10),
            
            workoutDateLabel.topAnchor.constraint(equalTo: workoutIcon.topAnchor),
            workoutDateLabel.trailingAnchor.constraint(equalTo: trailingStack.trailingAnchor)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
