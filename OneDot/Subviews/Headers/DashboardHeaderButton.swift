//
//  ActivityButton.swift
//  OneDot
//
//  Created by Александр Коробицын on 15.09.2023.
//

import UIKit

class DashboardHeaderButton: UIButton {
    
    enum State {
        case outdoor,
             indoor,
             notes,
             calculations,
             settings
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
        case .notes:
            setImage("HeaderNotesSelected")
        case .calculations:
            setImage("HeaderCalculationsSelected")
        case .settings:
            setImage("HeaderSettingsSelected")
        }
    }
    
    func setInactiveState(_ state: State) {
        switch state {
            
        case .outdoor:
            setImage("HeaderOutdoor")
        case .indoor:
            setImage("HeaderIndoor")
        case .notes:
            setImage("HeaderNotes")
        case .calculations:
            setImage("HeaderCalculations")
        case .settings:
            setImage("HeaderSettings")
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

