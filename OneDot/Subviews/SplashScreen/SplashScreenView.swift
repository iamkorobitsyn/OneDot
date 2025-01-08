//
//  GreetingLoadingView.swift
//  OneDot
//
//  Created by Александр Коробицын on 27.09.2023.
//

import Foundation
import UIKit

class SplashScreenView: UIView {
    
    let frontLayer: CALayer = CALayer()
    let gradientBackLayer: CAGradientLayer = CAGradientLayer()
    let launchLogo: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setViews()
        setConstraints()
        
    }
    
    //MARK: - SetViews
    
    private func setViews() {
        
        backgroundColor = .none
        
        gradientBackLayer.locations = [0.0, 0.4]
        gradientBackLayer.frame = CGRect(x: 0,
                                         y: 0,
                                         width: UIScreen.main.bounds.width,
                                         height: UIScreen.main.bounds.height)
        
        frontLayer.backgroundColor = UIColor.black.cgColor
        frontLayer.frame = CGRect(x: 0,
                                  y: 0,
                                  width: UIScreen.main.bounds.width,
                                  height: UIScreen.main.bounds.height)
        
        gradientBackLayer.colors = [UIColor.white.cgColor,
                                    UIColor.myPaletteBlue.cgColor]
        
        launchLogo.image = UIImage(named: "screenLogo")
        
        layer.insertSublayer(gradientBackLayer, at: 0)
        layer.insertSublayer(frontLayer, at: 1)
        addSubview(launchLogo)
        
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        launchLogo.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            launchLogo.centerXAnchor.constraint(equalTo: centerXAnchor),
            launchLogo.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

