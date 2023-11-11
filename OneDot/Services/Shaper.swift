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
    
    //MARK: - SettingsView
    
    func drawCenterXSeparator(shape: CAShapeLayer,
                                        view: UIView,
                                        xMove: CGFloat,
                                        xAdd: CGFloat,
                                        y: CGFloat,
                                        lineWidth: CGFloat,
                                        color: UIColor) {
        let path = UIBezierPath()
        let center = UIScreen.main.bounds.width / 2
        path.move(to: CGPoint(x: center + xMove, y: y))
        path.addLine(to: CGPoint(x: center + xAdd, y: y))
        shape.path = path.cgPath
        shape.strokeColor = color.cgColor
        shape.lineWidth = lineWidth
        shape.lineCap = .round
        view.layer.addSublayer(shape)
    }
    
    
    func drawCenterYSeparator(shape: CAShapeLayer,
                                       view: UIView,
                                       moveX: CGFloat,
                                       moveY: CGFloat,
                                       addX: CGFloat,
                                       addY: CGFloat,
                                       lineWidth: CGFloat,
                                       color: UIColor) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: moveX, y: moveY))
        path.addLine(to: CGPoint(x: addX , y: addY))
        shape.path = path.cgPath
        shape.strokeColor = color.cgColor
        shape.lineWidth = lineWidth
        shape.lineCap = .round
        view.layer.addSublayer(shape)
    }
    

    
    //MARK: - TabBarView
    
    func drawTabBarSeparator(_ shape: CAShapeLayer,
                                   _ view: UIView,
                                   _ selfWidth: CGFloat,
                                   _ selfHeight: CGFloat) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: selfWidth / 2,
                              y: 10))
        path.addLine(to: CGPoint(x: selfWidth / 2,
                                 y: selfHeight - 10))
        shape.path = path.cgPath
        shape.strokeColor = UIColor.white.cgColor
        shape.lineWidth = 0.5
        shape.lineCap = .round
        view.layer.addSublayer(shape)
        
    }
    
    //MARK: - GPSView
    
    
    func drawFirstConnectionStick(_ shape: CAShapeLayer,
                                  _ view: UIView,
                                  _ selfWidth: CGFloat,
                                  _ selfHeight: CGFloat) {
        let firstConnectionStick: CAShapeLayer = CAShapeLayer()
        
        let firstConnectionStickPath = UIBezierPath()
        
        firstConnectionStickPath.move(to: CGPoint(x: selfWidth / 1.4 - 2,
                                                  y: selfHeight - 2))
        firstConnectionStickPath.addLine(to: CGPoint(x: selfWidth / 1.4 - 2,
             
                                                     y: selfHeight / 1.2))
        firstConnectionStick.path = firstConnectionStickPath.cgPath
        firstConnectionStick.lineWidth = 4
        firstConnectionStick.lineCap = .round
        firstConnectionStick.strokeColor = UIColor.green.cgColor
        
        view.layer.addSublayer(firstConnectionStick)
    }
    
    func drawSecondConnectionStick(_ shape: CAShapeLayer,
                                   _ view: UIView,
                                   _ selfWidth: CGFloat,
                                   _ selfHeight: CGFloat) {
        let secondConnectionStickPath = UIBezierPath()
        secondConnectionStickPath.move(to: CGPoint(x: selfWidth / 1.17 - 2,
                                                   y: selfHeight - 2))
        secondConnectionStickPath.addLine(to: CGPoint(x: selfWidth / 1.17 - 2,
              
                                                      y: selfHeight / 1.45))
        shape.path = secondConnectionStickPath.cgPath
        shape.lineWidth = 4
        shape.lineCap = .round
        shape.strokeColor = UIColor.green.cgColor
        
        view.layer.addSublayer(shape)
    }
    
    func drawThirdConnectionStick(_ shape: CAShapeLayer,
                                  _ view: UIView,
                                  _ selfWidth: CGFloat,
                                  _ selfHeight: CGFloat) {
        let thirdConnectionStickPath = UIBezierPath()
        thirdConnectionStickPath.move(to: CGPoint(x: selfWidth - 2,
                                                   y: selfHeight - 2))
        thirdConnectionStickPath.addLine(to: CGPoint(x: selfWidth - 2,
              
                                                     y: selfHeight / 2))
        shape.path = thirdConnectionStickPath.cgPath
        shape.lineWidth = 4
        shape.lineCap = .round
        shape.strokeColor = UIColor.green.cgColor
        
        view.layer.addSublayer(shape)
    }
}
