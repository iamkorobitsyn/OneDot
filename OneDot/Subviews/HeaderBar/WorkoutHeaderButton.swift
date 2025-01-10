//
//  ActivityButton.swift
//  OneDot
//
//  Created by Александр Коробицын on 15.09.2023.
//

import UIKit

class WorkoutHeaderButton: UIButton {
    
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
            setImage("HeaderOutdoorSelected")
        case .indoor:
            setImage("HeaderIndoorSelected")
        case .notesIndoor:
            setImage("HeaderNoteIndoorSelected")
        case .notesOutdoor:
            setImage("HeaderNoteOutdoorSelected")
        }
    }
    
    func setInactiveState(_ state: State) {
        switch state {
            
        case .outdoor:
            setImage("HeaderOutdoor")
        case .indoor:
            setImage("HeaderIndoor")
        case .notesIndoor:
            setImage("HeaderNoteIndoorSelected")
        case .notesOutdoor:
            setImage("HeaderNoteOutdoor")
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

