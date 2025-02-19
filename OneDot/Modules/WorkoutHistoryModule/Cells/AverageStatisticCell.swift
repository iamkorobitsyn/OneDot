//
//  MetricsPanelCell.swift
//  OneDot
//
//  Created by Александр Коробицын on 05.12.2024.
//

import Foundation
import UIKit

class AverageStatisticCell: UICollectionViewCell {
    
    let leadingResultModule: DescriptionModuleView = {
        let module = DescriptionModuleView()
        module.disableAutoresizingMask()
        return module
    }()
    
    let trailingResultModule: DescriptionModuleView = {
        let module = DescriptionModuleView()
        module.disableAutoresizingMask()
        return module
    }()
    
    private let separator: CAShapeLayer = CAShapeLayer()
    
    enum Mode: Int {
        case timeAndCalories = 0
        case distanceAndPace = 1
        case heartRateAndCadence = 2
    }
    
    //MARK: - Init
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setConstraints()
    }
    
    //MARK: - ActivateMode
    
    func activateMode(mode: Mode, statistics: WorkoutStatistics) {
        
        switch mode {
        case .timeAndCalories:
            
            leadingResultModule.activateMode(axis: .vertical, mode: .timeDescription, text: statistics.duration)
            trailingResultModule.activateMode(axis: .vertical, mode: .caloriesDescription, text: "")
        case .distanceAndPace:
            leadingResultModule.activateMode(axis: .vertical, mode: .distanceDescription, text: "")
            trailingResultModule.activateMode(axis: .vertical, mode: .paceDescription, text: "\(statistics.averagePace)")
        case .heartRateAndCadence:
            leadingResultModule.activateMode(axis: .vertical, mode: .heartRateDescription, text: "\(statistics.averageHeartRate)")
            trailingResultModule.activateMode(axis: .vertical, mode: .cadenceDescription, text: "\(statistics.averageCadence)")
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
            
            trailingResultModule.widthAnchor.constraint(equalToConstant: 100),
            trailingResultModule.heightAnchor.constraint(equalToConstant: 100),
            trailingResultModule.centerYAnchor.constraint(equalTo: centerYAnchor),
            trailingResultModule.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 75)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
