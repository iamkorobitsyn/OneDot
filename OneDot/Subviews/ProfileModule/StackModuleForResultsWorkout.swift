//
//  WorkoutResultModule.swift
//  OneDot
//
//  Created by Александр Коробицын on 16.12.2024.
//

import Foundation
import UIKit

class StackModuleForResultsWorkout: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.textColor = .myPaletteGray
        return label
    }()
    
    let titleIcon: UIImageView = {
        let view = UIImageView()
        view.disableAutoresizingMask()
        return view
    }()
    
    let resultLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.textColor = .myPaletteGray
        return label
    }()
    
    enum Mode {
        case time
        case calories
        case distance
        case climb
        case heartRate
        case pace
        case steps
        case cadence
    }
    
    enum Axis {
        case x
        case y
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    func activateMode(axis: Axis, mode: Mode, result: String) {
        
        setViews(axis: axis)
        setConstraints(axis: axis)
        
        resultLabel.text = result
        
        switch mode {
        case .time:
            titleLabel.text = axis == .x ? "Time" : "Total time"
            titleIcon.image = UIImage(named: axis == .x ? "AMTime20x20" : "AMTime25x25")
        case .calories:
            titleLabel.text = axis == .x ? "Calories" : "Total calories"
            titleIcon.image = UIImage(named: axis == .x ? "AMCalories20x20" : "AMCalories25x25")
        case .distance:
            titleLabel.text = axis == .x ? "Distance" : "Total distance"
            titleIcon.image = UIImage(named: axis == .x ? "AMDistance20x20" : "AMDistance25x25")
        case .climb:
            titleLabel.text = axis == .x ? "Climb" : "Total climb"
            titleIcon.image = UIImage(named: axis == .x ? "AMClimb20x20" : "AMClimb25x25")
        case .heartRate:
            titleLabel.text = "Heart rate"
            titleIcon.image = UIImage(named: axis == .x ? "AMHeartRate20x20" : "AMHeartRate25x25")
        case .pace:
            titleLabel.text = axis == .x ? "Pace" : "Average Pace"
            titleIcon.image = UIImage(named: axis == .x ? "AMPace20x20" : "AMPace25x25")
        case .steps:
            titleLabel.text = axis == .x ? "Steps" : "Total steps"
            titleIcon.image = UIImage(named: axis == .x ? "AMSteps20x20" : "AMSteps25x25")
        case .cadence:
            titleLabel.text = axis == .x ? "Cadence" : "Average cadence"
            titleIcon.image = UIImage(named: axis == .x ? "AMCadence20x20" : "AMCadence25x25")
        }
    }

    private func setViews(axis: Axis) {
        addSubview(titleLabel)
        addSubview(titleIcon)
        addSubview(resultLabel)
        
        switch axis {
            
        case .x:
            titleLabel.textAlignment = .left
            titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .light, width: .compressed)
            
            resultLabel.textAlignment = .right
            resultLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium, width: .compressed)
        case .y:
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .light, width: .compressed)
            
            resultLabel.textAlignment = .center
            resultLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium, width: .compressed)
        }
    }
    
    private func setConstraints(axis: Axis) {
        switch axis {
            
        case .x:
            NSLayoutConstraint.activate([
                titleIcon.widthAnchor.constraint(equalToConstant: 20),
                titleIcon.heightAnchor.constraint(equalToConstant: 20),
                titleIcon.leadingAnchor.constraint(equalTo: leadingAnchor),
                titleIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
                
                titleLabel.widthAnchor.constraint(equalToConstant: 60),
                titleLabel.leadingAnchor.constraint(equalTo: titleIcon.trailingAnchor, constant: 5),
                titleLabel.centerYAnchor.constraint(equalTo: titleIcon.centerYAnchor),
                
                resultLabel.widthAnchor.constraint(equalToConstant: 60),
                resultLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 5),
                resultLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
            ])
        case .y:
            NSLayoutConstraint.activate([
                titleIcon.widthAnchor.constraint(equalToConstant: 25),
                titleIcon.heightAnchor.constraint(equalToConstant: 25),
                titleIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
                titleIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
                
                titleLabel.widthAnchor.constraint(equalToConstant: 100),
                titleLabel.bottomAnchor.constraint(equalTo: titleIcon.topAnchor, constant: -20),
                titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                
                resultLabel.widthAnchor.constraint(equalToConstant: 100),
                resultLabel.topAnchor.constraint(equalTo: titleIcon.bottomAnchor, constant: 20),
                resultLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
