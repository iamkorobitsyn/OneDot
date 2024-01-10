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
            setButtonSettings(.clear, .white, "EMAIL", 10)
        case .weeklyReportEmailDisabled:
            setButtonSettings(.clear, .white, "OFF", 10)
        case .weeklyReportPushEnabled:
            setButtonSettings(.clear, .white, "PUSH", 10)
        case .weeklyReportPushDisabled:
            setButtonSettings(.clear, .white, "OFF", 10)
        case .achievingGoalsEmailEnabled:
            setButtonSettings(.clear, .white, "EMAIL", 10)
        case .achievingGoalsEmailDisabled:
            setButtonSettings(.clear, .white, "OFF", 10)
        }
    }
    
    //MARK: - SetActiveState
    
    
    func setActiveState(_ state: State) {
        switch state {
            
        case .weeklyReportEmailEnabled:
            setButtonSettings(.white, .gray, "EMAIL", 10)
        case .weeklyReportEmailDisabled:
            setButtonSettings(.white, .gray, "OFF", 10)
        case .weeklyReportPushEnabled:
            setButtonSettings(.white, .gray, "PUSH", 10)
        case .weeklyReportPushDisabled:
            setButtonSettings(.white, .gray, "OFF", 10)
        case .achievingGoalsEmailEnabled:
            setButtonSettings(.white, .gray, "EMAIL", 10)
        case .achievingGoalsEmailDisabled:
            setButtonSettings(.white, .gray, "OFF", 10)
        }
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
