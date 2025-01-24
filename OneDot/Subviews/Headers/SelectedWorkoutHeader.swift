//
//  WorkoutResultHeader.swift
//  OneDot
//
//  Created by Александр Коробицын on 16.12.2024.
//

import Foundation
import UIKit

class SelectedWorkoutHeader: UIVisualEffectView {
    
    var healthKitData: HealthKitData?
    
    private let workoutIcon: UIImageView = {
        let view = UIImageView()
        view.disableAutoresizingMask()
        return view
    }()
    
    private let workoutNameLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.instance(color: .myPaletteGold, alignment: .left, font: .standartMax)
        label.numberOfLines = 2
        return label
    }()
    
    private let workoutDateLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.instance(color: .myPaletteGray, alignment: .right, font: .standartMax)
        label.numberOfLines = 2
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
            let distanceView = DescriptionModule()
            distanceView.activateMode(axis: .horizontalCompact, mode: .distanceDescription, text: stringRepresentation.totalDistance)
            let climbView = DescriptionModule()
            climbView.activateMode(axis: .horizontalCompact, mode: .climbDescription, text: stringRepresentation.climbing)
            let caloriesView = DescriptionModule()
            caloriesView.activateMode(axis: .horizontalCompact, mode: .caloriesDescription, text: stringRepresentation.calloriesBurned)
            let stepsView = DescriptionModule()
            stepsView.activateMode(axis: .horizontalCompact, mode: .stepsDescription, text: stringRepresentation.stepCount)
            
            [distanceView, climbView, caloriesView, stepsView].forEach({stackLDynamicMode.addArrangedSubview($0)})
            
            let timeView = DescriptionModule()
            timeView.activateMode(axis: .horizontalCompact, mode: .timeDescription, text: stringRepresentation.duration)
            let paceView = DescriptionModule()
            paceView.activateMode(axis: .horizontalCompact, mode: .paceDescription, text: stringRepresentation.pace)
            let heartRateView = DescriptionModule()
            heartRateView.activateMode(axis: .horizontalCompact, mode: .heartRateDescription, text: stringRepresentation.heartRate)
            let cadenceView = DescriptionModule()
            cadenceView.activateMode(axis: .horizontalCompact, mode: .cadenceDescription, text: stringRepresentation.cadence)
            
            [timeView, paceView, heartRateView, cadenceView].forEach({stackRDynamicMode.addArrangedSubview($0)})
            
            setConstraints(mode: mode)
            ShapeManager.shared.drawResultSeparator(dual: false, shape: separator, view: contentView)
            
        case .staticWorkout:
            let timeView = DescriptionModule()
            timeView.activateMode(axis: .vertical, mode: .timeDescription, text: stringRepresentation.duration)
            let caloriesView = DescriptionModule()
            caloriesView.activateMode(axis: .vertical, mode: .caloriesDescription, text: stringRepresentation.calloriesBurned)
            let heartRateView = DescriptionModule()
            heartRateView.activateMode(axis: .vertical, mode: .heartRateDescription, text: stringRepresentation.heartRate)
            
            [timeView, caloriesView, heartRateView].forEach({stackStaticMode.addArrangedSubview($0)})
            
            setConstraints(mode: mode)
            ShapeManager.shared.drawResultSeparator(dual: true, shape: separator, view: contentView)
        }
    }
    
    private func setConstraints(mode: Mode) {
        
        NSLayoutConstraint.activate([
            
            workoutIcon.widthAnchor.constraint(equalToConstant: 25),
            workoutIcon.heightAnchor.constraint(equalToConstant: 25),
            workoutIcon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            workoutIcon.topAnchor.constraint(equalTo: topAnchor, constant: 23.5),
            
            workoutNameLabel.widthAnchor.constraint(equalToConstant: 165),
            workoutNameLabel.heightAnchor.constraint(equalToConstant: 50),
            workoutNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -.barWidth / 4),
            workoutNameLabel.centerYAnchor.constraint(equalTo: workoutIcon.centerYAnchor),
            
            workoutDateLabel.widthAnchor.constraint(equalToConstant: 165),
            workoutDateLabel.heightAnchor.constraint(equalToConstant: 50),
            workoutDateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: .barWidth / 4),
            workoutDateLabel.centerYAnchor.constraint(equalTo: workoutIcon.centerYAnchor)
        ])
        
        switch mode {

        case .outdoorDynamicWorkout, .indoorDynamicWorkout:
            NSLayoutConstraint.activate([
                stackLDynamicMode.widthAnchor.constraint(equalToConstant: 165),
                stackLDynamicMode.heightAnchor.constraint(equalToConstant: 120),
                stackLDynamicMode.centerXAnchor.constraint(equalTo: workoutNameLabel.centerXAnchor),
                stackLDynamicMode.topAnchor.constraint(equalTo: workoutNameLabel.bottomAnchor, constant: 10),
                
                stackRDynamicMode.widthAnchor.constraint(equalToConstant: 165),
                stackRDynamicMode.heightAnchor.constraint(equalToConstant: 120),
                stackRDynamicMode.centerXAnchor.constraint(equalTo: workoutDateLabel.centerXAnchor),
                stackRDynamicMode.topAnchor.constraint(equalTo: workoutDateLabel.bottomAnchor, constant: 10)
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
