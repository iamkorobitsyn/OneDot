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
    
    let topLButton: UIButton = UIButton()
    let topRButton: UIButton = UIButton()
    let bottomLButton: UIButton = UIButton()
    let bottomRButton: UIButton = UIButton()
    
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
    
    //MARK: - Buttons
    
    @objc private func buttonTapped(_ sender: UIButton) {
        
        switch currentMode {
        case .distanceSettings:
            updateDistanceSettings(sender)
        case .autopauseSettings:
            updateAutopauseSettings(sender)
        case .countdownSettings:
            updateCountdownSettings(sender)
        case .appleHealthSettings:
            updateAppleHeathSettings(sender)
        default:
            break
        }
    }
    
    private func updateButtonsStates(active: UIButton, inactive: [UIButton],
                                     activeImg: String, inactiveImg: [String]) {
        active.isUserInteractionEnabled = false
        inactive.forEach({ $0.isUserInteractionEnabled = true })
        
        active.setImage(UIImage(named: activeImg), for: .normal)
        
        for i in 0..<inactive.count {
            if i < inactiveImg.count {
                inactive[i].setImage(UIImage(named: inactiveImg[i]), for: .normal)
            }
        }
    }
    
    private func updateButtonsImages(active: String, inactive: [String]) {
        
    }
    
    private func updateDistanceSettings(_ sender: UIButton) {
        switch sender {
        case topLButton:
            UD.shared.settingsDistanceValue = "km"
            updateButtonsStates(active: topLButton, inactive: [topRButton],
                                activeImg: "DSKmActive", inactiveImg: ["DSMlInactive"])
        case topRButton:
            UD.shared.settingsDistanceValue = "ml"
            updateButtonsStates(active: topRButton, inactive: [topLButton],
                                activeImg: "DSMlActive", inactiveImg: ["DSKmInactive"])
        default:
            break
        }
    }
    
    private func updateAutopauseSettings(_ sender: UIButton) {
        switch sender {
        case topLButton:
            UD.shared.settingsAutopauseValue = true
            updateButtonsStates(active: topLButton, inactive: [topRButton],
                                activeImg: "DSCheckMarkActive", inactiveImg: ["DSCancelInactive"])
        case topRButton:
            UD.shared.settingsAutopauseValue = false
            updateButtonsStates(active: topRButton, inactive: [topLButton],
                                activeImg: "DSCancelActive", inactiveImg: ["DSCheckMarkInactive"])
        default:
            break
        }
    }
    
    private func updateCountdownSettings(_ sender: UIButton) {
        switch sender {
        case topLButton:
            UD.shared.settingsCountdownValue = 0
            updateButtonsStates(active: topLButton, inactive: [topRButton, bottomLButton, bottomRButton],
                                activeImg: "DSCancelActive", inactiveImg: ["DS3Inactive", "DS6Inactive", "DS9Inactive"])
        case topRButton:
            UD.shared.settingsCountdownValue = 3
            updateButtonsStates(active: topRButton, inactive: [topLButton, bottomLButton, bottomRButton],
                                activeImg: "DS3Active", inactiveImg: ["DSCancelInactive", "DS6Inactive", "DS9Inactive"])
        case bottomLButton:
            UD.shared.settingsCountdownValue = 6
            updateButtonsStates(active: bottomLButton, inactive: [topLButton, topRButton, bottomRButton],
                                activeImg: "DS6Active", inactiveImg: ["DSCancelInactive", "DS3Inactive", "DS9Inactive"])
        case bottomRButton:
            UD.shared.settingsCountdownValue = 9
            updateButtonsStates(active: bottomRButton, inactive: [topLButton, topRButton, bottomLButton],
                                activeImg: "DS9Active", inactiveImg: ["DSCancelInactive", "DS3Inactive", "DS6Inactive"])
        default:
            break
        }
    }
    
    private func updateAppleHeathSettings(_ sender: UIButton) {
        switch sender {
        case topLButton:
            UD.shared.settingsAppleHealthValue = true
            updateButtonsStates(active: topLButton, inactive: [topRButton],
                                activeImg: "DSCheckMarkActive", inactiveImg: ["DSCancelInactive"])
        case topRButton:
            UD.shared.settingsAppleHealthValue = false
            updateButtonsStates(active: topRButton, inactive: [topLButton],
                                activeImg: "DSCancelActive", inactiveImg: ["DSCheckMarkInactive"])
        default:
            break
        }
    }
    
    //MARK: - SetViews
    
    private func setViews(mode: Mode) {
        
        contentView.addSubview(titleLabel)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .light, width: .compressed)
        titleLabel.textColor = .myPaletteGray
        
        [topLButton, topRButton, bottomLButton, bottomRButton].forEach { button in
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        }
        
        switch mode {
            
        case .distanceSettings:
            titleLabel.text = "Distance"
            [topLButton, topRButton].forEach({contentView.addSubview($0)})
            
            let value = UD.shared.settingsDistanceValue
            topLButton.setImage(UIImage(named: value == "km" ? "DSKmActive" : "DSKmInactive"), for: .normal)
            topRButton.setImage(UIImage(named: value == "ml" ? "DSMlActive" : "DSMlInactive"), for: .normal)

        case .autopauseSettings:
            titleLabel.text = "Autopause"
            [topLButton, topRButton].forEach({contentView.addSubview($0)})
            
            let value = UD.shared.settingsAutopauseValue
            topLButton.setImage(UIImage(named: value ? "DSCheckMarkActive" : "DSCheckMarkInactive"), for: .normal)
            topRButton.setImage(UIImage(named: value ? "DSCancelInactive" : "DSCancelActive"), for: .normal)
            
        case .countdownSettings:
            titleLabel.text = "Countdown"
            [topLButton, topRButton, bottomLButton, bottomRButton].forEach({contentView.addSubview($0)})
            
            let value = UD.shared.settingsCountdownValue
            topLButton.setImage(UIImage(named: value == 0 ? "DSCancelActive" : "DSCancelInactive"), for: .normal)
            topRButton.setImage(UIImage(named: value == 3 ? "DS3Active" : "DS3Inactive"), for: .normal)
            bottomLButton.setImage(UIImage(named: value == 6 ? "DS6Active" : "DS6Inactive"), for: .normal)
            bottomRButton.setImage(UIImage(named: value == 9 ? "DS9Active" : "DS9Inactive"), for: .normal)
            
        case .appleHealthSettings:
            titleLabel.text = "AppleHealth"
            [topLButton, topRButton].forEach({contentView.addSubview($0)})
            
            let value = UD.shared.settingsAppleHealthValue
            topLButton.setImage(UIImage(named: value ? "DSCheckMarkActive" : "DSCheckMarkInactive"), for: .normal)
            topRButton.setImage(UIImage(named: value ? "DSCancelInactive" : "DSCancelActive"), for: .normal)
        }
    }
    
    //MARK: - SetConstrains
    
    private func setConstraints(mode: Mode) {
        
        [titleLabel, topLButton, topRButton, bottomLButton, bottomRButton].forEach({$0.disableAutoresizingMask()})
        
        switch mode {
        case .distanceSettings, .autopauseSettings, .appleHealthSettings:
            
            NSLayoutConstraint.activate([
                titleLabel.widthAnchor.constraint(equalToConstant: 200),
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                
                topRButton.widthAnchor.constraint(equalToConstant: .iconSide),
                topRButton.heightAnchor.constraint(equalToConstant: .iconSide),
                topRButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
                topRButton.centerYAnchor.constraint(equalTo: centerYAnchor),
                
                topLButton.widthAnchor.constraint(equalToConstant: .iconSide),
                topLButton.heightAnchor.constraint(equalToConstant: .iconSide),
                topLButton.trailingAnchor.constraint(equalTo: topRButton.leadingAnchor, constant: -20),
                topLButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            ])
        case .countdownSettings:
            
            NSLayoutConstraint.activate([
                titleLabel.widthAnchor.constraint(equalToConstant: 200),
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                
                topRButton.widthAnchor.constraint(equalToConstant: .iconSide),
                topRButton.heightAnchor.constraint(equalToConstant: .iconSide),
                topRButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
                topRButton.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -10),
                
                topLButton.widthAnchor.constraint(equalToConstant: .iconSide),
                topLButton.heightAnchor.constraint(equalToConstant: .iconSide),
                topLButton.trailingAnchor.constraint(equalTo: topRButton.leadingAnchor, constant: -20),
                topLButton.centerYAnchor.constraint(equalTo: topRButton.centerYAnchor),
                
                bottomLButton.widthAnchor.constraint(equalToConstant: .iconSide),
                bottomLButton.heightAnchor.constraint(equalToConstant: .iconSide),
                bottomLButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
                bottomLButton.topAnchor.constraint(equalTo: centerYAnchor, constant: 10),
                
                bottomRButton.widthAnchor.constraint(equalToConstant: .iconSide),
                bottomRButton.heightAnchor.constraint(equalToConstant: .iconSide),
                bottomRButton.trailingAnchor.constraint(equalTo: bottomLButton.leadingAnchor, constant: -20),
                bottomRButton.centerYAnchor.constraint(equalTo: bottomLButton.centerYAnchor)
            ])
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
