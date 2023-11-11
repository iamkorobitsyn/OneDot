//
//  gpsView.swift
//  OneDot
//
//  Created by Александр Коробицын on 26.09.2023.
//

import Foundation
import UIKit

class MainBarHeadGPS: UIView {

    
    //MARK: - Views&Shapes
    
    private let label: UILabel = UILabel()
    let pillingCircle: CAShapeLayer = CAShapeLayer()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setConstraints()
        drawPillingCircle()
        
        pillingCircle.fillColor = UIColor.green.cgColor
    }
    
    func drawPillingCircle() {
        let path = UIBezierPath()
        let center = CGPoint(x: 40, y: 9.8)
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
        addSubview(label)
        label.textColor = .gray
        label.text = "GPS"
        label.font = UIFont.systemFont(ofSize: 8, weight: .medium)
    }
    
 
    //MARK: - SetConstraints
    
    private func setConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
