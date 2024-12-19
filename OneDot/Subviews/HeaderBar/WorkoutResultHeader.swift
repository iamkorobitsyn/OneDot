//
//  WorkoutResultHeader.swift
//  OneDot
//
//  Created by Александр Коробицын on 16.12.2024.
//

import Foundation
import UIKit

class WorkoutResultHeader: UIVisualEffectView {
    
    var healthKitData: HealthKitData?
    
    private let workoutNameLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.instance(color: .myPaletteGold, alignment: .left, font: .boldCompLarge)
        label.text = "RUNNING"
        return label
    }()
    
    private let workoutDateLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.instance(color: .myPaletteGold, alignment: .left, font: .boldCompLarge)
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
        
        guard let healthKitData else {return}
        let stringRepresentation = healthKitData.stringRepresentation()
        
        
        effect = UIBlurEffect(style: .light)
        clipsToBounds = true
        layer.customBorder(bord: true, corner: .min)
        
        contentView.addSubview(workoutNameLabel)
        contentView.addSubview(workoutDateLabel)
        
        contentView.addSubview(leadingStack)
        contentView.addSubview(trailingStack)
        
        switch mode {
        case .dynamicWorkout:
            let distanceView = WorkoutResultModule()
            distanceView.activateMode(axis: .x, mode: .distance, result: stringRepresentation.totalDistance)
            let climbView = WorkoutResultModule()
            climbView.activateMode(axis: .x, mode: .climb, result: stringRepresentation.climb)
            let caloriesView = WorkoutResultModule()
            caloriesView.activateMode(axis: .x, mode: .calories, result: stringRepresentation.calloriesBurned)
            let stepsView = WorkoutResultModule()
            stepsView.activateMode(axis: .x, mode: .steps, result: "!")
            
            [distanceView, climbView, caloriesView, stepsView].forEach({leadingStack.addArrangedSubview($0)})
            
            let timeView = WorkoutResultModule()
            timeView.activateMode(axis: .x, mode: .time, result: stringRepresentation.duration)
            let paceView = WorkoutResultModule()
            paceView.activateMode(axis: .x, mode: .pace, result: "!")
            let heartRateView = WorkoutResultModule()
            heartRateView.activateMode(axis: .x, mode: .heartRate, result: stringRepresentation.heartRate)
            let cadenceView = WorkoutResultModule()
            cadenceView.activateMode(axis: .x, mode: .cadence, result: "!")
            
            [timeView, paceView, heartRateView, cadenceView].forEach({trailingStack.addArrangedSubview($0)})
            
            setConstraints(mode: mode)
            
        case .staticWorkout:
            let timeView = WorkoutResultModule()
            timeView.activateMode(axis: .x, mode: .time, result: stringRepresentation.duration)
            let heartRateView = WorkoutResultModule()
            heartRateView.activateMode(axis: .x, mode: .heartRate, result: stringRepresentation.heartRate)
            
            [timeView, heartRateView].forEach({leadingStack.addArrangedSubview($0)})
            
            let caloriesView = WorkoutResultModule()
            caloriesView.activateMode(axis: .x, mode: .calories, result: stringRepresentation.calloriesBurned)
            
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
            
            workoutNameLabel.leadingAnchor.constraint(equalTo: leadingStack.leadingAnchor),
            workoutNameLabel.bottomAnchor.constraint(equalTo: leadingStack.topAnchor, constant: -20),
            
            workoutDateLabel.bottomAnchor.constraint(equalTo: workoutNameLabel.bottomAnchor),
            workoutDateLabel.trailingAnchor.constraint(equalTo: trailingStack.trailingAnchor)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
