//
//  SettingsViewCell.swift
//  OneDot
//
//  Created by Александр Коробицын on 25.11.2024.
//

import Foundation
import UIKit

class SettingsViewCell: UITableViewCell {
    
    typealias UD = UserDefaultsManager
    
    enum Mode {
        case distanceSettings
        case autopauseSettings
        case countdownSettings
        case appleHealthSettings
    }
    
    var currentMode: Mode?
    
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
        currentMode = mode
        setViews(mode: mode)
        setConstraints(mode: mode)
    }
    
    @objc private func buttonTapped() {
        
        switch currentMode {
        case .distanceSettings:
            updateDistanceSettings()
        case .autopauseSettings:
            updateDistanceSettings()
        case .countdownSettings:
            updateDistanceSettings()
        case .appleHealthSettings:
            updateAppleHeathSettings()
        default:
            break
        }
    }
    
    private func updateDistanceSettings() {
        let value = UD.shared.settingsDistanceValue
        
        if value == "ml" {
            firstButton.setImage(UIImage(named: "DSKmActive"), for: .normal)
            secondButton.setImage(UIImage(named: "DSMlInactive"), for: .normal)
            UD.shared.settingsDistanceValue = "km"
        } else if value == "km" {
            firstButton.setImage(UIImage(named: "DSKmInactive"), for: .normal)
            secondButton.setImage(UIImage(named: "DSMlActive"), for: .normal)
            UD.shared.settingsDistanceValue = "ml"
        }
    }
    
    private func updateAppleHeathSettings() {
        let value = UD.shared.settingsAppleHealthValue
        print(value)
        
        if value {
            firstButton.setImage(UIImage(named: "DSCheckMarkActive"), for: .normal)
            secondButton.setImage(UIImage(named: "DSCancelInactive"), for: .normal)
            UD.shared.settingsAppleHealthValue = false
        } else {
            firstButton.setImage(UIImage(named: "DSCheckMarkInactive"), for: .normal)
            secondButton.setImage(UIImage(named: "DSCancelActive"), for: .normal)
            UD.shared.settingsAppleHealthValue = true
        }
    }
    
    //MARK: - SetViews
    
    private func setViews(mode: Mode) {
        
        contentView.addSubview(titleLabel)
        titleLabel.textAlignment = .center
        
        [firstButton, secondButton, thirdButton, fourthButton].forEach { button in
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
        
        switch mode {
            
        case .distanceSettings:
            titleLabel.text = "Distance"
            [firstButton, secondButton].forEach({contentView.addSubview($0)})
            
            let value = UD.shared.settingsDistanceValue
            firstButton.setImage(UIImage(named: value == "km" ? "DSKmActive" : "DSKmInactive"), for: .normal)
            secondButton.setImage(UIImage(named: value == "ml" ? "DSMlActive" : "DSMlInactive"), for: .normal)

        case .autopauseSettings:
            titleLabel.text = "Autopause"
            [firstButton, secondButton].forEach({contentView.addSubview($0)})
            
            let value = UD.shared.settingsAutopauseValue
            firstButton.setImage(UIImage(named: value ? "DSCheckMarkActive" : "DSCheckMarkInactive"), for: .normal)
            secondButton.setImage(UIImage(named: value ? "DSCancelInactive" : "DSCancelActive"), for: .normal)
            
        case .countdownSettings:
            titleLabel.text = "Countdown"
            [firstButton, secondButton, thirdButton, fourthButton].forEach({contentView.addSubview($0)})
            
            let value = UD.shared.settingsCountdownValue
            firstButton.setImage(UIImage(named: value == 0 ? "DSCancelActive" : "DSCancelInactive"), for: .normal)
            secondButton.setImage(UIImage(named: value == 3 ? "DS3Active" : "DS3Inactive"), for: .normal)
            thirdButton.setImage(UIImage(named: value == 6 ? "DS6Active" : "DS6Inactive"), for: .normal)
            fourthButton.setImage(UIImage(named: value == 9 ? "DS9Active" : "DS9Inactive"), for: .normal)
            
        case .appleHealthSettings:
            titleLabel.text = "AppleHealth"
            [firstButton, secondButton].forEach({contentView.addSubview($0)})
            
            let value = UD.shared.settingsAppleHealthValue
            firstButton.setImage(UIImage(named: value ? "DSCheckMarkActive" : "DSCheckMarkInactive"), for: .normal)
            secondButton.setImage(UIImage(named: value ? "DSCancelInactive" : "DSCancelActive"), for: .normal)
        }
    }
    
    //MARK: - SetConstrains
    
    private func setConstraints(mode: Mode) {
        
        [titleLabel, firstButton, secondButton, thirdButton, fourthButton].forEach({$0.disableAutoresizingMask()})
        
        switch mode {
        case .distanceSettings, .autopauseSettings, .appleHealthSettings:
            
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
                
                thirdButton.widthAnchor.constraint(equalToConstant: .iconSide),
                thirdButton.heightAnchor.constraint(equalToConstant: .iconSide),
                thirdButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
                thirdButton.topAnchor.constraint(equalTo: centerYAnchor, constant: 10),
                
                fourthButton.widthAnchor.constraint(equalToConstant: .iconSide),
                fourthButton.heightAnchor.constraint(equalToConstant: .iconSide),
                fourthButton.trailingAnchor.constraint(equalTo: thirdButton.leadingAnchor, constant: -20),
                fourthButton.centerYAnchor.constraint(equalTo: thirdButton.centerYAnchor)
            ])
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
