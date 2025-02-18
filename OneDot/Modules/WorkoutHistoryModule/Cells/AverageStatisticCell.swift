//
//  MetricsPanelCell.swift
//  OneDot
//
//  Created by Александр Коробицын on 05.12.2024.
//

import Foundation
import UIKit

class AverageStatisticCell: UICollectionViewCell {
    
    var workoutData: [WorkoutData]?

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
        
        guard let workoutData else { return }
        let statistics = CalculationsService.shared.getWorkoutStatistics(workoutList: workoutData,
                                                                         period: .allTime)
        
        switch mode {
        case .timeAndCalories:
            
            let hours = Int(statistics.duration) / 3600
            let minutes = (Int(statistics.duration) % 3600) / 60
            let seconds = Int(statistics.duration) % 60
            let duration = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            
            leadingResultModule.activateMode(axis: .vertical, mode: .timeDescription, text: duration)
            trailingResultModule.activateMode(axis: .vertical, mode: .caloriesDescription, text: "\(Int(statistics.calloriesBurned))")
        case .distanceAndClimb:
            leadingResultModule.activateMode(axis: .vertical, mode: .distanceDescription, text: "\(statistics.totalDistance)")
            trailingResultModule.activateMode(axis: .vertical, mode: .climbDescription, text: "CLIMB")
        case .heartRateAndPace:
            leadingResultModule.activateMode(axis: .vertical, mode: .heartRateDescription, text: "\(statistics.averageHeartRate)")
            trailingResultModule.activateMode(axis: .vertical, mode: .paceDescription, text: "\(statistics.averagePace)")
        case .stepsAndCadence:
            leadingResultModule.activateMode(axis: .vertical, mode: .stepsDescription, text: "STEPS")
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
