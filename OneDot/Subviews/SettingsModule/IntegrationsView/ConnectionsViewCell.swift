//
//  File.swift
//  OneDot
//
//  Created by Александр Коробицын on 14.10.2023.
//

import Foundation
import UIKit

class ConnectionsViewCell: UITableViewCell {
    
    private let mainSeparator: CAShapeLayer = CAShapeLayer()
    
    //MARK: - Buttons
    
    let appleWatchTitle: UILabel = UILabel()
    let appleWatchEnabledView: IntegrationsButtonView = IntegrationsButtonView()
    let appleWatchDisabledView: IntegrationsButtonView = IntegrationsButtonView()
    
    let garminTitle: UILabel = UILabel()
    let garminEnabledView: IntegrationsButtonView = IntegrationsButtonView()
    let garminDisabledView: IntegrationsButtonView = IntegrationsButtonView()
    
    let fitbitTitle: UILabel = UILabel()
    let fitbitEnabledView: IntegrationsButtonView = IntegrationsButtonView()
    let fitbitDisabledView: IntegrationsButtonView = IntegrationsButtonView()
    
    let appleMusicTitle: UILabel = UILabel()
    let appleMusicEnabledView: IntegrationsButtonView = IntegrationsButtonView()
    let appleMusicDisabledView: IntegrationsButtonView = IntegrationsButtonView()
    
    let spotifyTitle: UILabel = UILabel()
    let spotifyEnabledView: IntegrationsButtonView = IntegrationsButtonView()
    let spotifyDisabledView: IntegrationsButtonView = IntegrationsButtonView()
    
    
    var appleWatchStack: UIStackView = UIStackView()
    var garminStack: UIStackView = UIStackView()
    var fitbitStack: UIStackView = UIStackView()
    var appleMusicStack: UIStackView = UIStackView()
    var spotifyStack: UIStackView = UIStackView()
    
    //MARK: - Metrics
    
    let heightForRow: CGFloat = 500
    
    let settingsModuleWidth: CGFloat = UIScreen.main.bounds.width / 1.05
    let selectorStackSide: CGFloat = 42
    let stackSpacing: CGFloat = 4
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
        
        setViews()
        setConstraints()
        
