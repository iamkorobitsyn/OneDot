//
//  WorkoutResultHeader.swift
//  OneDot
//
//  Created by Александр Коробицын on 16.12.2024.
//

import Foundation
import UIKit

class WorkoutResultHeader: UIVisualEffectView {
    
    let topLeadingModule: WorkoutResultModule = WorkoutResultModule()
    let topCenterModule: WorkoutResultModule = WorkoutResultModule()
    let topTrailingModule: WorkoutResultModule = WorkoutResultModule()
    let bottomLeadingModule: WorkoutResultModule = WorkoutResultModule()
    let bottomCenterModule: WorkoutResultModule = WorkoutResultModule()
    let bottomTrailingModule: WorkoutResultModule = WorkoutResultModule()
    
    let topStack: UIStackView = {
        let stackView = UIStackView()
        stackView.disableAutoresizingMask()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()
    
    let bottomStack: UIStackView = {
        let stackView = UIStackView()
        stackView.disableAutoresizingMask()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        setViewsAndConstraints(fullModeState: true)
    }

    
    private func setViewsAndConstraints(fullModeState: Bool) {
        
//        effect = UIBlurEffect(style: .light)
//        clipsToBounds = true
//        layer.cornerRadius = CGFloat.barCorner
//        layer.cornerCurve = .continuous
//        layer.borderWidth = 0.3
//        layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        
        contentView.addSubview(topStack)
        [topLeadingModule, topCenterModule, topTrailingModule].forEach({topStack.addArrangedSubview($0)})
        
        topLeadingModule.activateMode(mode: .totalTime, withResult: "05:45:20")
        topCenterModule.activateMode(mode: .totalCalories, withResult: "3246")
        topTrailingModule.activateMode(mode: .heartRate, withResult: "142")
        
        if fullModeState {
            contentView.addSubview(bottomStack)
            [bottomLeadingModule, bottomCenterModule, bottomTrailingModule].forEach({bottomStack.addArrangedSubview($0)})
            
            bottomLeadingModule.activateMode(mode: .totalDistance, withResult: "54.6 km")
            bottomCenterModule.activateMode(mode: .averagePace, withResult: "5:54 / km")
            bottomTrailingModule.activateMode(mode: .averageCadence, withResult: "165")
        }
        
        setConstraints(fullModeState: fullModeState)
    }
    
    private func setConstraints(fullModeState: Bool) {
        NSLayoutConstraint.activate([
            topStack.widthAnchor.constraint(equalToConstant: .barWidth),
            topStack.heightAnchor.constraint(equalToConstant: 100),
            topStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            topStack.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        if fullModeState {
            NSLayoutConstraint.activate([
                bottomStack.widthAnchor.constraint(equalToConstant: .barWidth),
                bottomStack.heightAnchor.constraint(equalToConstant: 100),
                bottomStack.centerXAnchor.constraint(equalTo: centerXAnchor),
                bottomStack.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
