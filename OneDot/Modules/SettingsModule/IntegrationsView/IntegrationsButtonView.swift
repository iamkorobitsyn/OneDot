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
            setButtonSettings(.clear, .white, "ON", 10)
        case .appleWatchDisabled:
            setButtonSettings(.clear, .white, "OFF", 10)
        case .garminEnabled:
            setButtonSettings(.clear, .white, "ON", 10)
        case .garminDisabled:
            setButtonSettings(.clear, .white, "OFF", 10)
        case .fitbitEnabled:
            setButtonSettings(.clear, .white, "ON", 10)
        case .fitbitDisabled:
            setButtonSettings(.clear, .white, "OFF", 10)
        case .appleMusicEnabled:
            setButtonSettings(.clear, .white, "ON", 10)
        case .appleMusicDisabled:
            setButtonSettings(.clear, .white, "OFF", 10)
        case .spotifyEnabled:
            setButtonSettings(.clear, .white, "ON", 10)
        case .spotifyDisabled:
            setButtonSettings(.clear, .white, "OFF", 10)
        }
    }
    
    //MARK: - SetActiveState
    
    func setActiveState(_ state: State) {
        switch state {
            
        case .appleWatchEnabled:
            setButtonSettings(.white, .gray, "ON", 10)
        case .appleWatchDisabled:
            setButtonSettings(.white, .gray, "OFF", 10)
        case .garminEnabled:
            setButtonSettings(.white, .gray, "ON", 10)
        case .garminDisabled:
            setButtonSettings(.white, .gray, "OFF", 10)
        case .fitbitEnabled:
            setButtonSettings(.white, .gray, "ON", 10)
        case .fitbitDisabled:
            setButtonSettings(.white, .gray, "OFF", 10)
        case .appleMusicEnabled:
            setButtonSettings(.white, .gray, "ON", 10)
        case .appleMusicDisabled:
            setButtonSettings(.white, .gray, "OFF", 10)
        case .spotifyEnabled:
            setButtonSettings(.white, .gray, "ON", 10)
        case .spotifyDisabled:
            setButtonSettings(.white, .gray, "OFF", 10)
        }
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
