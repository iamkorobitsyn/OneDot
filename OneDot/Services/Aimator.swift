//
//  Aimator.swift
//  OneDot
//
//  Created by Александр Коробицын on 28.09.2023.
//

import Foundation
import UIKit

class Animator {
    
    static let shared = Animator()
    
    private init() {}
    
    //MARK: - SplashScreen
    
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
    
    //MARK: - TabBarView
    
    func AnimateStartIcon(_ layer: CALayer) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1
        animation.toValue = 0
        animation.duration = 0.7
        animation.repeatCount = .infinity
        layer.add(animation, forKey: nil)
    }
    
    func tabBarHide(_ view: UIView, _ delegate: CAAnimationDelegate) {
        
        let animatoonList = CAAnimationGroup()
        
        let transform = CABasicAnimation(keyPath: "transform.translation.y")
        transform.duration = 0.2
        transform.fromValue = 0
        transform.toValue = 120
        transform.delegate = delegate
        view.layer.add(transform, forKey: nil)
        
        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.beginTime = 0.2
        opacity.duration = 0.5
        opacity.fromValue = 0
        opacity.toValue = 0
        
        animatoonList.animations = [transform, opacity]
        animatoonList.duration = 0.7
        
        view.layer.add(animatoonList, forKey: nil)
        
    }
    
    func tabBarShow(_ view: UIView) {
        
        let animation = CABasicAnimation(keyPath: "transform.translation.y")
        animation.duration = 0.2
        animation.fromValue = 120
        animation.toValue = 0
        view.layer.add(animation, forKey: nil)
        
    }
    
    //MARK: - GPSView
    
        func animateGPSCursor(_ shape: UIImageView) {
            let animation = CABasicAnimation(keyPath: "opacity")
            animation.duration = 1.5
            animation.fromValue = 0.6
            animation.toValue = 1
            animation.repeatCount = .infinity
            shape.layer.add(animation, forKey: nil)
        }
    
    //MARK: - MetronomePillinbg
    
    
    func pillingBPM(_ shape: CAShapeLayer) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.duration = 0.35
        animation.fromValue = 1
        animation.toValue = 0
        shape.add(animation, forKey: nil)
    }
    
}

    