        setAppleWatchButtons()
        getAppleWatchStates()
        setGarminButtons()
        getGarminStates()
        setFitbitButtons()
        getFitbitStates()
        setAppleMusicButtons()
        getAppleMusicStates()
        setSpotifyButtons()
        getSpotifyStates()
    }
    
    
    
    //MARK: - SetViews
    
    private func setViews() {
        
        appleWatchStack = UIStackView(arrangedSubviews: [appleWatchEnabledView,
                                                        appleWatchDisabledView])
        setStackSettings(appleWatchStack)
        setTitleSettings(appleWatchTitle, " watch", .gray, 14)
        
        garminStack = UIStackView(arrangedSubviews: [garminEnabledView,
                                                     garminDisabledView])
        setStackSettings(garminStack)
        setTitleSettings(garminTitle, "Garmin", .gray, 14)
        
        fitbitStack = UIStackView(arrangedSubviews: [fitbitEnabledView,
                                                    fitbitDisabledView])
        setStackSettings(fitbitStack)
        setTitleSettings(fitbitTitle, "Fitbit", .gray, 14)
        
        appleMusicStack = UIStackView(arrangedSubviews: [appleMusicEnabledView,
                                                        appleMusicDisabledView])
        setStackSettings(appleMusicStack)
        setTitleSettings(appleMusicTitle, " music", .gray, 14)
        
        spotifyStack = UIStackView(arrangedSubviews: [spotifyEnabledView,
                                                     spotifyDisabledView])
        setStackSettings(spotifyStack)
        setTitleSettings(spotifyTitle, "Spotify", .gray, 14)
    }
    
    
    //MARK: - TitleSettingsMethod
    
    private func setTitleSettings(_ title: UILabel,
                                  _ textTitle: String,
                                  _ textColor: UIColor,
                                  _ fontSize: CGFloat) {
        addSubview(title)
        title.text = textTitle
        title.textColor = textColor
        title.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
    }
    
    //MARK: - StackSetttingsMethod
    
    private func setStackSettings(_ stackView: UIStackView) {
        stackView.axis = .horizontal
        stackView.spacing = stackSpacing
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .black
        stackView.layer.cornerRadius = selectorStackSide / 2
        stackView.layer.cornerCurve = .continuous
        addSubview(stackView)
    }
    
    //MARK: - AppleWatchInstance
    
    private func setAppleWatchButtons() {
        appleWatchEnabledView.button.addTarget(self,
                                               action: #selector(setAppleWatchStates),
                                               for: .touchUpInside)
        appleWatchDisabledView.button.addTarget(self,
                                                action: #selector(setAppleWatchStates),
                                                for: .touchUpInside)
    }
    
    private func getAppleWatchStates() {
        let value = UserDefaultsManager.shared.appleWatchLoad()
        if value == true {
            refreshAppleWatchStates()
            appleWatchEnabledView.setActiveState(.appleWatchEnabled)
        } else {
            refreshAppleWatchStates()
            appleWatchDisabledView.setActiveState(.appleWatchDisabled)
        }
    }
    
    @objc private func setAppleWatchStates() {
        if appleWatchEnabledView.button.isTouchInside {
            refreshAppleWatchStates()
            appleWatchEnabledView.setActiveState(.appleWatchEnabled)
            UserDefaultsManager.shared.appleWatchSave(true)
        } else if appleWatchDisabledView.button.isTouchInside {
            refreshAppleWatchStates()
            appleWatchDisabledView.setActiveState(.appleWatchDisabled)
            UserDefaultsManager.shared.appleWatchSave(false)
        }
    }
    
    private func refreshAppleWatchStates () {
        appleWatchEnabledView.setInactiveState(.appleWatchEnabled)
        appleWatchDisabledView.setInactiveState(.appleWatchDisabled)
    }
    
    
    //MARK: - GarminInstance
    
    private func setGarminButtons() {
        garminEnabledView.button.addTarget(self,
                                               action: #selector(setGarminStates),
                                               for: .touchUpInside)
        garminDisabledView.button.addTarget(self,
                                                action: #selector(setGarminStates),
                                                for: .touchUpInside)
    }
    
    private func getGarminStates() {
        let value = UserDefaultsManager.shared.garminLoad()
        if value == true {
            refreshGarminStates()
            garminEnabledView.setActiveState(.garminEnabled)
        } else {
            refreshGarminStates()
            garminDisabledView.setActiveState(.garminDisabled)
        }
    }
    
    @objc private func setGarminStates() {
        if garminEnabledView.button.isTouchInside {
            refreshGarminStates()
            garminEnabledView.setActiveState(.garminEnabled)
            UserDefaultsManager.shared.garminSave(true)
        } else if garminDisabledView.button.isTouchInside {
            refreshGarminStates()
            garminDisabledView.setActiveState(.garminDisabled)
            UserDefaultsManager.shared.garminSave(false)
        }
    }
    
    private func refreshGarminStates () {
        garminEnabledView.setInactiveState(.garminEnabled)
        garminDisabledView.setInactiveState(.garminDisabled)
    }
    
    //MARK: - GarminInstance
    
    private func setFitbitButtons() {
        fitbitEnabledView.button.addTarget(self,
                                               action: #selector(setFitbitStates),
                                               for: .touchUpInside)
        fitbitDisabledView.button.addTarget(self,
                                                action: #selector(setFitbitStates),
                                                for: .touchUpInside)
    }
    
    private func getFitbitStates() {
        let value = UserDefaultsManager.shared.fitbitLoad()
        if value == true {
            refreshFitbitStates()
            fitbitEnabledView.setActiveState(.fitbitEnabled)
        } else {
            refreshFitbitStates()
            fitbitDisabledView.setActiveState(.fitbitDisabled)
        }
    }
    
    @objc private func setFitbitStates() {
        if fitbitEnabledView.button.isTouchInside {
            refreshFitbitStates()
            fitbitEnabledView.setActiveState(.fitbitEnabled)
            UserDefaultsManager.shared.fitbitSave(true)
        } else if fitbitDisabledView.button.isTouchInside {
            refreshFitbitStates()
            fitbitDisabledView.setActiveState(.fitbitDisabled)
            UserDefaultsManager.shared.fitbitSave(false)
        }
    }
    
    private func refreshFitbitStates () {
        fitbitEnabledView.setInactiveState(.fitbitEnabled)
        fitbitDisabledView.setInactiveState(.fitbitDisabled)
    }
    
    //MARK: - GarminInstance
    
    private func setAppleMusicButtons() {
        appleMusicEnabledView.button.addTarget(self,
                                               action: #selector(setAppleMusicStates),
                                               for: .touchUpInside)
        appleMusicDisabledView.button.addTarget(self,
                                                action: #selector(setAppleMusicStates),
                                                for: .touchUpInside)
    }
    
    private func getAppleMusicStates() {
        let value = UserDefaultsManager.shared.appleMusicLoad()
        if value == true {
            refreshAppleMusicStates()
            appleMusicEnabledView.setActiveState(.appleMusicEnabled)
        } else {
            refreshAppleMusicStates()
            appleMusicDisabledView.setActiveState(.appleMusicDisabled)
        }
    }
    
    @objc private func setAppleMusicStates() {
        if appleMusicEnabledView.button.isTouchInside {
            refreshAppleMusicStates()
            appleMusicEnabledView.setActiveState(.appleMusicEnabled)
            UserDefaultsManager.shared.appleMusicSave(true)
        } else if appleMusicDisabledView.button.isTouchInside {
            refreshAppleMusicStates()
            appleMusicDisabledView.setActiveState(.appleMusicDisabled)
            UserDefaultsManager.shared.appleMusicSave(false)
        }
    }
    
    private func refreshAppleMusicStates () {
        appleMusicEnabledView.setInactiveState(.appleMusicEnabled)
        appleMusicDisabledView.setInactiveState(.appleMusicDisabled)
    }
    
    //MARK: - GarminInstance
    
    private func setSpotifyButtons() {
        spotifyEnabledView.button.addTarget(self,
                                               action: #selector(setSpotifyStates),
                                               for: .touchUpInside)
        spotifyDisabledView.button.addTarget(self,
                                                action: #selector(setSpotifyStates),
                                                for: .touchUpInside)
    }
    
    private func getSpotifyStates() {
        let value = UserDefaultsManager.shared.spotifyLoad()
        if value == true {
            refreshSpotifyStates()
            spotifyEnabledView.setActiveState(.spotifyEnabled)
        } else {
            refreshSpotifyStates()
            spotifyDisabledView.setActiveState(.spotifyDisabled)
        }
    }
    
    @objc private func setSpotifyStates() {
        if spotifyEnabledView.button.isTouchInside {
            refreshSpotifyStates()
            spotifyEnabledView.setActiveState(.spotifyEnabled)
            UserDefaultsManager.shared.spotifySave(true)
        } else if spotifyDisabledView.button.isTouchInside {
            refreshSpotifyStates()
            spotifyDisabledView.setActiveState(.spotifyDisabled)
            UserDefaultsManager.shared.spotifySave(false)
        }
    }
    
    private func refreshSpotifyStates () {
        spotifyEnabledView.setInactiveState(.spotifyEnabled)
        spotifyDisabledView.setInactiveState(.spotifyDisabled)
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {

        appleWatchStack.translatesAutoresizingMaskIntoConstraints = false
        garminStack.translatesAutoresizingMaskIntoConstraints = false
        fitbitStack.translatesAutoresizingMaskIntoConstraints = false
        appleMusicStack.translatesAutoresizingMaskIntoConstraints = false
        spotifyStack.translatesAutoresizingMaskIntoConstraints = false
        
        appleMusicTitle.translatesAutoresizingMaskIntoConstraints = false
        spotifyTitle.translatesAutoresizingMaskIntoConstraints = false
        appleWatchTitle.translatesAutoresizingMaskIntoConstraints = false
        garminTitle.translatesAutoresizingMaskIntoConstraints = false
        fitbitTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            appleWatchStack.widthAnchor.constraint(equalToConstant:
                                            (selectorStackSide *
                                     CGFloat(appleWatchStack.subviews.count)) +
                                            (stackSpacing *
                                     CGFloat(appleWatchStack.subviews.count) -
                                             stackSpacing)),
            appleWatchStack.heightAnchor.constraint(equalToConstant:
                                             selectorStackSide),
            appleWatchStack.centerXAnchor.constraint(equalTo:
                                             centerXAnchor),
            appleWatchStack.topAnchor.constraint(equalTo:
                                             topAnchor,
                                             constant: 40),
            
            appleWatchTitle.centerXAnchor.constraint(equalTo:
                                             appleWatchStack.centerXAnchor),
            appleWatchTitle.topAnchor.constraint(equalTo:
                                             appleWatchStack.bottomAnchor,
                                             constant: 10),
            
            garminStack.widthAnchor.constraint(equalToConstant:
                                            (selectorStackSide *
                                     CGFloat(garminStack.subviews.count)) +
                                            (stackSpacing *
                                     CGFloat(garminStack.subviews.count) -
                                             stackSpacing)),
            garminStack.heightAnchor.constraint(equalToConstant:
                                             selectorStackSide),
            garminStack.centerXAnchor.constraint(equalTo:
                                             appleWatchStack.centerXAnchor),
            garminStack.topAnchor.constraint(equalTo:
                                             appleWatchStack.bottomAnchor,
                                             constant: 50),
            
            garminTitle.centerXAnchor.constraint(equalTo:
                                             garminStack.centerXAnchor),
            garminTitle.topAnchor.constraint(equalTo:
                                             garminStack.bottomAnchor,
                                             constant: 10),
            
            fitbitStack.widthAnchor.constraint(equalToConstant:
                                            (selectorStackSide *
                                     CGFloat(fitbitStack.subviews.count)) +
                                            (stackSpacing *
                                     CGFloat(fitbitStack.subviews.count) -
                                             stackSpacing)),
            fitbitStack.heightAnchor.constraint(equalToConstant:
                                             selectorStackSide),
            fitbitStack.centerXAnchor.constraint(equalTo:
                                             garminStack.centerXAnchor),
            fitbitStack.topAnchor.constraint(equalTo:
                                             garminStack.bottomAnchor,
                                             constant: 50),
            
            fitbitTitle.centerXAnchor.constraint(equalTo:
                                             fitbitStack.centerXAnchor),
            fitbitTitle.topAnchor.constraint(equalTo:
                                             fitbitStack.bottomAnchor,
                                             constant: 10),
            
            appleMusicStack.widthAnchor.constraint(equalToConstant:
                                            (selectorStackSide *
                                     CGFloat(appleMusicStack.subviews.count)) +
                                            (stackSpacing *
                                     CGFloat(appleMusicStack.subviews.count)) -
                                             stackSpacing),
            appleMusicStack.heightAnchor.constraint(equalToConstant:
                                             selectorStackSide),
            appleMusicStack.topAnchor.constraint(equalTo: 
                                             fitbitStack.bottomAnchor,
                                             constant: 50),
            appleMusicStack.centerXAnchor.constraint(equalTo:
                                             centerXAnchor),
            
            appleMusicTitle.centerXAnchor.constraint(equalTo:
                                             appleMusicStack.centerXAnchor),
            appleMusicTitle.topAnchor.constraint(equalTo:
                                             appleMusicStack.bottomAnchor,
                                             constant: 10),
                  
            
            spotifyStack.widthAnchor.constraint(equalToConstant:
                                            (selectorStackSide *
                                     CGFloat(spotifyStack.subviews.count)) +
                                            (stackSpacing *
                                     CGFloat(spotifyStack.subviews.count)) -
                                             stackSpacing),
            spotifyStack.heightAnchor.constraint(equalToConstant:
                                             selectorStackSide),
            spotifyStack.topAnchor.constraint(equalTo:
                                             appleMusicStack.bottomAnchor,
                                             constant: 50),
            spotifyStack.centerXAnchor.constraint(equalTo:
                                             appleMusicStack.centerXAnchor),
            
            spotifyTitle.centerXAnchor.constraint(equalTo:
                                             spotifyStack.centerXAnchor),
            spotifyTitle.topAnchor.constraint(equalTo:
                                             spotifyStack.bottomAnchor,
                                             constant: 10)
        ])
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

