//
//  MainBarBodyButton.swift
//  OneDot
//
//  Created by Александр Коробицын on 06.11.2023.
//

import Foundation
import UIKit

class MainBarBodyButton: UIButton {
    
    enum State {
        case  distancePace,
              speedPace,
              pulseZones,
              appleMusic,
              metronome,
              stories,
              widjets,
              colorThemes
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = CGFloat.mainIconCorner
    }
    
    
    
    func getCalculatorActive(_ i: Int) -> String {
        if i == 0 {
            setImage("distancePaceIconFill")
            return "Distance / Pace"
        } else if i == 1 {
            setImage("speedPaceIconFill")
            return "Speed / Pace"
        } else if i == 2 {
            setImage("pulseZonesIconFill")
            return "Pulse zones"
        }
        return ""
    }
    
    func getSoundActive(_ i: Int) -> String {
        if i == 0 {
            setImage("appleMusicIconFill")
            return "Apple music"
        } else if i == 1 {
            setImage("metronomeIconFill")
            return "Metronome"
        }
        return ""
    }
    
    func getThemesActive(_ i: Int) -> String {
        if i == 0 {
            setImage("storiesIconFill")
            return "Stories"
        } else if i == 1 {
            setImage("widgetsIconFill")
            return "Widgets"
        } else if i == 2 {
            setImage("colorThemesIconFill")
            return "Color themes"
        }
        return ""
    }
    
    
    
    func setActiveState(_ state: State) {
        switch state {
        case .distancePace:
            setImage("distancePaceIconFill")
        case .speedPace:
            setImage("speedPaceIconFill")
        case .pulseZones:
            setImage("pulseZonesIconFill")
        case .appleMusic:
            setImage("appleMusicIconFill")
        case .metronome:
            setImage("metronomeIconFill")
        case .stories:
            setImage("storiesIconFill")
        case .widjets:
            setImage("widgetsIconFill")
        case .colorThemes:
            setImage("colorThemesIconFill")
        }
    }
    
    func setInactiveState(_ state: State) {
        switch state {
            
        case .distancePace:
            setImage("distancePaceIconStroke")
        case .speedPace:
            setImage("speedPaceIconStroke")
        case .pulseZones:
            setImage("pulseZonesIconStroke")
        case .appleMusic:
            setImage("appleMusicIconStroke")
        case .metronome:
            setImage("metronomeIconStroke")
        case .stories:
            setImage("storiesIconStroke")
        case .widjets:
            setImage("widgetsIconStroke")
        case .colorThemes:
            setImage("colorThemesIconStroke")
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
