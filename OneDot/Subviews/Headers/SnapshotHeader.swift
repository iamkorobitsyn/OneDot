//
//  WorkoutResultHeader.swift
//  OneDot
//
//  Created by Александр Коробицын on 16.12.2024.
//

import Foundation
import UIKit

class SnapshotHeaderView: UIView {
    
    var workoutData: WorkoutData?
    var climbValue: Double = 0
    var locationIconName: String = ""
    
    let containerVisualEffectView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        view.disableAutoresizingMask()
        view.clipsToBounds = true
        view.layer.instance(border: true, corner: .max)
        return view
    }()
    
    private let locationStateIcon: UIImageView = {
        let view = UIImageView()
        view.disableAutoresizingMask()
        return view
    }()
    
    private let workoutNameLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.instance(color: .myPaletteGold, alignment: .left, font: .standartMax)
        label.numberOfLines = 2
        return label
    }()
    
    private let workoutDateLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.instance(color: .myPaletteGray, alignment: .right, font: .standartMax)
        label.numberOfLines = 2
        return label
    }()

    let leadingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.disableAutoresizingMask()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()
    
    let trailingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.disableAutoresizingMask()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()
    
    private let separator: CAShapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(containerVisualEffectView)
        containerVisualEffectView.contentView.addSubview(locationStateIcon)
        containerVisualEffectView.contentView.addSubview(workoutNameLabel)
        containerVisualEffectView.contentView.addSubview(workoutDateLabel)
        
        containerVisualEffectView.contentView.addSubview(leadingStackView)
        containerVisualEffectView.contentView.addSubview(trailingStackView)
    }

    private func workoutNameStudioRepresentable(name: String) -> String {
        switch name {
        case "Running": return "Studio Run"
        case "Cycling": return "Studio Cycling"
        case "Rowing": return "Studio Rowing"
        case "Swimming": return "Swimming Pool"
        case "Climbing": return "Studio Climbing"
        case "Walking": return "Studio Walking"
        default:
            break
        }
        return name
    }
    
    func activate(locationOutdoor: Bool) {
      
        
        guard let workoutData else {return}
        locationStateIcon.image = UIImage(named: locationIconName)

        if locationOutdoor {
            workoutNameLabel.text = workoutData.workoutName.uppercased()
        } else {
            workoutNameLabel.text = workoutNameStudioRepresentable(name: workoutData.workoutName).uppercased()
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let stringStartDate = dateFormatter.string(from: workoutData.startDate)
        workoutDateLabel.text = stringStartDate

        if workoutData.totalDistance != 0 {
            let distanceView = DescriptionModuleView()
            let kilometers = workoutData.totalDistance / 1000
            let roundedKilometers = String(format: "%.2f", kilometers)
            distanceView.activateMode(axis: .horizontalCompact, mode: .distanceDescription, text: "\(roundedKilometers) km")
            leadingStackView.addArrangedSubview(distanceView)
        }
            
        if climbValue != 0 {
            let climbView = DescriptionModuleView()
            climbView.activateMode(axis: .horizontalCompact, mode: .climbDescription, text: "\(Int(climbValue))")
            leadingStackView.addArrangedSubview(climbView)
        }
        
        if workoutData.stepCount != 0 {
            let stepsView = DescriptionModuleView()
            stepsView.activateMode(axis: .horizontalCompact, mode: .stepsDescription, text: "\(Int(workoutData.stepCount))")
            leadingStackView.addArrangedSubview(stepsView)
        }
        
        let caloriesView = DescriptionModuleView()
        caloriesView.activateMode(axis: .horizontalCompact, mode: .caloriesDescription, text: "\(Int(workoutData.calloriesBurned))")
        leadingStackView.addArrangedSubview(caloriesView)
        
        
        
        let hours = Int(workoutData.duration) / 3600
        let minutes = (Int(workoutData.duration) % 3600) / 60
        let seconds = Int(workoutData.duration) % 60
        let duration = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        let timeView = DescriptionModuleView()
        timeView.activateMode(axis: .horizontalCompact, mode: .timeDescription, text: duration)
        trailingStackView.addArrangedSubview(timeView)
        
        if workoutData.pace != 0 {
            let paceMin = workoutData.pace / 60
            let paceSec = workoutData.pace % 60
            let paceView = DescriptionModuleView()
            paceView.activateMode(axis: .horizontalCompact, mode: .paceDescription, text: String(format: "%02d:%02d", paceMin, paceSec))
            trailingStackView.addArrangedSubview(paceView)
        }
        
        if workoutData.cadence != 0 {
            let cadenceView = DescriptionModuleView()
            cadenceView.activateMode(axis: .horizontalCompact, mode: .cadenceDescription, text: "\(workoutData.cadence)")
            trailingStackView.addArrangedSubview(cadenceView)
        }
        
        if workoutData.heartRate != 0 {
            let heartRateView = DescriptionModuleView()
            heartRateView.activateMode(axis: .horizontalCompact, mode: .heartRateDescription, text: "\(Int(workoutData.heartRate))")
            trailingStackView.addArrangedSubview(heartRateView)
        }
        
        let descriptionValueCountMax = max(leadingStackView.subviews.count, trailingStackView.subviews.count)

        ShapeManager.shared.drawResultSeparator(view: self,
                                                shape: separator,
                                                descriptionFullHeightState: descriptionValueCountMax > 2 ? true : false)
        
        setConstraints(descriptionValueCountL: leadingStackView.subviews.count,
                       descriptionValueCountR: trailingStackView.subviews.count,
                       descriptionValueCountMax: descriptionValueCountMax)

    }
    
    private func setConstraints(descriptionValueCountL: Int, descriptionValueCountR: Int, descriptionValueCountMax: Int) {
        
        let descriptionHeight: CGFloat = descriptionValueCountMax > 2 ? 120 : 60

        NSLayoutConstraint.activate([
            containerVisualEffectView.heightAnchor.constraint(equalToConstant: 90 + descriptionHeight),
            containerVisualEffectView.topAnchor.constraint(equalTo: topAnchor),
            containerVisualEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerVisualEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            locationStateIcon.widthAnchor.constraint(equalToConstant: 25),
            locationStateIcon.heightAnchor.constraint(equalToConstant: 25),
            locationStateIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
            locationStateIcon.topAnchor.constraint(equalTo: topAnchor, constant: 23.5),
            
            workoutNameLabel.widthAnchor.constraint(equalToConstant: 165),
            workoutNameLabel.heightAnchor.constraint(equalToConstant: 50),
            workoutNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -.barWidth / 4),
            workoutNameLabel.centerYAnchor.constraint(equalTo: locationStateIcon.centerYAnchor),
            
            workoutDateLabel.widthAnchor.constraint(equalToConstant: 165),
            workoutDateLabel.heightAnchor.constraint(equalToConstant: 50),
            workoutDateLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: .barWidth / 4),
            workoutDateLabel.centerYAnchor.constraint(equalTo: locationStateIcon.centerYAnchor),
            
            leadingStackView.widthAnchor.constraint(equalToConstant: 165),
            leadingStackView.heightAnchor.constraint(equalToConstant: CGFloat(descriptionValueCountL * 30)),
            leadingStackView.centerXAnchor.constraint(equalTo: workoutNameLabel.centerXAnchor),
            leadingStackView.centerYAnchor.constraint(equalTo: containerVisualEffectView.topAnchor,
                                                      constant: (descriptionHeight / 2) + 60),
            
            trailingStackView.widthAnchor.constraint(equalToConstant: 165),
            trailingStackView.heightAnchor.constraint(equalToConstant: CGFloat(descriptionValueCountR * 30)),
            trailingStackView.centerXAnchor.constraint(equalTo: workoutDateLabel.centerXAnchor),
            trailingStackView.topAnchor.constraint(equalTo: leadingStackView.topAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
