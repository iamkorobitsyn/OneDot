//
//  UIView + Extansions.swift
//  OneDot
//
//  Created by Александр Коробицын on 11.11.2024.
//

import Foundation
import UIKit

extension UIView {
    
    func disableAutoresizingMask() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
 
    func roundCorners(topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) {
        let path = UIBezierPath()
        let rect = self.bounds
        
        path.move(to: CGPoint(x: rect.minX + topLeft, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - topRight, y: rect.minY))
        path.addArc(withCenter: CGPoint(x: rect.maxX - topRight, y: rect.minY + topRight),
                    radius: topRight,
                    startAngle: -.pi / 2,
                    endAngle: 0,
                    clockwise: true)
        
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - bottomRight))
        path.addArc(withCenter: CGPoint(x: rect.maxX - bottomRight, y: rect.maxY - bottomRight),
                    radius: bottomRight,
                    startAngle: 0,
                    endAngle: .pi / 2,
                    clockwise: true)
        
        path.addLine(to: CGPoint(x: rect.minX + bottomLeft, y: rect.maxY))
        path.addArc(withCenter: CGPoint(x: rect.minX + bottomLeft, y: rect.maxY - bottomLeft),
                    radius: bottomLeft,
                    startAngle: .pi / 2,
                    endAngle: .pi,
                    clockwise: true)
        
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + topLeft))
        path.addArc(withCenter: CGPoint(x: rect.minX + topLeft, y: rect.minY + topLeft),
                    radius: topLeft,
                    startAngle: .pi,
                    endAngle: -.pi / 2,
                    clockwise: true)
        
        path.close()
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}
