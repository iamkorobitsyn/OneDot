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
    
    //MARK: - TabBar
    
    func drawTabBarButtonsLineSeparator(shape: CAShapeLayer, view: UIView) {
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: .barWidth / 2, y: 15))
        path.addLine(to: CGPoint(x: .barWidth / 2 , y: 15 + 65))
        shape.path = path.cgPath
        shape.lineWidth = 0.5
        shape.lineCap = .round
        shape.strokeColor = UIColor.white.cgColor
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
        shape.fillColor = UIColor.myPaletteGold.cgColor
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
    
    //MARK: - MetricsPanelCell
    
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
