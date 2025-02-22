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
    
    var workoutData: WorkoutData?
    
    private let backView: UIView = {
        let view = UIView()
        view.disableAutoresizingMask()
        view.backgroundColor = .myPaletteBlue
        view.layer.cornerRadius = 12
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    let detailsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.disableAutoresizingMask()
        imageView.image = UIImage(named: "BodyDetailsWhite")
        return imageView
    }()
    
    let workoutTypeLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.instance(color: .white, alignment: .right, font: .standartMax)
        label.numberOfLines = 2
        return label
    }()
    
    let workoutStatisticLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.instance(color: .white, alignment: .right, font: .standartMax)
        label.numberOfLines = 2
        return label
    }()
    
    let workoutDurationLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.instance(color: .white, alignment: .left, font: .standartMax)
        label.numberOfLines = 2
        return label
    }()
    
    let workoutDateLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.instance(color: .white, alignment: .left, font: .standartMax)
        label.numberOfLines = 2
        return label
    }()
    
    let separators: CAShapeLayer = CAShapeLayer()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        workoutStatisticLabel.instance(color: .white, alignment: .right, font: .standartMax)
        
    }
    
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
    }
    
    override func layoutSubviews() {
        GraphicsService.shared.drawShape(shape: separators, shapeType: .crossShape(color: .white), view: self)
    }
    
    func updateLabels() {
        
        guard let workoutData else {return}

        workoutTypeLabel.text = workoutData.workoutName.uppercased()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let stringStartDate = dateFormatter.string(from: workoutData.startDate)
        workoutDateLabel.text = stringStartDate
        
        let hours = Int(workoutData.duration) / 3600
        let minutes = (Int(workoutData.duration) % 3600) / 60
        let seconds = Int(workoutData.duration) % 60
        let duration = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        workoutDurationLabel.text = duration.uppercased()
        
        if workoutData.distance >= 100 {
            let kilometers = workoutData.distance / 1000
            let roundedKilometers = String(format: "%.2f", kilometers)
            workoutStatisticLabel.text = ("\(roundedKilometers) km").uppercased()
        } else {
            workoutStatisticLabel.font = UIFont.systemFont(ofSize: 20, weight: .thin)
            workoutStatisticLabel.text = "\u{2014}"
        }
        
        

    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            backView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            backView.widthAnchor.constraint(equalToConstant: .barWidth - 10),
            backView.heightAnchor.constraint(equalToConstant: 100),
            
            workoutTypeLabel.widthAnchor.constraint(equalToConstant: 150),
            workoutTypeLabel.heightAnchor.constraint(equalToConstant: 50),
            workoutTypeLabel.topAnchor.constraint(equalTo: backView.topAnchor),
            workoutTypeLabel.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -35),
            
            workoutDateLabel.widthAnchor.constraint(equalToConstant: 150),
            workoutDateLabel.heightAnchor.constraint(equalToConstant: 50),
            workoutDateLabel.topAnchor.constraint(equalTo: backView.topAnchor),
            workoutDateLabel.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 35),
            
            workoutDurationLabel.widthAnchor.constraint(equalToConstant: 150),
            workoutDurationLabel.heightAnchor.constraint(equalToConstant: 50),
            workoutDurationLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor),
            workoutDurationLabel.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 35),
            
            workoutStatisticLabel.widthAnchor.constraint(equalToConstant: 150),
            workoutStatisticLabel.heightAnchor.constraint(equalToConstant: 50),
            workoutStatisticLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor),
            workoutStatisticLabel.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -35),
            
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
