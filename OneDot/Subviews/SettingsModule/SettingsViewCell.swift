//
//  SettingsViewCell.swift
//  OneDot
//
//  Created by Александр Коробицын on 25.11.2024.
//

import Foundation
import UIKit

class SettingsViewCell: UITableViewCell {
    
    enum Mode {
        case distanceSettings
        case autopauseSettings
        case countdownSettings
        case appleHealthSettings
    }
    
    let firstButton: UIButton = UIButton()
    let secondButton: UIButton = UIButton()
    let thirdButton: UIButton = UIButton()
    let fourthButton: UIButton = UIButton()
    
    let titleLabel: UILabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    func activateMode(mode: Mode) {
        switch mode {
            
        case .distanceSettings:
            setViews(mode: .distanceSettings)
            titleLabel.text = "Distance"
            firstButton.setImage(UIImage(named: "DSKmActive"), for: .normal)
            secondButton.setImage(UIImage(named: "DSMlInactive"), for: .normal)
        case .autopauseSettings:
            titleLabel.text = "Autopause"
            firstButton.setImage(UIImage(named: "DSCheckMarkActive"), for: .normal)
            secondButton.setImage(UIImage(named: "DSCheckMarkInactive"), for: .normal)
            setViews(mode: .autopauseSettings)
        case .countdownSettings:
            titleLabel.text = "Countdown"
            firstButton.setImage(UIImage(named: "DSCancelActive"), for: .normal)
            secondButton.setImage(UIImage(named: "DS3Inactive"), for: .normal)
            thirdButton.setImage(UIImage(named: "DS6Inactive"), for: .normal)
            fourthButton.setImage(UIImage(named: "DS9Inactive"), for: .normal)
            setViews(mode: .countdownSettings)
        case .appleHealthSettings:
            titleLabel.text = "AppleHealth"
            firstButton.setImage(UIImage(named: "DSCheckMarkActive"), for: .normal)
            secondButton.setImage(UIImage(named: "DSCheckMarkInactive"), for: .normal)
            setViews(mode: .appleHealthSettings)
        }
        
    }
    
    private func setViews(mode: Mode) {
        switch mode {
            
        case .distanceSettings, .autopauseSettings, .appleHealthSettings:
            titleLabel.textAlignment = .center
            [firstButton, secondButton, titleLabel].forEach { button in
                addSubview(button)
                button.disableAutoresizingMask()
            }
            
            NSLayoutConstraint.activate([
                titleLabel.widthAnchor.constraint(equalToConstant: 200),
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                
                secondButton.widthAnchor.constraint(equalToConstant: .iconSide),
                secondButton.heightAnchor.constraint(equalToConstant: .iconSide),
                secondButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
                secondButton.centerYAnchor.constraint(equalTo: centerYAnchor),
                
                firstButton.widthAnchor.constraint(equalToConstant: .iconSide),
                firstButton.heightAnchor.constraint(equalToConstant: .iconSide),
                firstButton.trailingAnchor.constraint(equalTo: secondButton.leadingAnchor, constant: -20),
                firstButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            ])

        case .countdownSettings:
            titleLabel.textAlignment = .center
            [firstButton, secondButton, thirdButton, fourthButton, titleLabel].forEach { button in
                addSubview(button)
                button.disableAutoresizingMask()
            }
            
            NSLayoutConstraint.activate([
                titleLabel.widthAnchor.constraint(equalToConstant: 200),
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                
                secondButton.widthAnchor.constraint(equalToConstant: .iconSide),
                secondButton.heightAnchor.constraint(equalToConstant: .iconSide),
                secondButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
                secondButton.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -10),
                
                firstButton.widthAnchor.constraint(equalToConstant: .iconSide),
                firstButton.heightAnchor.constraint(equalToConstant: .iconSide),
                firstButton.trailingAnchor.constraint(equalTo: secondButton.leadingAnchor, constant: -20),
                firstButton.centerYAnchor.constraint(equalTo: secondButton.centerYAnchor),
                
                fourthButton.widthAnchor.constraint(equalToConstant: .iconSide),
                fourthButton.heightAnchor.constraint(equalToConstant: .iconSide),
                fourthButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
                fourthButton.topAnchor.constraint(equalTo: centerYAnchor, constant: 10),
                
                thirdButton.widthAnchor.constraint(equalToConstant: .iconSide),
                thirdButton.heightAnchor.constraint(equalToConstant: .iconSide),
                thirdButton.trailingAnchor.constraint(equalTo: fourthButton.leadingAnchor, constant: -20),
                thirdButton.centerYAnchor.constraint(equalTo: fourthButton.centerYAnchor)
            ])

        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
