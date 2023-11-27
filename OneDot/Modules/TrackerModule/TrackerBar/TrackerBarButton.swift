//
//  ActivityButton.swift
//  OneDot
//
//  Created by Александр Коробицын on 15.09.2023.
//

import UIKit

class TrackerBarButton: UIButton {
    
    enum State {
        case outdoor,
             indoor,
             calculator,
             sound,
             themes,
             settings
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
  
    func setActiveState(_ state: State) {
        switch state {
            
        case .outdoor:
            setImage("outdoorIconActive")
        case .indoor:
            setImage("indoorIconActive")
        case .calculator:
            setImage("CalculatorIconActive")
        case .sound:
            setImage("soundIconActive")
        case .themes:
            setImage("themesIconActive")
        case .settings:
            setImage("settingsIconActive")
        }
    }
    
    func setInactiveState(_ state: State) {
        switch state {
       
        case .outdoor:
            setImage("outdoorIconInactive")
        case .indoor:
            setImage("indoorIconInactive")
        case .calculator:
            setImage("CalculatorIconInactive")
        case .sound:
            setImage("soundIconInactive")
        case .themes:
            setImage("themesIconInactive")
        case .settings:
            setImage("settingsIconInactive")
        
        }
    }
    
    private func setImage(_ title: String) {
        setBackgroundImage(UIImage(named: title), for: .normal)
        setBackgroundImage(UIImage(named: title), for: .highlighted)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

