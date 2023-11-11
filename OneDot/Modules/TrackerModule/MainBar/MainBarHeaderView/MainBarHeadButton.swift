//
//  ActivityButton.swift
//  OneDot
//
//  Created by Александр Коробицын on 15.09.2023.
//

import UIKit

class MainBarHeadButton: UIButton {
    
    enum State {
        case inRoom,
             onTheStreet,
             calculator,
             themes,
             sound
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
  
    func setActiveState(_ state: State) {
        switch state {
            
        case .inRoom:
            setImage("indoorIconActive")
        case .onTheStreet:
            setImage("outdoorIconActive")
        case .calculator:
            setImage("CalculatorIconActive")
        case .sound:
            setImage("soundIconActive")
        case .themes:
            setImage("themesIconActive")
        }
    }
    
    func setInactiveState(_ state: State) {
        switch state {
       
        case .inRoom:
            setImage("indoorIconInactive")
        case .onTheStreet:
            setImage("outdoorIconInactive")
        case .calculator:
            setImage("CalculatorIconInactive")
        case .sound:
            setImage("soundIconInactive")
        case .themes:
            setImage("themesIconInactive")
        
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

