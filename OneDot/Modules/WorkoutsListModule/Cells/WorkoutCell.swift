//
//  WorkoutCell.swift
//  OneDot
//
//  Created by Александр Коробицын on 05.12.2024.
//

import Foundation
import UIKit
import HealthKit

class WorkoutCell: UITableViewCell {
    
    var healhKitData: HealthKitData?
    
    private let backView: UIView = {
        let view = UIView()
        view.disableAutoresizingMask()
        view.backgroundColor = .myPaletteBlue
        view.layer.cornerRadius = 4
        return view
    }()
    
    let detailsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.disableAutoresizingMask()
        imageView.image = UIImage(named: "SSDetails")
        return imageView
    }()
    
    let workoutTypeLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.instance(color: .white, alignment: .right, font: .boldCompExtraLarge)
        return label
    }()
    
    let workoutStatisticLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.instance(color: .white, alignment: .right, font: .boldCompExtraLarge)
        return label
    }()
    
    let workoutDurationLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.instance(color: .white, alignment: .left, font: .boldCompExtraLarge)
        return label
    }()
    
    let workoutDateLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.instance(color: .white, alignment: .left, font: .boldCompExtraLarge)
        return label
    }()
    
    let separators: CAShapeLayer = CAShapeLayer()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViews()
        setConstraints()
    }
    
    private func setViews() {
        backgroundColor = .clear
        contentView.addSubview(backView)
        addSubview(workoutTypeLabel)
        addSubview(workoutDurationLabel)
        addSubview(workoutStatisticLabel)
        addSubview(workoutDateLabel)
        addSubview(detailsImage)
        
        ShapeManager.shared.drawWorkoutCellSeparators(shape: separators, view: self)
    }
    
    func updateLabels() {
        
        guard let healhKitData else {return}
        
        let stringRepresentable = healhKitData.stringRepresentation()
        
        workoutTypeLabel.text = stringRepresentable.workoutType.uppercased()
        workoutDurationLabel.text = stringRepresentable.duration.uppercased()
        workoutStatisticLabel.text = stringRepresentable.totalDistance.uppercased()
        workoutDateLabel.text = stringRepresentable.startDate.uppercased()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
 
            backView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            backView.widthAnchor.constraint(equalToConstant: .barWidth - 10),
            backView.heightAnchor.constraint(equalToConstant: 100),
            
            workoutTypeLabel.widthAnchor.constraint(equalToConstant: .barWidth / 4),
            workoutTypeLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 20),
            workoutTypeLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -.barWidth / 4),
            workoutDurationLabel.widthAnchor.constraint(equalToConstant: .barWidth / 4),
            workoutDurationLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 20),
            workoutDurationLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: .barWidth  / 4),
            
            workoutStatisticLabel.widthAnchor.constraint(equalToConstant: .barWidth / 4),
            workoutStatisticLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -20),
            workoutStatisticLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -.barWidth / 4),
            workoutDateLabel.widthAnchor.constraint(equalToConstant: .barWidth / 4),
            workoutDateLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -20),
            workoutDateLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: .barWidth / 4),
            
            detailsImage.widthAnchor.constraint(equalToConstant: 42),
            detailsImage.heightAnchor.constraint(equalToConstant: 42),
            detailsImage.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
            detailsImage.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
