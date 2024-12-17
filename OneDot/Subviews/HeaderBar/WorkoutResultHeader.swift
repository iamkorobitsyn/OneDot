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
        
        effect = UIBlurEffect(style: .light)
        clipsToBounds = true
        layer.customBorder(bord: true, corner: .min)
        
        contentView.addSubview(topStack)
        [topLeadingModule, topCenterModule, topTrailingModule].forEach({topStack.addArrangedSubview($0)})
        
        topLeadingModule.activateMode(mode: .time, withResult: "05:45:20")
        topCenterModule.activateMode(mode: .calories, withResult: "3246")
        topTrailingModule.activateMode(mode: .heartRate, withResult: "142")
        
        if fullModeState {
            contentView.addSubview(bottomStack)
            [bottomLeadingModule, bottomCenterModule, bottomTrailingModule].forEach({bottomStack.addArrangedSubview($0)})
            
            bottomLeadingModule.activateMode(mode: .distance, withResult: "54.6 km")
            bottomCenterModule.activateMode(mode: .pace, withResult: "5:54 / km")
            bottomTrailingModule.activateMode(mode: .cadence, withResult: "165")
        }
        
        setConstraints(fullModeState: fullModeState)
    }
    
    private func setConstraints(fullModeState: Bool) {
        NSLayoutConstraint.activate([
            topStack.widthAnchor.constraint(equalToConstant: 330),
            topStack.heightAnchor.constraint(equalToConstant: 100),
            topStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            topStack.topAnchor.constraint(equalTo: topAnchor, constant: 120)
        ])
        
        if fullModeState {
            NSLayoutConstraint.activate([
                bottomStack.widthAnchor.constraint(equalToConstant: 330),
                bottomStack.heightAnchor.constraint(equalToConstant: 100),
                bottomStack.centerXAnchor.constraint(equalTo: centerXAnchor),
                bottomStack.topAnchor.constraint(equalTo: topStack.bottomAnchor, constant: 20)
            ])
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
