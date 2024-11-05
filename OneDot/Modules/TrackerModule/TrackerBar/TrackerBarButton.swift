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
             notesIndoor,
             notesOutdoor,
             calculator,
             sound,
             themes
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
  
    func setActiveState(_ state: State) {
        switch state {
            
        case .outdoor:
            setImage("trackerBarOutdoorIconActive")
        case .indoor:
            setImage("trackerBarIndoorIconActive")
        case .notesIndoor:
            setImage("trackerBarNoteIconIndoorActive")
        case .notesOutdoor:
            setImage("trackerBarNoteIconOutdoorActive")
        case .calculator:
            setImage("trackerBarCalculatorIconActive")
        case .sound:
            setImage("trackerBarSoundIconActive")
        case .themes:
            setImage("trackerBarThemesIconActive")
        }
    }
    
    func setInactiveState(_ state: State) {
        switch state {
            
        case .outdoor:
            setImage("trackerBarOutdoorIconInactive")
        case .indoor:
            setImage("trackerBarIndoorIconInactive")
        case .notesIndoor:
            setImage("trackerBarNoteIconIndoorInactive")
        case .notesOutdoor:
            setImage("trackerBarNoteIconIndoorInactive")
        case .calculator:
            setImage("trackerBarCalculatorIconInactive")
        case .sound:
            setImage("trackerBarSoundIconInactive")
        case .themes:
            setImage("trackerBarThemesIconInactive")
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

