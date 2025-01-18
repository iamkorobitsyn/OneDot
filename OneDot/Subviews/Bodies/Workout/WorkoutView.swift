//
//  WorkoutView.swift
//  OneDot
//
//  Created by Александр Коробицын on 11.01.2025.
//

import Foundation
import UIKit

class WorkoutView: UIView {
    
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
    
    private let distanceTrackingView: DescriptionModule = {
        let module = DescriptionModule()
        module.disableAutoresizingMask()
        return module
    }()
    
    private let paceTrackingView: DescriptionModule = {
        let module = DescriptionModule()
        module.disableAutoresizingMask()
        return module
    }()
    
    private let caloriesTrackingView: DescriptionModule = {
        let view = DescriptionModule()
        view.disableAutoresizingMask()
        return view
    }()
    
    private let heartrateTrackingView: DescriptionModule = {
        let view = DescriptionModule()
        view.disableAutoresizingMask()
        return view
    }()
    
    let crossSeparator: UIImageView = {
        let view = UIImageView()
        view.disableAutoresizingMask()
        view.image = UIImage(named: "crossSeparator")
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
            distanceTrackingView.isHidden = false
            paceTrackingView.isHidden = false
            caloriesTrackingView.isHidden = false
            heartrateTrackingView.isHidden = false
            crossSeparator.isHidden = false
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
    
    private func clearVisibleViews() {
        distanceTrackingView.isHidden = true
        paceTrackingView.isHidden = true
        caloriesTrackingView.isHidden = true
        heartrateTrackingView.isHidden = true
        crossSeparator.isHidden = true
        focusLabel.isHidden = true
    }
    
    private func setViews() {
        
        addSubview(distanceTrackingView)
        addSubview(paceTrackingView)
        addSubview(caloriesTrackingView)
        addSubview(heartrateTrackingView)
        addSubview(crossSeparator)
        addSubview(focusLabel)
        
        distanceTrackingView.activateMode(axis: .vertical, mode: .distanceTracking, text: "122.95")
        paceTrackingView.activateMode(axis: .vertical, mode: .paceTracking, text: "12:45")
        caloriesTrackingView.activateMode(axis: .vertical, mode: .caloriesTracking, text: "123")
        heartrateTrackingView.activateMode(axis: .vertical, mode: .heartRateTracking, text: "147")
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            
            distanceTrackingView.widthAnchor.constraint(equalToConstant: 160),
            distanceTrackingView.heightAnchor.constraint(equalToConstant: 100),
            distanceTrackingView.topAnchor.constraint(equalTo: topAnchor),
            distanceTrackingView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -100),
            
            paceTrackingView.widthAnchor.constraint(equalToConstant: 160),
            paceTrackingView.heightAnchor.constraint(equalToConstant: 100),
            paceTrackingView.topAnchor.constraint(equalTo: topAnchor),
            paceTrackingView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 100),
            
            crossSeparator.widthAnchor.constraint(equalToConstant: 42),
            crossSeparator.heightAnchor.constraint(equalToConstant: 42),
            crossSeparator.centerXAnchor.constraint(equalTo: centerXAnchor),
            crossSeparator.topAnchor.constraint(equalTo: distanceTrackingView.bottomAnchor, constant: 10),
            
            focusLabel.widthAnchor.constraint(equalToConstant: .barWidth - 100),
            focusLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            focusLabel.centerYAnchor.constraint(equalTo: crossSeparator.centerYAnchor),
            
            caloriesTrackingView.widthAnchor.constraint(equalToConstant: 160),
            caloriesTrackingView.heightAnchor.constraint(equalToConstant: 100),
            caloriesTrackingView.topAnchor.constraint(equalTo: crossSeparator.bottomAnchor, constant: 10),
            caloriesTrackingView.centerXAnchor.constraint(equalTo: distanceTrackingView.centerXAnchor),
            
            heartrateTrackingView.widthAnchor.constraint(equalToConstant: 160),
            heartrateTrackingView.heightAnchor.constraint(equalToConstant: 100),
            heartrateTrackingView.topAnchor.constraint(equalTo: crossSeparator.bottomAnchor, constant: 10),
            heartrateTrackingView.centerXAnchor.constraint(equalTo: paceTrackingView.centerXAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
