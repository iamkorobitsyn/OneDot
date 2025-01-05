//
//  WorkoutResultHeader.swift
//  OneDot
//
//  Created by Александр Коробицын on 16.12.2024.
//

import Foundation
import UIKit

class HeaderViewForSelectedWorkout: UIView {
    
    var healthKitData: HealthKitData?
    
    private let workoutNameLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.instance(color: .myPaletteGold, alignment: .left, font: .boldCompLarge)

        return label
    }()
    
    private let workoutDateLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.instance(color: .myPaletteGold, alignment: .left, font: .boldCompLarge)
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(workoutNameLabel)
        addSubview(workoutDateLabel)
        
        addSubview(leadingStack)
        addSubview(trailingStack)
    }

    
    func activateMode(mode: Mode) {
        
        
        leadingStack.arrangedSubviews.forEach({$0.removeFromSuperview()})
        trailingStack.arrangedSubviews.forEach({$0.removeFromSuperview()})
        leadingStack.constraints.forEach({$0.isActive = false})
        trailingStack.constraints.forEach({$0.isActive = false})
        
        guard let healthKitData else {return}
        let stringRepresentation = healthKitData.stringRepresentation()

        workoutNameLabel.text = "\(stringRepresentation.workoutType) на улице"
        workoutDateLabel.text = stringRepresentation.startDate
        
        switch mode {
        case .dynamicWorkout:
            let distanceView = StackModuleForResultsWorkout()
            distanceView.activateMode(axis: .x, mode: .distance, result: stringRepresentation.totalDistance)
            let climbView = StackModuleForResultsWorkout()
            climbView.activateMode(axis: .x, mode: .climb, result: stringRepresentation.climbing)
            let caloriesView = StackModuleForResultsWorkout()
            caloriesView.activateMode(axis: .x, mode: .calories, result: stringRepresentation.calloriesBurned)
            let stepsView = StackModuleForResultsWorkout()
            stepsView.activateMode(axis: .x, mode: .steps, result: stringRepresentation.stepCount)
            
            [distanceView, climbView, caloriesView, stepsView].forEach({leadingStack.addArrangedSubview($0)})
            
            let timeView = StackModuleForResultsWorkout()
            timeView.activateMode(axis: .x, mode: .time, result: stringRepresentation.duration)
            let paceView = StackModuleForResultsWorkout()
            paceView.activateMode(axis: .x, mode: .pace, result: stringRepresentation.pace)
            let heartRateView = StackModuleForResultsWorkout()
            heartRateView.activateMode(axis: .x, mode: .heartRate, result: stringRepresentation.heartRate)
            let cadenceView = StackModuleForResultsWorkout()
            cadenceView.activateMode(axis: .x, mode: .cadence, result: stringRepresentation.cadence)
            
            [timeView, paceView, heartRateView, cadenceView].forEach({trailingStack.addArrangedSubview($0)})
            
            setConstraints(mode: mode)
            
        case .staticWorkout:
            let timeView = StackModuleForResultsWorkout()
            timeView.activateMode(axis: .x, mode: .time, result: stringRepresentation.duration)
            let heartRateView = StackModuleForResultsWorkout()
            heartRateView.activateMode(axis: .x, mode: .heartRate, result: stringRepresentation.heartRate)
            
            [timeView, heartRateView].forEach({leadingStack.addArrangedSubview($0)})
            
            let caloriesView = StackModuleForResultsWorkout()
            caloriesView.activateMode(axis: .x, mode: .calories, result: stringRepresentation.calloriesBurned)
            
            [caloriesView].forEach({trailingStack.addArrangedSubview($0)})
            
            setConstraints(mode: mode)
            
        }
    }
    
    private func setConstraints(mode: Mode) {
        
        NSLayoutConstraint.activate([
            
            workoutNameLabel.leadingAnchor.constraint(equalTo: leadingStack.leadingAnchor),
            workoutNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            
            workoutDateLabel.trailingAnchor.constraint(equalTo: trailingStack.trailingAnchor),
            workoutDateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 100)
            
            
        ])
        
        switch mode {

        case .dynamicWorkout:
            NSLayoutConstraint.activate([
                leadingStack.widthAnchor.constraint(equalToConstant: 150),
                leadingStack.heightAnchor.constraint(equalToConstant: 120),
                leadingStack.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -95),
                leadingStack.topAnchor.constraint(equalTo: centerYAnchor, constant: 0),
                
                trailingStack.widthAnchor.constraint(equalToConstant: 150),
                trailingStack.heightAnchor.constraint(equalToConstant: 120),
                trailingStack.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 90),
                trailingStack.topAnchor.constraint(equalTo: centerYAnchor, constant: 0)
            ])
        case .staticWorkout:
            NSLayoutConstraint.activate([
                leadingStack.widthAnchor.constraint(equalToConstant: 150),
                leadingStack.heightAnchor.constraint(equalToConstant: 60),
                leadingStack.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -95),
                leadingStack.topAnchor.constraint(equalTo: centerYAnchor, constant: 0),
                
                trailingStack.widthAnchor.constraint(equalToConstant: 150),
                trailingStack.heightAnchor.constraint(equalToConstant: 30),
                trailingStack.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 90),
                trailingStack.topAnchor.constraint(equalTo: centerYAnchor, constant: 0)
            ])
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
