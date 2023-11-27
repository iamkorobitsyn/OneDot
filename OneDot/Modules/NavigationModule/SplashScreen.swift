//
//  GreetingLoadingView.swift
//  OneDot
//
//  Created by Александр Коробицын on 27.09.2023.
//

import Foundation
import UIKit

class SplashScreen: UIView {
    
    let launchLogo: UIImageView = UIImageView()
    let logoContainer: UIView = UIView()
    let gradientLayer: CAGradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setViews()
        setConstraints()
    
    }
    
    //MARK: - SetViews
    
    private func setViews() {
        backgroundColor = .black
        
        layer.addSublayer(gradientLayer)
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = CGRect(x: 0,
                                     y: 0,
                                     width: UIScreen.main.bounds.width,
                                     height: UIScreen.main.bounds.height)
        gradientLayer.colors =
        [UIColor.currentColorSet.mainDynamicColor.cgColor,
         UIColor.currentColorSet.tabBarColor.cgColor]
        
        addSubview(logoContainer)
        logoContainer.backgroundColor = .none
        
        logoContainer.addSubview(launchLogo)
        launchLogo.image = UIImage(named: "launchScreenLogo")
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        launchLogo.translatesAutoresizingMaskIntoConstraints = false
        logoContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            launchLogo.centerXAnchor.constraint(equalTo: centerXAnchor),
            launchLogo.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            logoContainer.widthAnchor.constraint(equalToConstant: 100),
            logoContainer.heightAnchor.constraint(equalToConstant: 100),
            logoContainer.topAnchor.constraint(equalTo: topAnchor,
                                                constant: UIScreen.main.bounds.height / 2 ),
            logoContainer.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                  constant: UIScreen.main.bounds.width / 2)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension SplashScreen: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        Animator.shared.splashScreenDamping(self)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            self.alpha = 0
        }
    }
    
}
