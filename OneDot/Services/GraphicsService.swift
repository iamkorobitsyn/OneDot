//
//  Shaper.swift
//  OneDot
//
//  Created by Александр Коробицын on 28.09.2023.
//

import Foundation
import UIKit

class GraphicsService {
    
    static let shared = GraphicsService()
    
    private init() {}
    
    enum ShapeType {
        case headerSingleSeparator
        case workoutSingleSeparator
        case footerSingleSeparator
        case pickerSingleSeparator
        case pickerDoubleSeparator
        case noteCellRedLine
        case crossSeparator(color: UIColor)
        case dynamicDescriptionSeparator(descriptionCount: Int)
    }
    

    //MARK: - Shapes
    
    
    func drawShape(shape: CAShapeLayer, shapeType: ShapeType, view: UIView) {
        
        let path = UIBezierPath()
        
        switch shapeType {
        case .headerSingleSeparator:
            path.move(to: CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2 - 15))
            path.addLine(to: CGPoint(x: view.bounds.width / 2 , y: view.bounds.height / 2 + 15))
            shape.strokeColor = UIColor.myPaletteGray.cgColor
            
        case .workoutSingleSeparator:
            path.move(to: CGPoint(x: view.bounds.width / 2 - 30, y: view.bounds.height / 2))
            path.addLine(to: CGPoint(x: view.bounds.width / 2 + 30, y: view.bounds.height / 2))
            shape.strokeColor = UIColor.white.cgColor
            
        case .footerSingleSeparator:
            path.move(to: CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2 - 30))
            path.addLine(to: CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2 + 30))
            shape.strokeColor = UIColor.white.cgColor
            
        case .pickerSingleSeparator:
            path.move(to: CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2 - 10))
            path.addLine(to: CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2 + 10))
            shape.strokeColor = UIColor.myPaletteGray.cgColor
            
        case .pickerDoubleSeparator:
            path.move(to: CGPoint(x: view.bounds.width / 3, y: view.bounds.height / 2 - 10))
            path.addLine(to: CGPoint(x: view.bounds.width / 3, y: view.bounds.height / 2 + 10))
            path.move(to: CGPoint(x: view.bounds.width / 3 * 2, y: view.bounds.height / 2 - 10))
            path.addLine(to: CGPoint(x: view.bounds.width / 3 * 2, y: view.bounds.height / 2 + 10))
            shape.strokeColor = UIColor.myPaletteGray.cgColor
               
        case .noteCellRedLine:
            path.move(to: CGPoint(x: view.bounds.width - 57, y: view.bounds.height / 2 - 5))
            path.addLine(to: CGPoint(x: view.bounds.width - 57, y: view.bounds.height / 2 + 25))
            shape.strokeColor = UIColor.red.withAlphaComponent(0.5).cgColor
            
        case .crossSeparator(let color):
            path.move(to: CGPoint(x: view.bounds.width / 2 + 15, y: view.bounds.height / 2 - 15))
            path.addLine(to: CGPoint(x: view.bounds.width - (view.bounds.width / 2) - 15, y: view.bounds.height / 2 + 15))
            path.move(to: CGPoint(x: view.bounds.width - (view.bounds.width / 2) - 15, y: view.bounds.height / 2 - 15))
            path.addLine(to: CGPoint(x: view.bounds.width / 2 + 15, y: view.bounds.height / 2 + 15))
            shape.strokeColor = color.cgColor
            
        case .dynamicDescriptionSeparator(descriptionCount: let descriptionCount):
            path.move(to: CGPoint(x: .barWidth / 2, y:  76))
            path.addLine(to: CGPoint(x: .barWidth / 2 , y: 76 + CGFloat(descriptionCount * 30)))
            shape.strokeColor = UIColor.myPaletteGray.cgColor
        }
        
        shape.path = path.cgPath
        shape.lineWidth = 0.5
        shape.lineCap = .round
        view.layer.addSublayer(shape)
    }
    
    //MARK: - Animations
    
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
    
    
    
    func splashAnimate(frontLayer: CALayer, backLayer: CAGradientLayer, logoLayer: UIView) {
        var animations: [CABasicAnimation] = []
        
        let frontLayerOpacity = CABasicAnimation(keyPath: "opacity")
        frontLayerOpacity.beginTime = 0
        frontLayerOpacity.fromValue = 1
        frontLayerOpacity.toValue = 0
        frontLayerOpacity.duration = 1.5
        
        animations.append(frontLayerOpacity)
        
        let frontLayerDelay = CABasicAnimation(keyPath: "opacity")
        frontLayerDelay.beginTime = 1.5
        frontLayerDelay.fromValue = 0
        frontLayerDelay.toValue = 0
        frontLayerDelay.duration = 0.5
        frontLayerDelay.fillMode = .forwards
        frontLayerDelay.isRemovedOnCompletion = false
        
        animations.append(frontLayerDelay)
        
        let backLayerOpacity = CABasicAnimation(keyPath: "opacity")
        backLayerOpacity.beginTime = CACurrentMediaTime() + 1
        backLayerOpacity.fromValue = 1
        backLayerOpacity.toValue = 0
        backLayerOpacity.duration = 0.5
        backLayerOpacity.fillMode = .forwards
        backLayerOpacity.isRemovedOnCompletion = false
        
        let frontLayerAnimationGroup = CAAnimationGroup()
        frontLayerAnimationGroup.animations = animations
        frontLayerAnimationGroup.duration = 2
        frontLayerAnimationGroup.fillMode = .forwards
        frontLayerAnimationGroup.isRemovedOnCompletion = false

        frontLayer.add(frontLayerAnimationGroup, forKey: "")
        backLayer.add(backLayerOpacity, forKey: "")
        logoLayer.layer.add(backLayerOpacity, forKey: "")
    }

    
    func AnimateStartIcon(_ layer: CALayer) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1
        animation.toValue = 0
        animation.duration = 0.7
        animation.repeatCount = .infinity
        layer.add(animation, forKey: nil)
    }

    
    
    func animateLocator(_ view: UIView) {
        
        let animatoonList = CAAnimationGroup()
        
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.duration = 2
        animation.fromValue = 1
        animation.toValue = 0.4
        
        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.beginTime = 2
        opacity.duration = 2
        opacity.fromValue = 0.4
        opacity.toValue = 1
        
        animatoonList.animations = [animation, opacity]
        animatoonList.duration = 4
        animatoonList.repeatCount = .infinity
        
        view.layer.add(animatoonList, forKey: nil)

    }
}
