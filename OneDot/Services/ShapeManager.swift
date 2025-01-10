//
//  Shaper.swift
//  OneDot
//
//  Created by Александр Коробицын on 28.09.2023.
//

import Foundation
import UIKit

class ShapeManager {
    
    static let shared = ShapeManager()
    
    private init() {}
    
    //MARK: - MainView
    
    func drawViewGradient(layer: CALayer) {
        let topGradient = CAGradientLayer()
        let trailingGradient = CAGradientLayer()
        let bottomGradient = CAGradientLayer()
        let leadingGradient = CAGradientLayer()
        
        let frame = CGRect(x: 0, y: 0, width: layer.frame.width, height: layer.frame.height)
        [topGradient, trailingGradient, bottomGradient, leadingGradient].forEach({$0.frame = frame})
        
        let colors = [UIColor.black.cgColor, UIColor.black.withAlphaComponent(0).cgColor]
        [topGradient, trailingGradient, bottomGradient, leadingGradient].forEach({$0.colors = colors})
        
        topGradient.startPoint = CGPoint(x: 0, y: 0)
        topGradient.endPoint = CGPoint(x: 0, y: 0.4)
        
        trailingGradient.startPoint = CGPoint(x: 0, y: 0)
        trailingGradient.endPoint = CGPoint(x: 0.4, y: 0)
        
        bottomGradient.startPoint = CGPoint(x: 0, y: 1)
        bottomGradient.endPoint = CGPoint(x: 0, y: 0.6)
        
        leadingGradient.startPoint = CGPoint(x: 1, y: 0)
        leadingGradient.endPoint = CGPoint(x: 0.6, y: 0)
        
        layer.addSublayer(topGradient)
        layer.addSublayer(trailingGradient)
        layer.addSublayer(bottomGradient)
        layer.addSublayer(leadingGradient)
    }
    
    //MARK: - BottomBar
    
