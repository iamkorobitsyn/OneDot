//
//  MetricsPanelCell.swift
//  OneDot
//
//  Created by Александр Коробицын on 05.12.2024.
//

import Foundation
import UIKit

class MetricsPanelCell: UICollectionViewCell {
    
    private let leadingTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light, width: .compressed)
        label.textColor = .myPaletteGray
        return label
    }()
    
    private let leadingIcon: UIImageView = UIImageView()
    
    private let leadingValue: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.textColor = .myPaletteGray
        return label
    }()
    
    private let leadingStack: UIStackView = {
        let stack = UIStackView()
        stack.disableAutoresizingMask()
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
    }()
    
    private let trailingTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light, width: .compressed)
        label.textColor = .myPaletteGray
        return label
    }()
    
    private let trailingIcon: UIImageView = UIImageView()
    
    private let trailingValue: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.textColor = .myPaletteGray
        return label
    }()
    
    private let trailingStack: UIStackView = {
        let stack = UIStackView()
        stack.disableAutoresizingMask()
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
    }()
    
    private let separator: CAShapeLayer = CAShapeLayer()
    
    enum Mode: Int {
        case timeAndCalories = 0
        case distanceAndSpeed = 1
        case heartRateAndCadence = 2
    }
    
    //MARK: - Init
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setConstraints()
    }
    
    //MARK: - ActivateMode
    
    func activateMode(mode: Mode.RawValue) {
        switch mode {
        case 0:
            leadingTitle.text = "Total time"
            leadingIcon.image = UIImage(named: "AMTime")
            leadingValue.text = "05:45:20"
            
            trailingTitle.text = "Total calories"
            trailingIcon.image = UIImage(named: "AMCalories")
            trailingValue.text = "3246"
        case 1:
            leadingTitle.text = "Total distance"
            leadingIcon.image = UIImage(named: "AMRoad")
            leadingValue.text = "54.6 Km"
            
            trailingTitle.text = "Average speed"
            trailingIcon.image = UIImage(named: "AMSpeed")
            trailingValue.text = "10.2 Km / h"
        case 2:
            leadingTitle.text = "Heart rage"
            leadingIcon.image = UIImage(named: "AMCardio")
            leadingValue.text = "142"
            
            trailingTitle.text = "Average cadence"
            trailingIcon.image = UIImage(named: "AMCadence")
            trailingValue.text = "168"
        default:
            break
        }
    }
    
    //MARK: - SetViews
    
    private func setViews() {
        addSubview(leadingStack)
        addSubview(trailingStack)
        
        leadingStack.addArrangedSubview(leadingTitle)
        leadingStack.addArrangedSubview(leadingIcon)
        leadingStack.addArrangedSubview(leadingValue)
        
        trailingStack.addArrangedSubview(trailingTitle)
        trailingStack.addArrangedSubview(trailingIcon)
        trailingStack.addArrangedSubview(trailingValue)
        
        ShapeManager.shared.drawMetricsCellSeparator(shape: separator, view: self)
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            leadingStack.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -75),
            leadingStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            leadingStack.widthAnchor.constraint(equalToConstant: 100),
            leadingStack.heightAnchor.constraint(equalToConstant: 100),
            
            trailingStack.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 75),
            trailingStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            trailingStack.widthAnchor.constraint(equalToConstant: 100),
            trailingStack.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
