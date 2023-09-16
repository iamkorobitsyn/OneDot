//
//  ActivityButton.swift
//  OneDot
//
//  Created by Александр Коробицын on 15.09.2023.
//

import UIKit

class ActivityButton: UIButton {
    
    enum ActiveState {
        case swimming, paddleswimming, hiking, running,  bicycle, board, rollerSkates
    }
    
    enum InactiveState {
        case swimming, paddleswimming, hiking, running,  bicycle, board, rollerSkates
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
  
    func setActiveState(_ state: ActiveState) {
        switch state {
            
        case .swimming:
            setImage("swimmingActive")
        case .paddleswimming:
            setImage("paddleSwimmingActive")
        case .hiking:
            setImage("hikingActive")
        case .running:
            setImage("runningActive")
        case .bicycle:
            setImage("bicycleActive")
        case .board:
            setImage("boardActive")
        case .rollerSkates:
            setImage("rollerSkatesActive")
        }
    }
    
    func setInactiveState(_ state: InactiveState) {
        switch state {
            
        case .swimming:
            setImage("swimmingInactive")
        case .paddleswimming:
            setImage("paddleSwimmingInactive")
        case .hiking:
            setImage("hikingInactive")
        case .running:
            setImage("runningInactive")
        case .bicycle:
            setImage("bicycleInactive")
        case .board:
            setImage("boardInactive")
        case .rollerSkates:
            setImage("rollerSkatesInactive")
        }
    }
    
    private func setImage(_ title: String) {
        setImage(UIImage(named: title), for: .normal)
        setImage(UIImage(named: title), for: .highlighted)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

