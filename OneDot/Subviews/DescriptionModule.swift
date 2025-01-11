//
//  StackModuleForResultsWorkout 2.swift
//  OneDot
//
//  Created by Александр Коробицын on 11.01.2025.
//


import Foundation
import UIKit

class DescriptionModule: UIView {
    
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
        case timeDescription
        case caloriesDescription
        case distanceDescription
        case climbDescription
        case heartRateDescription
        case paceDescription
        case stepsDescription
        case cadenceDescription
        case distanceTracking
        case paceTracking
        case caloriesTracking
        case heartRateTracking
    }
    
    enum Axis {
        case horizontal
        case vertical
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    func activateMode(axis: Axis, mode: Mode, text: String) {
        
        addSubview(titleLabel)
        addSubview(titleIcon)
        addSubview(resultLabel)
        
        resultLabel.text = text
        
        
        switch axis {
            
        case .horizontal:
            titleLabel.textAlignment = .left
            titleLabel.instance(color: .myPaletteGray, alignment: .left, font: .condensedMin)
            
            resultLabel.textAlignment = .right
            resultLabel.instance(color: .myPaletteGray, alignment: .right, font: .standartMid)
        case .vertical:
            titleLabel.textAlignment = .center
            resultLabel.textAlignment = .center
            switch mode {
            case .distanceTracking, .paceTracking, .caloriesTracking, .heartRateTracking:
                titleLabel.instance(color: .myPaletteGray, alignment: .center, font: .condensedMax)
                resultLabel.instance(color: .myPaletteGray, alignment: .center, font: .boldExtra)
            default:
                titleLabel.instance(color: .myPaletteGray, alignment: .center, font: .condensedMid)
                resultLabel.instance(color: .myPaletteGray, alignment: .center, font: .standartMid)
            }
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
            titleLabel.text = "Distance"
            titleIcon.image = UIImage(named: "AMDistance25x25")
        case .paceTracking:
            titleLabel.text = "Pace"
            titleIcon.image = UIImage(named: "AMPace25x25")
        case .caloriesTracking:
            titleLabel.text = "Calories"
            titleIcon.image = UIImage(named: "AMCalories25x25")
        case .heartRateTracking:
            titleLabel.text = "Heart rate"
            titleIcon.image = UIImage(named: "AMHeartRate25x25")
        }
        
        setConstraints(axis: axis)
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
