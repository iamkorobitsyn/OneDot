//
//  WorkoutResultModule.swift
//  OneDot
//
//  Created by Александр Коробицын on 16.12.2024.
//

import Foundation
import UIKit

class WorkoutResultModule: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .light, width: .compressed)
        label.textColor = .myPaletteGray
        return label
    }()
    
    let iconView: UIImageView = {
        let view = UIImageView()
        view.disableAutoresizingMask()
        return view
    }()
    
    let resultLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium, width: .compressed)
        label.textColor = .myPaletteGray
        return label
    }()
    
    enum Mode {
        case totalTime
        case time
        case totalCalories
        case calories
        case heartRate
        case totalDistance
        case distance
        case averagePace
        case averageCadence
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setConstraints()
    }
    
    func activateMode(mode: Mode, withResult: String) {
        
        resultLabel.text = withResult
        
        switch mode {
        case .totalTime:
            titleLabel.text = "Total time"
            iconView.image = UIImage(named: "AMTime")
        case .time:
            titleLabel.text = "Time"
            iconView.image = UIImage(named: "AMTime")
        case .totalCalories:
            titleLabel.text = "Total calories"
            iconView.image = UIImage(named: "AMCalories")
        case .calories:
            titleLabel.text = "Calories"
            iconView.image = UIImage(named: "AMCalories")
        case .heartRate:
            titleLabel.text = "Heart rate"
            iconView.image = UIImage(named: "AMCardio")
        case .totalDistance:
            titleLabel.text = "Total Distance"
            iconView.image = UIImage(named: "AMRoad")
        case .distance:
            titleLabel.text = "Distance"
            iconView.image = UIImage(named: "AMRoad")
        case .averagePace:
            titleLabel.text = "Average pace"
            iconView.image = UIImage(named: "AMPace")
        case .averageCadence:
            titleLabel.text = "Average cadence"
            iconView.image = UIImage(named: "AMCadence")
        }
    }

    private func setViews() {
        addSubview(titleLabel)
        addSubview(iconView)
        addSubview(resultLabel)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 20),
            iconView.heightAnchor.constraint(equalToConstant: 20),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            titleLabel.widthAnchor.constraint(equalToConstant: .barWidth / 4),
            titleLabel.bottomAnchor.constraint(equalTo: iconView.topAnchor, constant: -15),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            resultLabel.widthAnchor.constraint(equalToConstant: .barWidth / 4),
            resultLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 15),
            resultLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
