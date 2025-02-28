//
//  StackModuleForResultsWorkout 2.swift
//  OneDot
//
//  Created by Александр Коробицын on 11.01.2025.
//


import Foundation
import UIKit

class ValueBlockView: UIView {
    
    let titleLabel: UILabel = UILabel()
    let resultLabel: UILabel = UILabel()
    let titleIcon: UIImageView = UIImageView()

    enum Mode {
        case timeDescription
        case caloriesDescription
        case distanceDescription
        case climbDescription
        case heartRateDescription
        case paceDescription
        case stepsDescription
        case cadenceDescription
        case distanceTracking
        case caloriesTracking
    }
    
    enum Axis {
        case horizontalCompact
        case horizontalExpanded
        case vertical
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [titleLabel, resultLabel, titleIcon].forEach( {addSubview($0)} )
        [titleLabel, resultLabel, titleIcon].forEach( {$0.disableAutoresizingMask()} )
    }
    
    func activateMode(axis: Axis, mode: Mode, text: String) {
        resultLabel.text = text

        switch axis {
            
        case .horizontalCompact:
            
            titleLabel.instance(color: .myPaletteGray, alignment: .left, font: .condensedMin)
            resultLabel.instance(color: .myPaletteGray, alignment: .right, font: .standartMid)
            
        case .horizontalExpanded:
            
            resultLabel.instance(color: .white, alignment: .center, font: .standartExtra)
            titleLabel.instance(color: .white, alignment: .center, font: .condensedMid)
            
        case .vertical:
            
            titleLabel.instance(color: .myPaletteGray, alignment: .center, font: .condensedMid)
            resultLabel.instance(color: .myPaletteGray, alignment: .center, font: .standartMid)
        }
        
        
        switch mode {
        case .timeDescription:
            titleLabel.text = "Time"
            titleIcon.image = UIImage(named: axis == .vertical ? "AMTime25x25" : "AMTime20x20")
        case .caloriesDescription:
            titleLabel.text = "Calories"
            titleIcon.image = UIImage(named: axis == .vertical ? "AMCalories25x25" : "AMCalories20x20")
        case .distanceDescription:
            titleLabel.text = "Distance"
            titleIcon.image = UIImage(named: axis == .vertical ? "AMDistance25x25" : "AMDistance20x20")
        case .climbDescription:
            titleLabel.text = "Climb"
            titleIcon.image = UIImage(named: axis == .vertical ? "AMClimb25x25" : "AMClimb20x20")
        case .heartRateDescription:
            titleLabel.text = "Heart rate"
            titleIcon.image = UIImage(named: axis == .vertical ? "AMHeartRate25x25" : "AMHeartRate20x20")
        case .paceDescription:
            titleLabel.text = axis == .vertical ? "Average Pace" : "Pace"
            titleIcon.image = UIImage(named: axis == .vertical ? "AMPace25x25" : "AMPace20x20")
        case .stepsDescription:
            titleLabel.text = "Steps"
            titleIcon.image = UIImage(named: axis == .vertical ? "AMSteps25x25" : "AMSteps20x20")
        case .cadenceDescription:
            titleLabel.text = axis == .vertical ? "Average cadence" : "Cadence"
            titleIcon.image = UIImage(named: axis == .vertical ? "AMCadence25x25" : "AMCadence20x20")
        case .distanceTracking:
            titleLabel.text = "km"
            titleIcon.image = UIImage(named: "AMDistanceTracking25x25")
        case .caloriesTracking:
            titleLabel.text = "cal"
            titleIcon.image = UIImage(named: "AMCaloriesTracking25x25")
        }
        
        setConstraints(axis: axis)
    }
    
    private func setConstraints(axis: Axis) {
        switch axis {
            
        case .horizontalCompact:
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
        case .horizontalExpanded:
            NSLayoutConstraint.activate([
                titleIcon.widthAnchor.constraint(equalToConstant: 25),
                titleIcon.heightAnchor.constraint(equalToConstant: 25),
                titleIcon.leadingAnchor.constraint(equalTo: leadingAnchor),
                titleIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
                
                resultLabel.widthAnchor.constraint(equalToConstant: 150),
                resultLabel.leadingAnchor.constraint(equalTo: titleIcon.trailingAnchor),
                resultLabel.bottomAnchor.constraint(equalTo: bottomAnchor),

                titleLabel.widthAnchor.constraint(equalToConstant: 25),
                titleLabel.leadingAnchor.constraint(equalTo: resultLabel.trailingAnchor),
                titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
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
                
                resultLabel.widthAnchor.constraint(equalToConstant: 120),
                resultLabel.topAnchor.constraint(equalTo: titleIcon.bottomAnchor, constant: 20),
                resultLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
