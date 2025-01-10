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
        case horizontal
        case vertical
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    func activateMode(axis: Axis, mode: Mode, text: String) {
        
        setViews(axis: axis)
        setConstraints(axis: axis)
        
        resultLabel.text = text
        
        switch mode {
        case .time:
            titleLabel.text = "Time"
            titleIcon.image = UIImage(named: axis == .vertical ? "AMTime25x25" : "AMTime20x20")
        case .calories:
            titleLabel.text = "Calories"
            titleIcon.image = UIImage(named: axis == .vertical ? "AMCalories20x20" : "AMCalories25x25")
        case .distance:
            titleLabel.text = "Distance"
            titleIcon.image = UIImage(named: axis == .vertical ? "AMDistance25x25" : "AMDistance20x20")
        case .climb:
            titleLabel.text = "Climb"
            titleIcon.image = UIImage(named: axis == .vertical ? "AMClimb25x25" : "AMClimb20x20")
        case .heartRate:
            titleLabel.text = "Heart rate"
            titleIcon.image = UIImage(named: axis == .vertical ? "AMHeartRate25x25" : "AMHeartRate20x20")
        case .pace:
            titleLabel.text = axis == .vertical ? "Average Pace" : "Pace"
            titleIcon.image = UIImage(named: axis == .vertical ? "AMPace25x25" : "AMPace20x20")
        case .steps:
            titleLabel.text = "Steps"
            titleIcon.image = UIImage(named: axis == .vertical ? "AMSteps25x25" : "AMSteps20x20")
        case .cadence:
            titleLabel.text = axis == .vertical ? "Average cadence" : "Cadence"
            titleIcon.image = UIImage(named: axis == .vertical ? "AMCadence25x25" : "AMCadence20x20")
        }
    }

    private func setViews(axis: Axis) {
        addSubview(titleLabel)
        addSubview(titleIcon)
        addSubview(resultLabel)
        
        switch axis {
            
        case .horizontal:
            titleLabel.textAlignment = .left
            titleLabel.instance(color: .myPaletteGray, alignment: .left, font: .condensedMin)
            
            resultLabel.textAlignment = .right
            resultLabel.instance(color: .myPaletteGray, alignment: .right, font: .standartMid)
        case .vertical:
            titleLabel.textAlignment = .center
            titleLabel.instance(color: .myPaletteGray, alignment: .center, font: .condensedMid)
            
            resultLabel.textAlignment = .center
            resultLabel.instance(color: .myPaletteGray, alignment: .center, font: .standartMid)
        }
    }
    
    private func setConstraints(axis: Axis) {
        switch axis {
            
        case .horizontal:
            NSLayoutConstraint.activate([
                titleIcon.widthAnchor.constraint(equalToConstant: 20),
                titleIcon.heightAnchor.constraint(equalToConstant: 20),
                titleIcon.leadingAnchor.constraint(equalTo: leadingAnchor),
                titleIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
                
                titleLabel.widthAnchor.constraint(equalToConstant: 65),
                titleLabel.leadingAnchor.constraint(equalTo: titleIcon.trailingAnchor, constant: 3),
                titleLabel.centerYAnchor.constraint(equalTo: titleIcon.centerYAnchor),
                
                resultLabel.widthAnchor.constraint(equalToConstant: 75),
                resultLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 2),
                resultLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
            ])
        case .vertical:
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
