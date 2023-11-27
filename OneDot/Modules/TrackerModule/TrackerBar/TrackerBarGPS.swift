//
//  gpsView.swift
//  OneDot
//
//  Created by Александр Коробицын on 26.09.2023.
//

import Foundation
import UIKit

class TrackerBarGPS: UIView {

    
    //MARK: - Views&Shapes
    
    private let label: UILabel = UILabel()
    let pillingCircle: CAShapeLayer = CAShapeLayer()
    let satelliteIcon: UIImageView = UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setConstraints()
        drawPillingCircle()
        
        pillingCircle.fillColor = UIColor.green.cgColor
    }
    
    func drawPillingCircle() {
        let path = UIBezierPath()
        let center = CGPoint(x: 27, y: 28)
        path.addArc(withCenter: center,
                    radius: 2,
                    startAngle: 0,
                    endAngle: CGFloat.pi * 2,
                    clockwise: true)
        pillingCircle.path = path.cgPath
        layer.addSublayer(pillingCircle)
    }
    
    
    //MARK: - SetViews
    
    private func setViews() {
        addSubview(satelliteIcon)
        satelliteIcon.image = UIImage(named: "satelliteIcon")
        
        addSubview(label)
        label.textColor = .gray
        label.text = "GPS"
        label.font = UIFont.systemFont(ofSize: 6, weight: .medium)
    }
    
 
    //MARK: - SetConstraints
    
    private func setConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        satelliteIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            label.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 13),
            label.centerXAnchor.constraint(equalTo: satelliteIcon.centerXAnchor),
            
            satelliteIcon.widthAnchor.constraint(equalToConstant: 16),
            satelliteIcon.heightAnchor.constraint(equalToConstant: 16),
            satelliteIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
            satelliteIcon.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}