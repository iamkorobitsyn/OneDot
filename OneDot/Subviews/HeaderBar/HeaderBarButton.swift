//
//  ActivityButton.swift
//  OneDot
//
//  Created by Александр Коробицын on 15.09.2023.
//

import UIKit

class HeaderBarButton: UIButton {
    
    enum State {
        case outdoor,
             indoor,
             notesIndoor,
             notesOutdoor,
             calculator,
             settings
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
  
    func setActiveState(_ state: State) {
        switch state {
            
        case .outdoor:
            setImage("HBSOutdoorActive")
        case .indoor:
            setImage("HBSIndoorActive")
        case .notesIndoor:
            setImage("HBSNoteIndoorActive")
        case .notesOutdoor:
            setImage("HBSNoteOutdoorActive")
        case .calculator:
            setImage("HBSCalculatorActive")
        case .settings:
            setImage("HBSSettingsActive")
        }
    }
    
    func setInactiveState(_ state: State) {
        switch state {
            
        case .outdoor:
            setImage("HBSOutdoorInactive")
        case .indoor:
            setImage("HBSIndoorInactive")
        case .notesIndoor:
            setImage("HBSNoteIndoorInactive")
        case .notesOutdoor:
            setImage("HBSNoteOutdoorInactive")
        case .calculator:
            setImage("HBSCalculatorInactive")
        case .settings:
            setImage("HBSSettingsInactive")
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

