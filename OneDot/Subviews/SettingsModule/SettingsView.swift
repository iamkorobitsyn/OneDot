//
//  SettingsView.swift
//  OneDot
//
//  Created by Александр Коробицын on 22.11.2024.
//

import UIKit

class SettingsView: UIVisualEffectView {
  
    
    //MARK: - Init
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        
        setViews()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

    }
    
}

