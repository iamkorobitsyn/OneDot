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
             notesOutdoor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
  
    func setActiveState(_ state: State) {
        switch state {
            
        case .outdoor:
            setImage("DSOutdoorActive")
        case .indoor:
            setImage("DSIndoorActive")
        case .notesIndoor:
            setImage("DSNoteIndoorActive")
        case .notesOutdoor:
            setImage("DSNoteOutdoorActive")
        }
    }
    
    func setInactiveState(_ state: State) {
        switch state {
            
        case .outdoor:
            setImage("DSOutdoorInactive")
        case .indoor:
            setImage("DSIndoorInactive")
        case .notesIndoor:
            setImage("DSNoteIndoorInactive")
        case .notesOutdoor:
            setImage("DSNoteOutdoorInactive")
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

