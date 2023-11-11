//
//  MeasuringSettingsButton.swift
//  OneDot
//
//  Created by Александр Коробицын on 09.10.2023.
//

import Foundation
import UIKit

class MeasuringButtonView: SettingsBaseButton {

    enum State {
        case countDownNineSeconds,
             countDownSixSeconds,
             countDownThreeSeconds,
             countDownDisabled,
             autopauseEnabled,
             autopauseDisabled,
             unitKm,
             unitMi,
             temperatureCelcius,
             temperatureFahrenheit
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    //MARK: - SetInactiveState
    
    func setInactiveState(state: State) {
        switch state {
            
        case .countDownNineSeconds:
            setButtonSettings(.sunsetSkyColor, .white, "9", 14)
        case .countDownSixSeconds:
            setButtonSettings(.sunsetSkyColor, .white, "6", 14)
        case .countDownThreeSeconds:
            setButtonSettings(.sunsetSkyColor, .white, "3", 14)
        case .countDownDisabled:
            setButtonSettings(.sunsetSkyColor, .white, "OFF", 10)
        case .autopauseEnabled:
            setButtonSettings(.sunsetSkyColor, .white, "ON", 10)
        case .autopauseDisabled:
            setButtonSettings(.sunsetSkyColor, .white, "OFF", 10)
        case .unitKm:
            setButtonSettings(.sunsetSkyColor, .white, "Km", 12)
        case .unitMi:
            setButtonSettings(.sunsetSkyColor, .white, "Mi", 12)
        case .temperatureCelcius:
            setButtonSettings(.sunsetSkyColor, .white, "°C", 12)
        case .temperatureFahrenheit:
            setButtonSettings(.sunsetSkyColor, .white, "°F", 12)
        }
    }
    
    //MARK: - SetActiveState
    
    func setActiveState(state: State) {
        switch state {
            
        case .countDownNineSeconds:
            setButtonSettings(.white, .sunsetSkyColor, "9", 14)
        case .countDownSixSeconds:
            setButtonSettings(.white, .sunsetSkyColor, "6", 14)
        case .countDownThreeSeconds:
            setButtonSettings(.white, .sunsetSkyColor, "3", 14)
        case .countDownDisabled:
            setButtonSettings(.white, .sunsetSkyColor, "OFF", 10)
        case .autopauseEnabled:
            setButtonSettings(.white, .sunsetSkyColor, "ON", 10)
        case .autopauseDisabled:
            setButtonSettings(.white, .sunsetSkyColor, "OFF", 10)
        case .unitKm:
            setButtonSettings(.white, .sunsetSkyColor, "Km", 12)
        case .unitMi:
            setButtonSettings(.white, .sunsetSkyColor, "Mi", 12)
        case .temperatureCelcius:
            setButtonSettings(.white, .sunsetSkyColor, "°C", 12)
        case .temperatureFahrenheit:
            setButtonSettings(.white, .sunsetSkyColor, "°F", 12)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
