//
//  ColorThemesButton.swift
//  OneDot
//
//  Created by Александр Коробицын on 15.10.2023.
//

import Foundation
import UIKit

class ColorThemesButtonView: UIButton {
    
    let button: UIButton = UIButton()
    
    enum State {
        case whiteGraphite,
             blackGraphite,
             systemGraphite,
             sunrise,
             sunsetSky,
             systemSky,
             lightPurple,
             deepPurple,
             systemPurple,
             drySand,
             wetSand,
             systemSand,
             lightForest,
             deepForest,
             systemForest,
             morningSea,
             eveningSea,
             systemSea
    }
    
    //MARK: - Metrics
    
    let mainButtonSide: CGFloat = 42
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setViews()
        setConstraints()
    }
    
    //MARK: - SetViews
    
    private func setViews() {
        backgroundColor = .none
        addSubview(button)
        button.layer.cornerRadius = mainButtonSide / 2
    }
    
    //MARK: - SetInactiveState
    
    func setInactiveState(_ state: State) {
        switch state {
            
        case .whiteGraphite:
            setImage("whiteGraphiteInactive")
        case .blackGraphite:
            setImage("blackGraphiteInactive")
        case .systemGraphite:
            setImage("systemGraphiteInactive")
        case .sunrise:
            setImage("sunriseInactive")
        case .sunsetSky:
            setImage("sunsetSkyInactive")
        case .systemSky:
            setImage("systemSkyInactive")
        case .lightPurple:
            setImage("lightPurpleInactive")
        case .deepPurple:
            setImage("deepPurpleInactive")
        case .systemPurple:
            setImage("systemPurpleInactive")
        case .drySand:
            setImage("drySandInactive")
        case .wetSand:
            setImage("wetSandInactive")
        case .systemSand:
            setImage("systemSandInactive")
        case .lightForest:
            setImage("lightForestInactive")
        case .deepForest:
            setImage("deepForestInactive")
        case .systemForest:
            setImage("systemForestInactive")
        case .morningSea:
            setImage("morningSeaInactive")
        case .eveningSea:
            setImage("eveningSeaInactive")
        case .systemSea:
            setImage("systemSeaInactive")
        }
    }
    
    //MARK: - SetActiveState
    
    func setActiveState(_ state: State) {
        switch state {
            
        case .whiteGraphite:
            setImage("whiteGraphiteActive")
        case .blackGraphite:
            setImage("blackGraphiteActive")
        case .systemGraphite:
            setImage("systemGraphiteActive")
        case .sunrise:
            setImage("sunriseActive")
        case .sunsetSky:
            setImage("sunsetSkyActive")
        case .systemSky:
            setImage("systemSkyActive")
        case .lightPurple:
            setImage("lightPurpleActive")
        case .deepPurple:
            setImage("deepPurpleActive")
        case .systemPurple:
            setImage("systemPurpleActive")
        case .drySand:
            setImage("drySandActive")
        case .wetSand:
            setImage("wetSandActive")
        case .systemSand:
            setImage("systemSandActive")
        case .lightForest:
            setImage("lightForestActive")
        case .deepForest:
            setImage("deepForestActive")
        case .systemForest:
            setImage("systemForestActive")
        case .morningSea:
            setImage("morningSeaActive")
        case .eveningSea:
            setImage("eveningSeaActive")
        case .systemSea:
            setImage("systemSeaActive")
        }
    }
    
    //MARK: - ButtonSettingsMethod
    
    private func setImage(_ title: String) {
        setImage(UIImage(named: title), for: .normal)
        setImage(UIImage(named: title), for: .highlighted)
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: mainButtonSide),
            button.heightAnchor.constraint(equalToConstant: mainButtonSide),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
