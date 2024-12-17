//
//  MetricsPanelCell.swift
//  OneDot
//
//  Created by Александр Коробицын on 05.12.2024.
//

import Foundation
import UIKit

class StatisticCell: UICollectionViewCell {
    
    let leadingResultModule: WorkoutResultModule = {
        let module = WorkoutResultModule()
        module.disableAutoresizingMask()
        return module
    }()
    
    let centerResultModule: WorkoutResultModule = {
        let module = WorkoutResultModule()
        module.disableAutoresizingMask()
        return module
    }()
    
    let trailingResultModule: WorkoutResultModule = {
        let module = WorkoutResultModule()
        module.disableAutoresizingMask()
        return module
    }()
    
    private let separator: CAShapeLayer = CAShapeLayer()
    
    enum Mode: Int {
        case timeCaloriesHeartRate = 0
        case distancePaceCadence = 1
    }
    
    //MARK: - Init
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setConstraints()
    }
    
    //MARK: - ActivateMode
    
    func activateMode(mode: Mode, first: String, second: String, third: String) {
        switch mode {
        case .timeCaloriesHeartRate:
            leadingResultModule.activateMode(mode: .totalTime, withResult: first)
            centerResultModule.activateMode(mode: .totalCalories, withResult: second)
            trailingResultModule.activateMode(mode: .heartRate, withResult: third)
        case .distancePaceCadence:
            leadingResultModule.activateMode(mode: .totalDistance, withResult: first)
            centerResultModule.activateMode(mode: .pace, withResult: second)
            trailingResultModule.activateMode(mode: .cadence, withResult: third)
        }
    }
    
    //MARK: - SetViews
    
    private func setViews() {
        addSubview(leadingResultModule)
        addSubview(centerResultModule)
        addSubview(trailingResultModule)
        
//        ShapeManager.shared.drawMetricsCellSeparator(shape: separator, view: self)
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            centerResultModule.widthAnchor.constraint(equalToConstant: 110),
            centerResultModule.heightAnchor.constraint(equalToConstant: 100),
            centerResultModule.centerXAnchor.constraint(equalTo: centerXAnchor),
            centerResultModule.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            leadingResultModule.widthAnchor.constraint(equalToConstant: 110),
            leadingResultModule.heightAnchor.constraint(equalToConstant: 100),
            leadingResultModule.centerYAnchor.constraint(equalTo: centerResultModule.centerYAnchor),
            leadingResultModule.trailingAnchor.constraint(equalTo: centerResultModule.leadingAnchor),
            
            trailingResultModule.widthAnchor.constraint(equalToConstant: 110),
            trailingResultModule.heightAnchor.constraint(equalToConstant: 100),
            trailingResultModule.centerYAnchor.constraint(equalTo: centerResultModule.centerYAnchor),
            trailingResultModule.leadingAnchor.constraint(equalTo: centerResultModule.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
