//
//  WorkoutResultHeader.swift
//  OneDot
//
//  Created by Александр Коробицын on 16.12.2024.
//

import Foundation
import UIKit

class HeaderViewForSelectedWorkout: UIVisualEffectView {
    
    var healthKitData: HealthKitData?
    
    private let workoutIcon: UIImageView = {
        let view = UIImageView()
        view.disableAutoresizingMask()
        return view
    }()
    
    private let workoutNameLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.instance(color: .myPaletteGold, alignment: .left, font: .boldCompExtraLarge)
        return label
    }()
    
    private let workoutDateLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.instance(color: .myPaletteGray, alignment: .right, font: .boldCompExtraLarge)
        return label
    }()

    let stackLDynamicMode: UIStackView = {
        let stackView = UIStackView()
        stackView.disableAutoresizingMask()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()
    
    let stackRDynamicMode: UIStackView = {
        let stackView = UIStackView()
        stackView.disableAutoresizingMask()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()
    
    let stackStaticMode: UIStackView = {
        let stackView = UIStackView()
        stackView.disableAutoresizingMask()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()
    
    private let separator: CAShapeLayer = CAShapeLayer()
    
    enum Mode {
        case outdoorDynamicWorkout
        case indoorDynamicWorkout
        case staticWorkout
    }
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        self.effect = UIBlurEffect(style: .extraLight)
        clipsToBounds = true
        layer.instance(border: true, corner: .max)
        contentView.addSubview(workoutIcon)
        contentView.addSubview(workoutNameLabel)
        contentView.addSubview(workoutDateLabel)
        
        contentView.addSubview(stackLDynamicMode)
        contentView.addSubview(stackRDynamicMode)
        contentView.addSubview(stackStaticMode)
        
    }
    
    func activateMode(mode: Mode) {
      
        
        guard let healthKitData else {return}
        let stringRepresentation = healthKitData.stringRepresentation()

        workoutNameLabel.text = stringRepresentation.workoutType.uppercased()
        workoutDateLabel.text = stringRepresentation.startDate.uppercased()
        
        switch mode {
        case .indoorDynamicWorkout, .staticWorkout:
            workoutIcon.image = UIImage(named: "AMIndoorLocGold25x25")
        case .outdoorDynamicWorkout:
            workoutIcon.image = UIImage(named: "AMOutdoorLocGold25x25")
            
        }
        
        switch mode {
        case .outdoorDynamicWorkout, .indoorDynamicWorkout:
            let distanceView = StackModuleForResultsWorkout()
            distanceView.activateMode(axis: .horizontal, mode: .distance, text: stringRepresentation.totalDistance)
            let climbView = StackModuleForResultsWorkout()
            climbView.activateMode(axis: .horizontal, mode: .climb, text: stringRepresentation.climbing)
            let caloriesView = StackModuleForResultsWorkout()
            caloriesView.activateMode(axis: .horizontal, mode: .calories, text: stringRepresentation.calloriesBurned)
            let stepsView = StackModuleForResultsWorkout()
            stepsView.activateMode(axis: .horizontal, mode: .steps, text: stringRepresentation.stepCount)
            
            [distanceView, climbView, caloriesView, stepsView].forEach({stackLDynamicMode.addArrangedSubview($0)})
            
            let timeView = StackModuleForResultsWorkout()
            timeView.activateMode(axis: .horizontal, mode: .time, text: stringRepresentation.duration)
            let paceView = StackModuleForResultsWorkout()
            paceView.activateMode(axis: .horizontal, mode: .pace, text: stringRepresentation.pace)
            let heartRateView = StackModuleForResultsWorkout()
            heartRateView.activateMode(axis: .horizontal, mode: .heartRate, text: stringRepresentation.heartRate)
            let cadenceView = StackModuleForResultsWorkout()
            cadenceView.activateMode(axis: .horizontal, mode: .cadence, text: stringRepresentation.cadence)
            
            [timeView, paceView, heartRateView, cadenceView].forEach({stackRDynamicMode.addArrangedSubview($0)})
            
            setConstraints(mode: mode)
            ShapeManager.shared.drawResultSeparator(dual: false, shape: separator, view: contentView)
            
        case .staticWorkout:
            let timeView = StackModuleForResultsWorkout()
            timeView.activateMode(axis: .vertical, mode: .time, text: stringRepresentation.duration)
            let caloriesView = StackModuleForResultsWorkout()
            caloriesView.activateMode(axis: .vertical, mode: .calories, text: stringRepresentation.calloriesBurned)
            let heartRateView = StackModuleForResultsWorkout()
            heartRateView.activateMode(axis: .vertical, mode: .heartRate, text: stringRepresentation.heartRate)
            
            [timeView, caloriesView, heartRateView].forEach({stackStaticMode.addArrangedSubview($0)})
            
            setConstraints(mode: mode)
            ShapeManager.shared.drawResultSeparator(dual: true, shape: separator, view: contentView)
        }
    }
    
    private func setConstraints(mode: Mode) {
        
        NSLayoutConstraint.activate([
            
            workoutNameLabel.widthAnchor.constraint(equalToConstant: 150),
            workoutNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            workoutNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 25),
            
            workoutDateLabel.widthAnchor.constraint(equalToConstant: 150),
            workoutDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            workoutDateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 25),
            
            workoutIcon.widthAnchor.constraint(equalToConstant: 25),
            workoutIcon.heightAnchor.constraint(equalToConstant: 25),
            workoutIcon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            workoutIcon.topAnchor.constraint(equalTo: topAnchor, constant: 23.5)
        ])
        
        switch mode {

        case .outdoorDynamicWorkout, .indoorDynamicWorkout:
            NSLayoutConstraint.activate([
                stackLDynamicMode.widthAnchor.constraint(equalToConstant: 150),
                stackLDynamicMode.heightAnchor.constraint(equalToConstant: 120),
                stackLDynamicMode.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
                stackLDynamicMode.topAnchor.constraint(equalTo: workoutNameLabel.bottomAnchor, constant: 20),
                
                stackRDynamicMode.widthAnchor.constraint(equalToConstant: 150),
                stackRDynamicMode.heightAnchor.constraint(equalToConstant: 120),
                stackRDynamicMode.trailingAnchor.constraint(equalTo: workoutDateLabel.trailingAnchor),
                stackRDynamicMode.topAnchor.constraint(equalTo: workoutDateLabel.bottomAnchor, constant: 20)
            ])
        case .staticWorkout:
            NSLayoutConstraint.activate([
                stackStaticMode.widthAnchor.constraint(equalToConstant: .barWidth - 100),
                stackStaticMode.heightAnchor.constraint(equalToConstant: 120),
                stackStaticMode.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                stackStaticMode.topAnchor.constraint(equalTo: workoutNameLabel.bottomAnchor, constant: 20)
            ])
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
