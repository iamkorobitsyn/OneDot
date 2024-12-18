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
    
    var workout: HKWorkout?
    
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
        label.instance(color: .white, alignment: .center, font: .boldCompLarge)
        return label
    }()
    
    let workoutDurationLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.instance(color: .white, alignment: .center, font: .boldCompLarge)
        return label
    }()
    
    let workoutStatisticLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.instance(color: .white, alignment: .center, font: .boldCompLarge)
        return label
    }()
    
    let workoutDateLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.instance(color: .white, alignment: .center, font: .boldCompLarge)
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
        
        guard let workout else {return}
        
        // Тип тренировки
        workoutTypeLabel.text = workout.workoutActivityType.name
        
        // Длительность тренировки
        let duration = workout.duration / 60 // в минутах
        workoutDurationLabel.text = String(format: "%.1f мин", duration)
        
        
        
//               if let distanceInMeters = workout.distance?.totalDistance {
//                   let kilometers = Int(distanceInMeters / 1000)
//                   let meters = Int(distanceInMeters.truncatingRemainder(dividingBy: 1000))
//
//                   cell.bottomLeadingLabel.text = "\(kilometers) km \(meters) m"
//               }
//
//               if let coordinates = workout.route?.locations {
//                   print(coordinates.count)
//               }
             
        // Дата тренировки
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let workoutDate = dateFormatter.string(from: workout.startDate)
        workoutDateLabel.text = workoutDate
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
