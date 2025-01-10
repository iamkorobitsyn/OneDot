//
//  MetricsPanelCell.swift
//  OneDot
//
//  Created by Александр Коробицын on 05.12.2024.
//

import Foundation
import UIKit

class AverageStatisticCell: UICollectionViewCell {

    let leadingResultModule: StackModuleForResultsWorkout = {
        let module = StackModuleForResultsWorkout()
        module.disableAutoresizingMask()
        return module
    }()
    
    let trailingResultModule: StackModuleForResultsWorkout = {
        let module = StackModuleForResultsWorkout()
        module.disableAutoresizingMask()
        return module
    }()
    
    private let separator: CAShapeLayer = CAShapeLayer()
    
    enum Mode: Int {
        case timeAndCalories = 0
        case distanceAndClimb = 1
        case heartRateAndPace = 2
        case stepsAndCadence = 3
    }
    
    //MARK: - Init
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setConstraints()
    }
    
    //MARK: - ActivateMode
    
    func activateMode(mode: Mode) {
        switch mode {
        case .timeAndCalories:
            leadingResultModule.activateMode(axis: .vertical, mode: .time, text: "05:43:47")
            trailingResultModule.activateMode(axis: .vertical, mode: .calories, text: "3457")
        case .distanceAndClimb:
            leadingResultModule.activateMode(axis: .vertical, mode: .distance, text: "56.4 km")
            trailingResultModule.activateMode(axis: .vertical, mode: .climb, text: "459 m")
        case .heartRateAndPace:
            leadingResultModule.activateMode(axis: .vertical, mode: .heartRate, text: "147")
            trailingResultModule.activateMode(axis: .vertical, mode: .pace, text: "5:43 / km")
        case .stepsAndCadence:
            leadingResultModule.activateMode(axis: .vertical, mode: .steps, text: "16457")
            trailingResultModule.activateMode(axis: .vertical, mode: .cadence, text: "167")
        }
    }
    
    //MARK: - SetViews
    
    private func setViews() {
        addSubview(leadingResultModule)
        addSubview(trailingResultModule)
        
        ShapeManager.shared.drawMetricsCellSeparator(shape: separator, view: self)
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            
            leadingResultModule.widthAnchor.constraint(equalToConstant: 100),
            leadingResultModule.heightAnchor.constraint(equalToConstant: 100),
            leadingResultModule.centerYAnchor.constraint(equalTo: centerYAnchor),
            leadingResultModule.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -75),
            
            trailingResultModule.widthAnchor.constraint(equalToConstant: 110),
            trailingResultModule.heightAnchor.constraint(equalToConstant: 100),
            trailingResultModule.centerYAnchor.constraint(equalTo: centerYAnchor),
            trailingResultModule.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 75)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
