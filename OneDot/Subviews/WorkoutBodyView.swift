//
//  WorkoutView.swift
//  OneDot
//
//  Created by Александр Коробицын on 11.01.2025.
//

import Foundation
import UIKit

class WorkoutBodyView: UIView {
    
    enum Mode {
        case prepare
        case countdown
        case workout
        case stopWatch
        case pause
        case completion
    }
    
    private let focusLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.numberOfLines = 5
        return label
    }()
    
    private let topDescriptionModule: DescriptionModuleView = {
        let module = DescriptionModuleView()
        module.disableAutoresizingMask()
        return module
    }()
    
    private let centerDescriptionModule: DescriptionModuleView = {
        let module = DescriptionModuleView()
        module.disableAutoresizingMask()
        return module
    }()
    
    private let bottomDescriptionModule: DescriptionModuleView = {
        let view = DescriptionModuleView()
        view.disableAutoresizingMask()
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setConstraints()
    }
    
    func activateMode(mode: Mode) {
        
        clearVisibleViews()
        
        switch mode {
        case .prepare:
            focusLabel.isHidden = false
            updateFocusLabel(text: "Get ready to start and click on the indicator, good luck in training and competitions",
                             countdownSize: false)
        case .pause:
            focusLabel.isHidden = false
            updateFocusLabel(text: "PAUSE", countdownSize: false)
        case .countdown:
            focusLabel.isHidden = false
        case .workout:
            topDescriptionModule.isHidden = false
            centerDescriptionModule.isHidden = false
            bottomDescriptionModule.isHidden = false
        case .completion:
            focusLabel.isHidden = false
            updateFocusLabel(text: "Finish the workout?", countdownSize: false)
        default:
            break
        }
    }
    
    func updateFocusLabel(text: String, countdownSize: Bool) {

        focusLabel.text = text
        if countdownSize {
            focusLabel.instance(color: .white, alignment: .center, font: .timerWatch)
        } else {
            focusLabel.instance(color: .white, alignment: .center, font: .standartMid)
        }
    }
    
    func updateTrackingState(isGeoTracking: Bool, duration: TimeInterval, distance: Double, calories: Double) {
        
        if isGeoTracking {
            
            let kilometers = distance / 1000
            let roundedKilometers = String(format: "%.2f", kilometers)
            topDescriptionModule.activateMode(axis: .horizontalExpanded, mode: .distanceTracking,
                                              text: "\(roundedKilometers) km")
            

            if Int(duration) == 0 {
                topDescriptionModule.activateMode(axis: .horizontalExpanded, mode: .distanceTracking, text: "-")
                centerDescriptionModule.activateMode(axis: .horizontalExpanded, mode: .paceTracking, text: "-")
                bottomDescriptionModule.activateMode(axis: .horizontalExpanded, mode: .caloriesTracking, text: "-")
            } else if Int(duration) % 10 == 0, distance != 0 {
                let timePerMetre = duration / distance
                let timePerKilometer = timePerMetre * 1000
                let minutes = Int(timePerKilometer / 60)
                let seconds = Int(timePerKilometer) % 60
                let stringDuration = String(format: "%02d:%02d", minutes, seconds)
                centerDescriptionModule.activateMode(axis: .horizontalExpanded, mode: .paceTracking, text: "\(stringDuration)")
            } else if Int(duration) % 5 == 0 {
                bottomDescriptionModule.activateMode(axis: .horizontalExpanded, mode: .caloriesTracking, text: "\(Int(calories))")
            }
             
        } else {
            if Int(duration) == 0 {
                centerDescriptionModule.activateMode(axis: .horizontalExpanded, mode: .caloriesTracking, text: "-")
            } else if Int(duration) % 5 == 0 {
                centerDescriptionModule.activateMode(axis: .horizontalExpanded, mode: .caloriesTracking, text: "\(Int(calories))")
            }
        }
    }
    
    private func clearVisibleViews() {
        topDescriptionModule.isHidden = true
        centerDescriptionModule.isHidden = true
        bottomDescriptionModule.isHidden = true
        focusLabel.isHidden = true
    }
    
    private func setViews() {
        
        addSubview(topDescriptionModule)
        addSubview(centerDescriptionModule)
        addSubview(bottomDescriptionModule)
        addSubview(focusLabel)

    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            focusLabel.widthAnchor.constraint(equalToConstant: .barWidth - 100),
            focusLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            focusLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 50),
            
            topDescriptionModule.widthAnchor.constraint(equalToConstant: 300),
            topDescriptionModule.heightAnchor.constraint(equalToConstant: 100),
            topDescriptionModule.bottomAnchor.constraint(equalTo: focusLabel.topAnchor),
            topDescriptionModule.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            centerDescriptionModule.widthAnchor.constraint(equalToConstant: 300),
            centerDescriptionModule.heightAnchor.constraint(equalToConstant: 100),
            centerDescriptionModule.centerXAnchor.constraint(equalTo: centerXAnchor),
            centerDescriptionModule.centerYAnchor.constraint(equalTo: focusLabel.centerYAnchor),
            
            bottomDescriptionModule.widthAnchor.constraint(equalToConstant: 300),
            bottomDescriptionModule.heightAnchor.constraint(equalToConstant: 100),
            bottomDescriptionModule.topAnchor.constraint(equalTo: focusLabel.bottomAnchor),
            bottomDescriptionModule.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
