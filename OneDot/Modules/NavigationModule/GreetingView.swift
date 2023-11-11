//
//  GreetingLoadingView.swift
//  OneDot
//
//  Created by Александр Коробицын on 27.09.2023.
//

import Foundation
import UIKit

class GreetingView: UIView {
    
    let launchLogo: UIImageView = UIImageView()
    let logoSupportView: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setViews()
        setConstraints()
    
    }
    
    //MARK: - SetViews
    
    private func setViews() {
        backgroundColor = .sunriseDeepColor
        addSubview(logoSupportView)
        logoSupportView.backgroundColor = .none
        
        logoSupportView.addSubview(launchLogo)
        launchLogo.image = UIImage(named: "launchScreenLogo")
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        launchLogo.translatesAutoresizingMaskIntoConstraints = false
        logoSupportView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            launchLogo.centerXAnchor.constraint(equalTo: centerXAnchor),
            launchLogo.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            logoSupportView.widthAnchor.constraint(equalToConstant: 100),
            logoSupportView.heightAnchor.constraint(equalToConstant: 100),
            logoSupportView.topAnchor.constraint(equalTo: topAnchor,
                                                constant: UIScreen.main.bounds.height / 2 ),
            logoSupportView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                  constant: UIScreen.main.bounds.width / 2)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension GreetingView: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        Animator.shared.greetingViewOpacity(self)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            self.alpha = 0
        }
    }
    
}
