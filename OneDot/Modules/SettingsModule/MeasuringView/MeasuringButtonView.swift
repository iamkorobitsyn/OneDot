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
            setButtonSettings(.clear, .white, "9", 14)
        case .countDownSixSeconds:
            setButtonSettings(.clear, .white, "6", 14)
        case .countDownThreeSeconds:
            setButtonSettings(.clear, .white, "3", 14)
        case .countDownDisabled:
            setButtonSettings(.clear, .white, "OFF", 10)
        case .autopauseEnabled:
            setButtonSettings(.clear, .white, "ON", 10)
        case .autopauseDisabled:
            setButtonSettings(.clear, .white, "OFF", 10)
        case .unitKm:
            setButtonSettings(.clear, .white, "Km", 12)
        case .unitMi:
            setButtonSettings(.clear, .white, "Mi", 12)
        case .temperatureCelcius:
            setButtonSettings(.clear, .white, "°C", 12)
        case .temperatureFahrenheit:
            setButtonSettings(.clear, .white, "°F", 12)
        }
    }
    
    //MARK: - SetActiveState
    
    func setActiveState(state: State) {
        switch state {
            
        case .countDownNineSeconds:
            setButtonSettings(.white, .gray, "9", 14)
        case .countDownSixSeconds:
            setButtonSettings(.white, .gray, "6", 14)
        case .countDownThreeSeconds:
            setButtonSettings(.white, .gray, "3", 14)
        case .countDownDisabled:
            setButtonSettings(.white, .gray, "OFF", 10)
        case .autopauseEnabled:
            setButtonSettings(.white, .gray, "ON", 10)
        case .autopauseDisabled:
            setButtonSettings(.white, .gray, "OFF", 10)
        case .unitKm:
            setButtonSettings(.white, .gray, "Km", 12)
        case .unitMi:
            setButtonSettings(.white, .gray, "Mi", 12)
        case .temperatureCelcius:
            setButtonSettings(.white, .gray, "°C", 12)
        case .temperatureFahrenheit:
            setButtonSettings(.white, .gray, "°F", 12)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
