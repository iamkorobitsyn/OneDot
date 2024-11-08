//
//  MainBarBody.swift
//  OneDot
//
//  Created by Александр Коробицын on 26.11.2023.
//

import Foundation
import UIKit

class ToolsBarView: UIVisualEffectView, CAAnimationDelegate {
    
    let skipButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "additionalHideIcon"),
                                      for: .normal)
        return button
    }()

    
    let calcuatorVC: CalculatorVC = CalculatorVC()

    var showTabBarCompletion: ((Bool) -> ())?
    
    enum VCCases {
        case calculator,
             sound,
             themes
    }
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
   
        setViews()
        setConstraints()
        
    }
    
    //MARK: - SetViews
    
    private func setViews() {
        isHidden = true
        layer.borderWidth = 0.3
        layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        self.effect = UIBlurEffect(style: UIBlurEffect.Style.light)
        clipsToBounds = true
        layer.cornerRadius = 30
        layer.cornerCurve = .continuous

        contentView.addSubview(calcuatorVC.view)
        calcuatorVC.view.frame = self.frame
        calcuatorVC.view.isHidden = true
        

        contentView.addSubview(skipButton)
        skipButton.addTarget(self, action: #selector(skip), for: .touchUpInside)
    }
    
    func showVC(_ VCCase: VCCases) {
        switch VCCase {
            
        case .calculator:
            calcuatorVC.view.isHidden = false

            let section = UserDefaultsManager.shared.calculationsStatus
            calcuatorVC.setActiveSection(section: section)
        case .sound:
            calcuatorVC.view.isHidden = true
        case .themes:
            calcuatorVC.view.isHidden = true
            let section = UserDefaultsManager.shared.themesStatus
        }
    }
    
    
    @objc private func skip() {
        skipButton.isHidden = true
        showTabBarCompletion?(true)
        self.isHidden = true
//        Animator.shared.MainBarBodyHide(self, self)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
//        self.isHidden = true
    }
    
    //MARK: - SetConstrains
    
    private func setConstraints() {

        NSLayoutConstraint.activate([
            skipButton.widthAnchor.constraint(equalToConstant: 42),
            skipButton.heightAnchor.constraint(equalToConstant: 42),
            skipButton.topAnchor.constraint(equalTo:
                                            topAnchor, constant: 10),
            skipButton.trailingAnchor.constraint(equalTo:
                                            trailingAnchor,
                                            constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
