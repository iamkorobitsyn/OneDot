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
    
    //MARK: - GreetingViews
    
    func splashScreenAnimate(_ logo: UIView,
                             _ frontLayer: CALayer,
                             _ backLayer: CAGradientLayer,
                             delegate: CAAnimationDelegate) {
        
       
        var animations: [CABasicAnimation] = []
        
        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.beginTime = 0
        opacity.fromValue = 1
        opacity.toValue = 0
        opacity.duration = 1
        
        animations.append(opacity)
        
        let opacity2 = CABasicAnimation(keyPath: "opacity")
        opacity2.beginTime = 1
        opacity2.fromValue = 0
        opacity2.toValue = 0
        opacity2.duration = 0.5
        
        animations.append(opacity2)
        
        let opacity3 = CABasicAnimation(keyPath: "opacity")
        opacity3.beginTime = CACurrentMediaTime() + 1
        opacity3.fromValue = 1
        opacity3.toValue = 0
        opacity3.duration = 0.55
        backLayer.add(opacity3, forKey: "")
        logo.layer.add(opacity3, forKey: "")
        
        
        
        
        
        // Группа анимаций (если нужно выполнить их параллельно)
        let group = CAAnimationGroup()
        group.animations = animations
        group.duration = 1.5  // Общая длительность (для всех анимаций)
        group.fillMode = .forwards
        group.isRemovedOnCompletion = false
        
        group.delegate = delegate
        
        // Применяем группу анимаций к frontLayer
        frontLayer.add(group, forKey: "opacityAnimations")
        
    }
    
    func splashScreenDamping(_ view: UIView) {
        let opacity = CABasicAnimation(keyPath: "opacity")
        
        opacity.fromValue = 1
        opacity.toValue = 0
        opacity.duration = 0.2
        
        view.layer.add(opacity, forKey: nil)
    }
    
    //MARK: - TabBarView
    
    func AnimateStartButton(_ imageView: UIImageView) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1
        animation.toValue = 0
        animation.duration = 1
        animation.repeatCount = .infinity
        imageView.layer.add(animation, forKey: nil)
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

    