    func drawTabBarButtonsLineSeparator(shape: CAShapeLayer, view: UIView, color: UIColor) {
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: .barWidth / 2, y: 15))
        path.addLine(to: CGPoint(x: .barWidth / 2 , y: 15 + 65))
        shape.path = path.cgPath
        shape.lineWidth = 0.5
        shape.lineCap = .round
        shape.strokeColor = color.cgColor
        view.layer.addSublayer(shape)
        
    }
    
    func drawTabBarTopLineSeparator(shape: CAShapeLayer, view: UIView) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: .barWidth / 12, y: 0))
        path.addLine(to: CGPoint(x: .barWidth - .barWidth / 12 , y: 0))
        shape.path = path.cgPath
        shape.lineWidth = 0.5
        shape.lineCap = .round
        shape.strokeColor = UIColor.myPaletteGray.withAlphaComponent(0.7).cgColor
        view.layer.addSublayer(shape)
    }
    
    func drawTabBarNumbersLineSeparator(shape: CAShapeLayer, view: UIView) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: .barWidth / 2, y: 25))
        path.addLine(to: CGPoint(x: .barWidth / 2 , y: 25 + 45))
        shape.path = path.cgPath
        shape.lineWidth = 0.5
        shape.lineCap = .round
        shape.strokeColor = UIColor.myPaletteGray.cgColor
        view.layer.addSublayer(shape)
    }
    
    func drawTabBarNumbersTwoLineSeparator(shape: CAShapeLayer, view: UIView) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: .barWidth / 2 - .barWidth / 12 , y: 25))
        path.addLine(to: CGPoint(x: .barWidth / 2 - .barWidth / 12 , y: 25 + 45))
        path.move(to: CGPoint(x: .barWidth / 2 + .barWidth / 12, y: 25))
        path.addLine(to: CGPoint(x: .barWidth / 2 + .barWidth / 12 , y: 25 + 45))
        shape.path = path.cgPath
        shape.lineWidth = 0.5
        shape.lineCap = .round
        shape.strokeColor = UIColor.myPaletteGray.cgColor
        view.layer.addSublayer(shape)
    }
    
    
    
    
    //MARK: - HeaderBar
    
    func drawToolsStackSeparator(shape: CAShapeLayer, view: UIView) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: .barWidth / 2 + .barWidth / 4, y: 15))
        path.addLine(to: CGPoint(x: .barWidth / 2 + .barWidth / 4, y: 57))
        shape.path = path.cgPath
        shape.lineWidth = 0.5
        shape.lineCap = .round
        shape.strokeColor = UIColor.black.cgColor
        view.layer.addSublayer(shape)
    }
    
    func drawPickerViewDotSeparator(shape: CAShapeLayer, view: UIView) {
        let path = UIBezierPath(arcCenter: CGPoint(x: .barWidth / 2, y: 25),
                                radius: 3,
                                startAngle: 0,
                                endAngle: .pi * 2,
                                clockwise: true)
        shape.path = path.cgPath
        shape.fillColor = UIColor.lightGray.cgColor
        view.layer.addSublayer(shape)
    }
    
    //MARK: - HeaderBarLocator
    
    func drawLocatorDotShape(shape: CAShapeLayer, view: UIView) {
        let path = UIBezierPath(arcCenter: CGPoint(x: 6, y: 6),
                                radius: 1.5,
                                startAngle: 0,
                                endAngle: .pi * 2,
                                clockwise: true)
        shape.path = path.cgPath
        shape.fillColor = UIColor.green.cgColor
        view.layer.addSublayer(shape)
    }
    
    func drawLocatorFirstSircleShape(shape: CAShapeLayer, view: UIView) {
        let path = UIBezierPath(arcCenter: CGPoint(x: 6, y: 6),
                                radius: 6,
                                startAngle: 0,
                                endAngle: .pi * 2,
                                clockwise: true)
        shape.path = path.cgPath
        shape.fillColor = .none
        shape.lineWidth = 0.5
        shape.strokeColor = UIColor.green.cgColor
        view.layer.addSublayer(shape)
    }
    
    func drawLocatorSecondSircleShape(shape: CAShapeLayer, view: UIView) {
        let path = UIBezierPath(arcCenter: CGPoint(x: 6, y: 6),
                                radius: 9,
                                startAngle: 0,
                                endAngle: .pi * 2,
                                clockwise: true)
        shape.path = path.cgPath
        shape.fillColor = .none
        shape.lineWidth = 0.5
        shape.strokeColor = UIColor.green.withAlphaComponent(0.5).cgColor
        view.layer.addSublayer(shape)
    }
    
    //MARK: - MetricsPanelCell&ResultPanel
    
    func drawMetricsCellSeparator(shape: CAShapeLayer, view: UIView) {
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: view.frame.width / 2, y: view.frame.height / 2 - 20))
        path.addLine(to: CGPoint(x: view.frame.width / 2 , y: view.frame.height / 2 + 20))
        shape.path = path.cgPath
        shape.lineWidth = 0.5
        shape.lineCap = .round
        shape.strokeColor = UIColor.myPaletteGray.cgColor
        view.layer.addSublayer(shape)
        
    }
    
    func drawResultSeparator(dual: Bool, shape: CAShapeLayer, view: UIView) {
        
        
        
        let path = UIBezierPath()
        if dual {
            let segment = (.barWidth - 100) / 3
            path.move(to: CGPoint(x: 50 + segment , y:  112))
            path.addLine(to: CGPoint(x: 50 + segment , y: 152))
            path.move(to: CGPoint(x: 50 + (segment * 2), y:  112))
            path.addLine(to: CGPoint(x: 50 + (segment * 2) , y: 152))
        } else {
            path.move(to: CGPoint(x: .barWidth / 2, y:  72))
            path.addLine(to: CGPoint(x: .barWidth / 2 , y: 192))
        }
        shape.path = path.cgPath
        shape.lineWidth = 0.5
        shape.lineCap = .round
        shape.strokeColor = UIColor.myPaletteGray.cgColor
        view.layer.addSublayer(shape)
        
    }
    
    //MARK: - WorkoutCell
    
    func drawWorkoutCellSeparators(shape: CAShapeLayer, view: UIView) {
        let path = UIBezierPath()
        
        // Первая линия (слева направо, под углом 45°)
        path.move(to: CGPoint(x: .barWidth / 2.16 - 5, y: 39)) // Начальная точка
        path.addLine(to: CGPoint(x: .barWidth - (.barWidth / 2.16) - 5, y: 69)) // Конечная точка

        // Вторая линия (справа налево, под углом -45°)
        path.move(to: CGPoint(x: .barWidth - (.barWidth / 2.16) - 5, y: 39)) // Начальная точка
        path.addLine(to: CGPoint(x: .barWidth / 2.16 - 5, y: 69)) // Конечная точка

        // Настройка `CAShapeLayer`
        shape.path = path.cgPath
        shape.lineWidth = 0.5
        shape.lineCap = .round
        shape.strokeColor = UIColor.white.cgColor
        
        // Добавление слоя на переданный `view`
        view.layer.addSublayer(shape)
    }
    
    
}
