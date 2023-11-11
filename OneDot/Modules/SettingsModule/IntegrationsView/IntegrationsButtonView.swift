//
//  IntegrationsButton.swift
//  OneDot
//
//  Created by Александр Коробицын on 15.10.2023.
//

import Foundation
import UIKit

class IntegrationsButtonView: SettingsBaseButton {
    
    enum State {
        case  appleWatchEnabled,
              appleWatchDisabled,
              garminEnabled,
              garminDisabled,
              fitbitEnabled,
              fitbitDisabled,
              appleMusicEnabled,
              appleMusicDisabled,
              spotifyEnabled,
              spotifyDisabled
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    
    //MARK: SetInactiveState
    
    func setInactiveState(_ state: State) {
        switch state {
            
        case .appleWatchEnabled:
            setButtonSettings(.sunsetSkyColor, .white, "ON", 10)
        case .appleWatchDisabled:
            setButtonSettings(.sunsetSkyColor, .white, "OFF", 10)
        case .garminEnabled:
            setButtonSettings(.sunsetSkyColor, .white, "ON", 10)
        case .garminDisabled:
            setButtonSettings(.sunsetSkyColor, .white, "OFF", 10)
        case .fitbitEnabled:
            setButtonSettings(.sunsetSkyColor, .white, "ON", 10)
        case .fitbitDisabled:
            setButtonSettings(.sunsetSkyColor, .white, "OFF", 10)
        case .appleMusicEnabled:
            setButtonSettings(.sunsetSkyColor, .white, "ON", 10)
        case .appleMusicDisabled:
            setButtonSettings(.sunsetSkyColor, .white, "OFF", 10)
        case .spotifyEnabled:
            setButtonSettings(.sunsetSkyColor, .white, "ON", 10)
        case .spotifyDisabled:
            setButtonSettings(.sunsetSkyColor, .white, "OFF", 10)
        }
    }
    
    //MARK: - SetActiveState
    
    func setActiveState(_ state: State) {
        switch state {
            
        case .appleWatchEnabled:
            setButtonSettings(.white, .sunsetSkyColor, "ON", 10)
        case .appleWatchDisabled:
            setButtonSettings(.white, .sunsetSkyColor, "OFF", 10)
        case .garminEnabled:
            setButtonSettings(.white, .sunsetSkyColor, "ON", 10)
        case .garminDisabled:
            setButtonSettings(.white, .sunsetSkyColor, "OFF", 10)
        case .fitbitEnabled:
            setButtonSettings(.white, .sunsetSkyColor, "ON", 10)
        case .fitbitDisabled:
            setButtonSettings(.white, .sunsetSkyColor, "OFF", 10)
        case .appleMusicEnabled:
            setButtonSettings(.white, .sunsetSkyColor, "ON", 10)
        case .appleMusicDisabled:
            setButtonSettings(.white, .sunsetSkyColor, "OFF", 10)
        case .spotifyEnabled:
            setButtonSettings(.white, .sunsetSkyColor, "ON", 10)
        case .spotifyDisabled:
            setButtonSettings(.white, .sunsetSkyColor, "OFF", 10)
        }
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
