//
//  NotificationsSelectorButton.swift
//  OneDot
//
//  Created by Александр Коробицын on 15.10.2023.
//

import Foundation
import UIKit

class NotificationButtonView: SettingsBaseButton {
    
    enum State {
        case weeklyReportEmailEnabled,
             weeklyReportEmailDisabled,
             weeklyReportPushEnabled,
             weeklyReportPushDisabled,
             achievingGoalsEmailEnabled,
             achievingGoalsEmailDisabled
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    //MARK: - SetInactiveState
    
    func setInactiveState(_ state: State) {
        switch state {
        case .weeklyReportEmailEnabled:
            setButtonSettings(.sunsetSkyColor, .white, "EMAIL", 10)
        case .weeklyReportEmailDisabled:
            setButtonSettings(.sunsetSkyColor, .white, "OFF", 10)
        case .weeklyReportPushEnabled:
            setButtonSettings(.sunsetSkyColor, .white, "PUSH", 10)
        case .weeklyReportPushDisabled:
            setButtonSettings(.sunsetSkyColor, .white, "OFF", 10)
        case .achievingGoalsEmailEnabled:
            setButtonSettings(.sunsetSkyColor, .white, "EMAIL", 10)
        case .achievingGoalsEmailDisabled:
            setButtonSettings(.sunsetSkyColor, .white, "OFF", 10)
        }
    }
    
    //MARK: - SetActiveState
    
    
    func setActiveState(_ state: State) {
        switch state {
            
        case .weeklyReportEmailEnabled:
            setButtonSettings(.white, .sunsetSkyColor, "EMAIL", 10)
        case .weeklyReportEmailDisabled:
            setButtonSettings(.white, .sunsetSkyColor, "OFF", 10)
        case .weeklyReportPushEnabled:
            setButtonSettings(.white, .sunsetSkyColor, "PUSH", 10)
        case .weeklyReportPushDisabled:
            setButtonSettings(.white, .sunsetSkyColor, "OFF", 10)
        case .achievingGoalsEmailEnabled:
            setButtonSettings(.white, .sunsetSkyColor, "EMAIL", 10)
        case .achievingGoalsEmailDisabled:
            setButtonSettings(.white, .sunsetSkyColor, "OFF", 10)
        }
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
