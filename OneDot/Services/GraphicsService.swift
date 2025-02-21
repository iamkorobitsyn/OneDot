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
        case headerSingleShape
        case footerSingleShape
        case pickerSingleShape
        case pickerDoubleShape
        case bodyCrossShape
        case dynamicDescriptionShape(descriptionCount: Int)
    }
    

    //MARK: - Shapes
    
    
    func drawShape(shape: CAShapeLayer, shapeType: ShapeType, view: UIView) {
        
        let path = UIBezierPath()
        
        switch shapeType {
        case .headerSingleShape:
            path.move(to: CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2 - 15))
            path.addLine(to: CGPoint(x: view.bounds.width / 2 , y: view.bounds.height / 2 + 15))
            shape.strokeColor = UIColor.myPaletteGray.cgColor
            
        case .footerSingleShape:
            path.move(to: CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2 - 30))
            path.addLine(to: CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2 + 30))
            shape.strokeColor = UIColor.white.cgColor
            
        case .pickerSingleShape:
            path.move(to: CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2 - 10))
            path.addLine(to: CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2 + 10))
            shape.strokeColor = UIColor.myPaletteGray.cgColor
            
        case .pickerDoubleShape:
            path.move(to: CGPoint(x: view.bounds.width / 3, y: view.bounds.height / 2 - 10))
            path.addLine(to: CGPoint(x: view.bounds.width / 3, y: view.bounds.height / 2 + 10))
            path.move(to: CGPoint(x: view.bounds.width / 3 * 2, y: view.bounds.height / 2 - 10))
            path.addLine(to: CGPoint(x: view.bounds.width / 3 * 2, y: view.bounds.height / 2 + 10))
            shape.strokeColor = UIColor.myPaletteGray.cgColor
            
        case .bodyCrossShape:
            path.move(to: CGPoint(x: .barWidth / 2.16 - 5, y: 39))
            path.addLine(to: CGPoint(x: .barWidth - (.barWidth / 2.16) - 5, y: 69))
            path.move(to: CGPoint(x: .barWidth - (.barWidth / 2.16) - 5, y: 39))
            path.addLine(to: CGPoint(x: .barWidth / 2.16 - 5, y: 69))
            shape.strokeColor = UIColor.white.cgColor
            
        case .dynamicDescriptionShape(descriptionCount: let descriptionCount):
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
    
    
    
    func splashScreenAnimate(_ frontLayer: CALayer,
                             _ backLayer: CAGradientLayer,
                             _ logoLayer: UIView,
                             delegate: CAAnimationDelegate) {
        
       
        var animations: [CABasicAnimation] = []
        
        let frontLayerOpacity = CABasicAnimation(keyPath: "opacity")
        frontLayerOpacity.beginTime = 0
        frontLayerOpacity.fromValue = 1
        frontLayerOpacity.toValue = 0
        frontLayerOpacity.duration = 1
        
        animations.append(frontLayerOpacity)
        
        let frontLayerDelay = CABasicAnimation(keyPath: "opacity")
        frontLayerDelay.beginTime = 1
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
        backLayerOpacity.duration = 0.50
        backLayerOpacity.fillMode = .forwards
        backLayerOpacity.isRemovedOnCompletion = false
        
        let frontLayerAnimationGroup = CAAnimationGroup()
        frontLayerAnimationGroup.animations = animations
        frontLayerAnimationGroup.duration = 1.5
        frontLayerAnimationGroup.fillMode = .forwards
        frontLayerAnimationGroup.isRemovedOnCompletion = false
        frontLayerAnimationGroup.delegate = delegate

        frontLayer.add(frontLayerAnimationGroup, forKey: "opacityAnimations")
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
