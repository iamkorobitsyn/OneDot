//
//  WorkoutCell.swift
//  OneDot
//
//  Created by Александр Коробицын on 05.12.2024.
//

import Foundation
import UIKit

class WorkoutCell: UITableViewCell {
    
    private let backView: UIView = {
        let view = UIView()
        view.disableAutoresizingMask()
        view.backgroundColor = .myPaletteBlue
        view.layer.cornerRadius = 5
        return view
    }()
    
    let topLeadingLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold, width: .compressed)
        return label
    }()
    
    let topTrailingLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold, width: .compressed)
        return label
    }()
    
    let bottomLeadingLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold, width: .compressed)
        return label
    }()
    
    let bottomTrailingLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold, width: .compressed)
        return label
    }()
    
    let detailsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.disableAutoresizingMask()
        imageView.image = UIImage(named: "SSDetails")
        return imageView
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
        addSubview(topLeadingLabel)
        addSubview(topTrailingLabel)
        addSubview(bottomLeadingLabel)
        addSubview(bottomTrailingLabel)
        addSubview(detailsImage)
        
        Shaper.shared.drawWorkoutCellSeparators(shape: separators, view: self)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
 
            backView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            backView.widthAnchor.constraint(equalToConstant: .barWidth - 10),
            backView.heightAnchor.constraint(equalToConstant: 100),
            
            topLeadingLabel.widthAnchor.constraint(equalToConstant: .barWidth / 4),
            topLeadingLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 20),
            topLeadingLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -.barWidth / 4),
            topTrailingLabel.widthAnchor.constraint(equalToConstant: .barWidth / 4),
            topTrailingLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 20),
            topTrailingLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: .barWidth  / 4),
            
            bottomLeadingLabel.widthAnchor.constraint(equalToConstant: .barWidth / 4),
            bottomLeadingLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -20),
            bottomLeadingLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -.barWidth / 4),
            bottomTrailingLabel.widthAnchor.constraint(equalToConstant: .barWidth / 4),
            bottomTrailingLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -20),
            bottomTrailingLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: .barWidth / 4),
            
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
