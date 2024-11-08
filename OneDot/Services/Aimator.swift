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
                           _ gradient: CAGradientLayer,
                              delegate: CAAnimationDelegate) {
        
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        rotation.duration = 1.5
        rotation.repeatCount = 1
        rotation.fromValue = 0
        rotation.toValue = .pi * 2.0
        rotation.delegate = delegate
        
        let test = CABasicAnimation(keyPath: "opacity")
        test.duration = 1.5
        test.fromValue = 1
        test.toValue = 1
        test.delegate = delegate
        
        logo.layer.add(test, forKey: nil)
        
        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 0
        opacity.toValue = 1
        opacity.duration = 1.5
        
        gradient.add(opacity, forKey: nil)
        
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

    



