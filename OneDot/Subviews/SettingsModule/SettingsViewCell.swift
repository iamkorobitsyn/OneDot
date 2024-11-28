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
    
    let leftButton: UIButton = UIButton()
    let rightButton: UIButton = UIButton()
    
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
            updateDistanceSettings(sender == leftButton ? true : false)
        case .autopauseSettings:
            updateAutopauseSettings(sender == leftButton ? true : false)
        case .countdownSettings:
            updateCountdownSettings(sender == leftButton ? true : false)
        case .appleHealthSettings:
            updateAppleHeathSettings(sender == leftButton ? true : false)
        default:
            break
        }
    }
    
    private func updateDistanceSettings(_ bool: Bool) {
        UD.shared.settingsDistanceValue = bool ? "km" : "ml"
        leftButton.isUserInteractionEnabled = bool ? false : true
        rightButton.isUserInteractionEnabled = bool ? true : false
        leftButton.setImage(UIImage(named: bool ? "DSKmActive" : "DSKmInactive"), for: .normal)
        rightButton.setImage(UIImage(named: bool ? "DSMlInactive" : "DSMlActive"), for: .normal)
    }
    
    private func updateAutopauseSettings(_ bool: Bool) {
        UD.shared.settingsAutopauseValue = bool ? true : false
        leftButton.isUserInteractionEnabled = bool ? false : true
        rightButton.isUserInteractionEnabled = bool ? true : false
        leftButton.setImage(UIImage(named: bool ? "DSCheckMarkActive" : "DSCheckMarkInactive"), for: .normal)
        rightButton.setImage(UIImage(named: bool ? "DSCancelInactive" : "DSCancelActive"), for: .normal)
    }
    
    private func updateCountdownSettings(_ bool: Bool) {
        UD.shared.settingsCountdownValue = bool ? true : false
        leftButton.isUserInteractionEnabled = bool ? false : true
        rightButton.isUserInteractionEnabled = bool ? true : false
        leftButton.setImage(UIImage(named: bool ? "DSCheckMarkActive" : "DSCheckMarkInactive"), for: .normal)
        rightButton.setImage(UIImage(named: bool ? "DSCancelInactive" : "DSCancelActive"), for: .normal)
    }
    
    private func updateAppleHeathSettings(_ bool: Bool) {
        UD.shared.settingsAppleHealthValue = bool ? true : false
        leftButton.isUserInteractionEnabled = bool ? false : true
        rightButton.isUserInteractionEnabled = bool ? true : false
        leftButton.setImage(UIImage(named: bool ? "DSCheckMarkActive" : "DSCheckMarkInactive"), for: .normal)
        rightButton.setImage(UIImage(named: bool ? "DSCancelInactive" : "DSCancelActive"), for: .normal)
    }
    
    //MARK: - SetViews
    
    private func setViews(mode: Mode) {
        
        contentView.addSubview(titleLabel)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .light, width: .compressed)
        titleLabel.textColor = .myPaletteGray
        
        [leftButton, rightButton].forEach { button in
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        }
        
        switch mode {
            
        case .distanceSettings:
            titleLabel.text = "Distance"
            [leftButton, rightButton].forEach({contentView.addSubview($0)})
            
            let value = UD.shared.settingsDistanceValue
            leftButton.setImage(UIImage(named: value == "km" ? "DSKmActive" : "DSKmInactive"), for: .normal)
            rightButton.setImage(UIImage(named: value == "ml" ? "DSMlActive" : "DSMlInactive"), for: .normal)

        case .autopauseSettings:
            titleLabel.text = "Autopause"
            [leftButton, rightButton].forEach({contentView.addSubview($0)})
            
            let value = UD.shared.settingsAutopauseValue
            leftButton.setImage(UIImage(named: value ? "DSCheckMarkActive" : "DSCheckMarkInactive"), for: .normal)
            rightButton.setImage(UIImage(named: value ? "DSCancelInactive" : "DSCancelActive"), for: .normal)
            
        case .countdownSettings:
            titleLabel.text = "Countdown"
            [leftButton, rightButton].forEach({contentView.addSubview($0)})
            
            let value = UD.shared.settingsCountdownValue
            leftButton.setImage(UIImage(named: value ? "DSCheckMarkActive" : "DSCheckMarkInactive"), for: .normal)
            rightButton.setImage(UIImage(named: value ? "DSCancelInactive" : "DSCancelActive"), for: .normal)
            
        case .appleHealthSettings:
            titleLabel.text = "AppleHealth"
            [leftButton, rightButton].forEach({contentView.addSubview($0)})
            
            let value = UD.shared.settingsAppleHealthValue
            leftButton.setImage(UIImage(named: value ? "DSCheckMarkActive" : "DSCheckMarkInactive"), for: .normal)
            rightButton.setImage(UIImage(named: value ? "DSCancelInactive" : "DSCancelActive"), for: .normal)
        }
    }
    
    //MARK: - SetConstrains
    
    private func setConstraints(mode: Mode) {
        
        [titleLabel, leftButton, rightButton].forEach({$0.disableAutoresizingMask()})
        
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalToConstant: 200),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            rightButton.widthAnchor.constraint(equalToConstant: .iconSide),
            rightButton.heightAnchor.constraint(equalToConstant: .iconSide),
            rightButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
            rightButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            leftButton.widthAnchor.constraint(equalToConstant: .iconSide),
            leftButton.heightAnchor.constraint(equalToConstant: .iconSide),
            leftButton.trailingAnchor.constraint(equalTo: rightButton.leadingAnchor, constant: -20),
            leftButton.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
