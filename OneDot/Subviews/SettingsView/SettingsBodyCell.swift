//
//  SettingsViewCell.swift
//  OneDot
//
//  Created by Александр Коробицын on 25.11.2024.
//

import Foundation
import UIKit

class SettingsBodyCell: UITableViewCell {
    
    typealias UD = UserDefaultsManager
    
    enum Mode {
        case distanceSettings
        case autopauseSettings
        case countdownSettings
        case appleHealthSettings
    }
    
    var currentMode: Mode?
    
    let titleLabel: UILabel = UILabel()
    let segmenter: UISegmentedControl = UISegmentedControl(items: ["km", "ml"])
    let switcher: UISwitch = UISwitch()

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
    
    @objc private func updateMode() {
        
        switch currentMode {
        case .distanceSettings:
            UD.shared.settingsDistanceValue = segmenter.selectedSegmentIndex
        case .autopauseSettings:
            UD.shared.settingsAutopauseValue = switcher.isOn
        case .countdownSettings:
            UD.shared.settingsCountdownValue = switcher.isOn
        case .appleHealthSettings:
            UD.shared.settingsAppleHealthValue = switcher.isOn
        default:
            break
        }
    }
    
    //MARK: - SetViews
    
    private func setViews(mode: Mode) {
        contentView.addSubview(titleLabel)
        titleLabel.textAlignment = .center
        titleLabel.instance(color: .myPaletteGray, alignment: .center, font: .condensedMid)
        
        switcher.onTintColor = .myPaletteGold
        segmenter.selectedSegmentTintColor = .myPaletteGold
        segmenter.setTitleTextAttributes([.foregroundColor: UIColor.white,
                                          .font: UIFont.systemFont(ofSize: 16,
                                                                   weight: .medium,
                                                                   width: .compressed)], for: .selected)
        segmenter.setTitleTextAttributes([.foregroundColor: UIColor.myPaletteGray,
                                          .font: UIFont.systemFont(ofSize: 16,
                                                                   weight: .light,
                                                                   width: .compressed)], for: .normal)

        switch mode {
            
        case .distanceSettings:
            setUIControl(view: segmenter, title: "Distance")
            let value = UD.shared.settingsDistanceValue
            segmenter.selectedSegmentIndex = value

        case .autopauseSettings:
            setUIControl(view: switcher, title: "Autopause")
            let value = UD.shared.settingsAutopauseValue
            switcher.setOn(value, animated: true)
            
        case .countdownSettings:
            setUIControl(view: switcher, title: "Countdown")
            let value = UD.shared.settingsCountdownValue
            switcher.setOn(value, animated: true)
            
        case .appleHealthSettings:
            setUIControl(view: switcher, title: "AppleHealth")
            let value = UD.shared.settingsAppleHealthValue
            switcher.setOn(value, animated: true)
        }
    }
    
    private func setUIControl(view: UIControl, title: String) {
        contentView.addSubview(view)
        view.addTarget(self, action: #selector(updateMode), for: .valueChanged)
        titleLabel.text = title
    }
    
    //MARK: - SetConstrains
    
    private func setConstraints(mode: Mode) {
        
        titleLabel.disableAutoresizingMask()
        switch mode {
        case .autopauseSettings, .countdownSettings, .appleHealthSettings:
            switcher.disableAutoresizingMask()
            NSLayoutConstraint.activate([
                titleLabel.widthAnchor.constraint(equalToConstant: 200),
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                
                switcher.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -80),
                switcher.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        case .distanceSettings:
            segmenter.disableAutoresizingMask()
            NSLayoutConstraint.activate([
                titleLabel.widthAnchor.constraint(equalToConstant: 200),
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                
                segmenter.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
                segmenter.centerYAnchor.constraint(equalTo: centerYAnchor),
                segmenter.widthAnchor.constraint(equalToConstant: 120),
                segmenter.heightAnchor.constraint(equalToConstant: 30)
            ])
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
