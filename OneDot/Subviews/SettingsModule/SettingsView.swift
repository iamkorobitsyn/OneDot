//
//  SettingsView.swift
//  OneDot
//
//  Created by Александр Коробицын on 22.11.2024.
//

import UIKit

class SettingsView: UIVisualEffectView {
    
    var buttonStateHandler: ((MainVC.Mode) -> Void)?
    
    enum Mode {
        case hide
    }
    
    private let hideButton: UIButton = UIButton()
  
    
    //MARK: - Init
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        
        setViews()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonPressed() {
        
    }


    //MARK: - SetViews
    
    private func setViews() {
        effect = UIBlurEffect(style: UIBlurEffect.Style.light)
        clipsToBounds = true
        isHidden = true
        
        layer.cornerRadius = 30
        layer.cornerCurve = .continuous
        layer.borderWidth = 0.3
        layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        
        contentView.addSubview(hideButton)

    }
    
    private func setConstraint() {
        hideButton.disableAutoresizingMask()
        
        NSLayoutConstraint.activate([
            
            hideButton.widthAnchor.constraint(equalToConstant: .iconSide),
            hideButton.heightAnchor.constraint(equalToConstant: .iconSide),
            hideButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            hideButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
}

