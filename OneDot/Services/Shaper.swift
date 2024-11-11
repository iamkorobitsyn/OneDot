//
//  Shaper.swift
//  OneDot
//
//  Created by Александр Коробицын on 28.09.2023.
//

import Foundation
import UIKit

class Shaper {
    
    static let shared = Shaper()
    
    private init() {}
    
    func drawTabBarSeparator(shape: CAShapeLayer, view: UIView) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: CGFloat.trackerBarWidth / 2, y: 15))
        path.addLine(to: CGPoint(x: CGFloat.trackerBarWidth / 2 , y: 15 + 65))
        shape.path = path.cgPath
        shape.lineWidth = 0.5
        shape.lineCap = .round
        shape.strokeColor = UIColor.white.cgColor
        view.layer.addSublayer(shape)
    }
    
    func drawYSeparator(shape: CAShapeLayer,
                        view: UIView,
                        x: CGFloat,
                        y: CGFloat,
                        length: CGFloat,
                        color: UIColor) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: x, y: y))
        path.addLine(to: CGPoint(x: x , y: y + length))
        shape.path = path.cgPath
        shape.lineWidth = 0.5
        shape.lineCap = .round
        shape.strokeColor = color.cgColor
        view.layer.addSublayer(shape)
    }
    
    func drawXSeparator(shape: CAShapeLayer,
                        view: UIView,
                        x: CGFloat,
                        y: CGFloat,
                        length: CGFloat,
                        color: UIColor) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: x, y: y))
        path.addLine(to: CGPoint(x: x + length, y: y))
        shape.path = path.cgPath
        shape.lineWidth = 0.5
        shape.lineCap = .round
        shape.strokeColor = color.cgColor
        view.layer.addSublayer(shape)
    }
    
    func drawBpmLight(shape: CAShapeLayer,
                            view: UIView,
                            x: CGFloat,
                            y: CGFloat) {
        
        let path = UIBezierPath(arcCenter: CGPoint(x: x, y: y),
                                radius: 2.5,
                                startAngle: 0,
                                endAngle: Double.pi * 2,
                                clockwise: true)
        
        shape.path = path.cgPath
        shape.fillColor = UIColor.red.cgColor
        view.layer.addSublayer(shape)
    }
}
