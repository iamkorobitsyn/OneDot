//
//  MainBarBody.swift
//  OneDot
//
//  Created by Александр Коробицын on 26.11.2023.
//

import Foundation
import UIKit

class ToolsBarView: UIVisualEffectView, CAAnimationDelegate {
    
    private let skipButton: UIButton = UIButton()
    private let skipTitle: UILabel = UILabel()
    
    let calcuatorVC: CalculatorVC = CalculatorVC()
    let soundVC: SoundVC = SoundVC()
    let themesVC: ThemesVC = ThemesVC()
    let settingsVC: SettingsVC = SettingsVC()
    
    
    var showTabBarCompletion: ((Bool) -> ())?
    
    enum VCCases {
        case calculator,
             sound,
             themes,
             settings
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
        
        contentView.addSubview(soundVC.view)
        soundVC.view.frame = self.frame
        soundVC.view.isHidden = true
        
        contentView.addSubview(themesVC.view)
        themesVC.view.frame = self.frame
        themesVC.view.isHidden = true
        
        contentView.addSubview(settingsVC.view)
        settingsVC.view.frame = self.frame
        settingsVC.view.isHidden = true
        

        contentView.addSubview(skipButton)
        skipButton.backgroundColor = .clear
        skipButton.setBackgroundImage(UIImage(named: "toolsSkipIcon"), for: .normal)
        skipButton.setBackgroundImage(UIImage(named: "toolsSkipIcon"), for: .highlighted)
        skipButton.addTarget(self, action: #selector(skip), for: .touchUpInside)
        
        contentView.addSubview(skipTitle)
        skipTitle.textColor = .gray
        skipTitle.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        skipTitle.text = "Skip"
    }
    
    func showVC(_ VCCase: VCCases) {
        switch VCCase {
            
        case .calculator:
            calcuatorVC.view.isHidden = false
            soundVC.view.isHidden = true
            themesVC.view.isHidden = true
            settingsVC.view.isHidden = true
        case .sound:
            soundVC.view.isHidden = false
            themesVC.view.isHidden = true
            settingsVC.view.isHidden = true
            calcuatorVC.view.isHidden = true
        case .themes:
            themesVC.view.isHidden = false
            settingsVC.view.isHidden = true
            calcuatorVC.view.isHidden = true
            soundVC.view.isHidden = true
        case .settings:
            settingsVC.view.isHidden = false
            calcuatorVC.view.isHidden = true
            soundVC.view.isHidden = true
            themesVC.view.isHidden = true
        
        }
    }
    
    
    @objc private func skip() {
        showTabBarCompletion?(true)
        Animator.shared.MainBarBodyHide(self, self)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.isHidden = true
    }
    
    //MARK: - SetConstrains
    
    private func setConstraints() {
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            skipButton.widthAnchor.constraint(equalToConstant: 42),
            skipButton.heightAnchor.constraint(equalToConstant: 42),
            skipButton.topAnchor.constraint(equalTo:
                                            topAnchor, constant: 20),
            skipButton.trailingAnchor.constraint(equalTo:
                                            trailingAnchor,
                                            constant: -20),
            skipTitle.centerXAnchor.constraint(equalTo:
                                            skipButton.centerXAnchor),
            skipTitle.topAnchor.constraint(equalTo:
                                            skipButton.bottomAnchor,
                                            constant: 5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
