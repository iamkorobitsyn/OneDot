//
//  ColorThemesViewCell.swift
//  OneDot
//
//  Created by Александр Коробицын on 13.10.2023.
//

import Foundation
import UIKit

class ColorThemesViewCell: SettingsBaseViewCell {
    
    let mainTitle: UILabel = UILabel()
    let mainSeparator: CAShapeLayer = CAShapeLayer()
    
    let topLSeparator: CAShapeLayer = CAShapeLayer()
    let topRSeparator: CAShapeLayer = CAShapeLayer()
    let bottomLSeparator: CAShapeLayer = CAShapeLayer()
    let bottomRSeparator: CAShapeLayer = CAShapeLayer()
    
    //MARK: Graphite/Sky/Purple Buttons
    
    let graphiteThemeTitle: UILabel = UILabel()
    let blackGraphitButton: ColorThemesButtonView = ColorThemesButtonView()
    let whiteGraphiteButton: ColorThemesButtonView = ColorThemesButtonView()
    
    let skyThemeTitle: UILabel = UILabel()
    let sunsetSkyButton: ColorThemesButtonView = ColorThemesButtonView()
    let sunriseButton: ColorThemesButtonView = ColorThemesButtonView()
    
    let purpleThemeTitle: UILabel = UILabel()
    let deepPurpleButton: ColorThemesButtonView = ColorThemesButtonView()
    let lightPurpleButton: ColorThemesButtonView = ColorThemesButtonView()

    let systemGraphiteButton: ColorThemesButtonView = ColorThemesButtonView()
    let systemSkyButton: ColorThemesButtonView = ColorThemesButtonView()
    let systemPurpleButton: ColorThemesButtonView = ColorThemesButtonView()
    
    //MARK: - Sea/Forest/Sand Buttons
    
    let seaThemeTitle: UILabel = UILabel()
    let eveningSeaButton: ColorThemesButtonView = ColorThemesButtonView()
    let morningSeaButton: ColorThemesButtonView = ColorThemesButtonView()
    
    let forestThemeTitle: UILabel = UILabel()
    let deepForestButton: ColorThemesButtonView = ColorThemesButtonView()
    let lightForestButton: ColorThemesButtonView = ColorThemesButtonView()
   
    let sandThemeTitle: UILabel = UILabel()
    let wetSandButton: ColorThemesButtonView = ColorThemesButtonView()
    let drySandButton: ColorThemesButtonView = ColorThemesButtonView()
   
    let systemSeaButton: ColorThemesButtonView = ColorThemesButtonView()
    let systemForestButton: ColorThemesButtonView = ColorThemesButtonView()
    let systemSandButton: ColorThemesButtonView = ColorThemesButtonView()
    
    //MARK: - StackViews
    
    var graphiteSkyPurpleStack: UIStackView = UIStackView()
    var graphiteSkyPurpleSystemStack: UIStackView = UIStackView()
    var graphiteSkyPurpleTitleStack: UIStackView = UIStackView()
    
    let systemSwithesTitle: UILabel = UILabel()
    
    var seaForestSandStack: UIStackView = UIStackView()
    var seaForestSandSystemStack: UIStackView = UIStackView()
    var seaForestSandTitleStack: UIStackView = UIStackView()
    
    //MARK: - Metrics
    
    let selectorStackSide: CGFloat = 42
    let stackSpacing: CGFloat = 4
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViews()
        setConstraints()
        
        setColorThemesButtons()
        getColorThemesStates()
        
    }
    
    //MARK: - SetViews
    
    private func setViews() {
        
        setTitleSettings(mainTitle, "Color theme", .gray, 21)
        
        Shaper.shared.drawCenterXSeparator(shape: mainSeparator,
                                                     view: self,
                                                     xMove: -30,
                                                     xAdd: 30,
                                                     y: 27,
                                                     lineWidth: 1,
                                                     color: .lightGray)
        
        graphiteSkyPurpleStack = UIStackView(arrangedSubviews: [blackGraphitButton,
                                                               whiteGraphiteButton,
                                                               sunsetSkyButton,
                                                               sunriseButton,
                                                               deepPurpleButton,
                                                               lightPurpleButton])
        graphiteSkyPurpleStack.axis = .horizontal
        graphiteSkyPurpleStack.spacing = stackSpacing * 2
        graphiteSkyPurpleStack.distribution = .fillEqually
        addSubview(graphiteSkyPurpleStack)
        
        graphiteSkyPurpleSystemStack = UIStackView(arrangedSubviews: [systemGraphiteButton,
                                                                     systemSkyButton,
                                                                     systemPurpleButton])
        graphiteSkyPurpleSystemStack.axis = .horizontal
        graphiteSkyPurpleSystemStack.spacing = selectorStackSide +
                                               stackSpacing * 4
        graphiteSkyPurpleSystemStack.distribution = .fillEqually
        addSubview(graphiteSkyPurpleSystemStack)
        
        seaForestSandStack = UIStackView(arrangedSubviews: [eveningSeaButton,
                                                           morningSeaButton,
                                                           deepForestButton,
                                                           lightForestButton,
                                                           wetSandButton,
                                                           drySandButton])
        seaForestSandStack.axis = .horizontal
        seaForestSandStack.spacing = stackSpacing * 2
        seaForestSandStack.distribution = .fillEqually
        addSubview(seaForestSandStack)
        
        seaForestSandSystemStack = UIStackView(arrangedSubviews: [systemSeaButton,
                                                                 systemForestButton,
                                                                 systemSandButton])
        seaForestSandSystemStack.axis = .horizontal
        seaForestSandSystemStack.spacing = selectorStackSide +
                                           stackSpacing * 4
        seaForestSandSystemStack.distribution = .fillEqually
        addSubview(seaForestSandSystemStack)
        
        setTitleSettings(systemSwithesTitle, "System switches", .gray, 16)
        
        setTitleSettings(graphiteThemeTitle, "Graphite", .gray, 16)
        setTitleSettings(skyThemeTitle, "Sky", .gray, 16)
        setTitleSettings(purpleThemeTitle, "Purple", .gray, 16)
        
        graphiteSkyPurpleTitleStack = UIStackView(arrangedSubviews: [graphiteThemeTitle,
                                                                    skyThemeTitle,
                                                                    purpleThemeTitle])
        graphiteSkyPurpleTitleStack.axis = .horizontal
        graphiteSkyPurpleTitleStack.spacing = stackSpacing * 2
        graphiteSkyPurpleTitleStack.distribution = .fillEqually
        addSubview(graphiteSkyPurpleTitleStack)
    
        setTitleSettings(seaThemeTitle, "Sea", .gray, 16)
        setTitleSettings(forestThemeTitle, "Forest", .gray, 16)
        setTitleSettings(sandThemeTitle, "Sand", .gray, 16)
        
        seaForestSandTitleStack = UIStackView(arrangedSubviews: [seaThemeTitle,
                                                                forestThemeTitle,
                                                                sandThemeTitle])
        seaForestSandTitleStack.axis = .horizontal
        seaForestSandTitleStack.spacing = stackSpacing * 2
        seaForestSandTitleStack.distribution = .fillEqually
        addSubview(seaForestSandTitleStack)
        
        Shaper.shared.drawCenterYSeparator(shape: topLSeparator,
                                                    view: self,
                                                    moveX: UIScreen.main.bounds.width / 2.65,
                                                    moveY: 125,
                                                    addX: UIScreen.main.bounds.width / 2.65,
                                                    addY: 145,
                                                    lineWidth: 0.5,
                                                    color: .lightGray)
        
        Shaper.shared.drawCenterYSeparator(shape: topRSeparator,
                                                    view: self,
                                                    moveX: UIScreen.main.bounds.width -
                                                        UIScreen.main.bounds.width / 2.65,
                                                    moveY: 125,
                                                    addX: UIScreen.main.bounds.width -
                                                        UIScreen.main.bounds.width / 2.65,
                                                    addY: 145,
                                                    lineWidth: 0.5,
                                                    color: .lightGray)
        
        Shaper.shared.drawCenterYSeparator(shape: bottomLSeparator,
                                                    view: self,
                                                    moveX: UIScreen.main.bounds.width / 2.65,
                                                    moveY: 280,
                                                    addX: UIScreen.main.bounds.width / 2.65,
                                                    addY: 300,
                                                    lineWidth: 0.5,
                                                    color: .lightGray)
        
        Shaper.shared.drawCenterYSeparator(shape: bottomRSeparator,
                                                    view: self,
                                                    moveX: UIScreen.main.bounds.width -
                                                        UIScreen.main.bounds.width / 2.65,
                                                    moveY: 280,
                                                    addX: UIScreen.main.bounds.width -
                                                        UIScreen.main.bounds.width / 2.65,
                                                    addY: 300,
                                                    lineWidth: 0.5,
                                                    color: .lightGray)
        
        
        
    }
    
    
    
    //MARK: - TitleSettingsMethod
    
    private func setTitleSettings(_ title: UILabel,
                                  _ textTitle: String,
                                  _ textColor: UIColor,
                                  _ fontSize: CGFloat) {
        addSubview(title)
        title.text = textTitle
        title.textColor = textColor
        title.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        title.textAlignment = .center
    }
    
    //MARK: - StackSetttingsMethod
    
    private func setStackSettings(_ stackView: UIStackView) {
        stackView.axis = .horizontal
        stackView.spacing = stackSpacing
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .sunsetSkyColor
        stackView.layer.cornerRadius = selectorStackSide / 2
        stackView.layer.cornerCurve = .continuous
        addSubview(stackView)
    }
    
    //MARK: - SetColorThemesButtons
    
    private func setColorThemesButtons() {
        blackGraphitButton.button.addTarget(self,
                                     action: #selector(setColorThemesStates),
                                     for: .touchUpInside)
        whiteGraphiteButton.button.addTarget(self,
                                     action: #selector(setColorThemesStates),
                                     for: .touchUpInside)
        sunsetSkyButton.button.addTarget(self,
                                     action: #selector(setColorThemesStates),
                                     for: .touchUpInside)
        sunriseButton.button.addTarget(self,
                                     action: #selector(setColorThemesStates),
                                     for: .touchUpInside)
        deepPurpleButton.button.addTarget(self,
                                     action: #selector(setColorThemesStates),
                                     for: .touchUpInside)
        lightPurpleButton.button.addTarget(self,
                                     action: #selector(setColorThemesStates),
                                     for: .touchUpInside)
        systemGraphiteButton.button.addTarget(self,
                                     action: #selector(setColorThemesStates),
                                     for: .touchUpInside)
        systemSkyButton.button.addTarget(self,
                                     action: #selector(setColorThemesStates),
                                     for: .touchUpInside)
        systemPurpleButton.button.addTarget(self,
                                     action: #selector(setColorThemesStates),
                                     for: .touchUpInside)
        eveningSeaButton.button.addTarget(self,
                                     action: #selector(setColorThemesStates),
                                     for: .touchUpInside)
        morningSeaButton.button.addTarget(self,
                                     action: #selector(setColorThemesStates),
                                     for: .touchUpInside)
        deepForestButton.button.addTarget(self,
                                     action: #selector(setColorThemesStates),
                                     for: .touchUpInside)
        lightForestButton.button.addTarget(self,
                                     action: #selector(setColorThemesStates),
                                     for: .touchUpInside)
        wetSandButton.button.addTarget(self,
                                     action: #selector(setColorThemesStates),
                                     for: .touchUpInside)
        drySandButton.button.addTarget(self,
                                     action: #selector(setColorThemesStates),
                                     for: .touchUpInside)
        systemSeaButton.button.addTarget(self,
                                     action: #selector(setColorThemesStates),
                                     for: .touchUpInside)
        systemForestButton.button.addTarget(self,
                                     action: #selector(setColorThemesStates),
                                     for: .touchUpInside)
        systemSandButton.button.addTarget(self,
                                     action: #selector(setColorThemesStates),
                                     for: .touchUpInside)
        
    }
    
    //MARK: - GetColorThemesStates
    
    private func getColorThemesStates() {
        let value = UserDefaultsManager.shared.colorThemeLoad()
        if value == "whiteGraphite" {
            refreshColorThemesStates()
            whiteGraphiteButton.setActiveState(.whiteGraphite)
        } else if value == "blackGraphite" {
            refreshColorThemesStates()
            blackGraphitButton.setActiveState(.blackGraphite)
        } else if value == "systemGraphite" {
            refreshColorThemesStates()
            systemGraphiteButton.setActiveState(.systemGraphite)
        } else if value == "sunrise" {
            refreshColorThemesStates()
            sunriseButton.setActiveState(.sunrise)
        } else if value == "sunsetSky" {
            refreshColorThemesStates()
            sunsetSkyButton.setActiveState(.sunsetSky)
        } else if value == "systemSky" {
            refreshColorThemesStates()
            systemSkyButton.setActiveState(.systemSky)
        } else if value == "lightPurple" {
            refreshColorThemesStates()
            lightPurpleButton.setActiveState(.lightPurple)
        } else if value == "deepPurple" {
            refreshColorThemesStates()
            deepPurpleButton.setActiveState(.deepPurple)
        } else if value == "systemPurple" {
            refreshColorThemesStates()
            systemPurpleButton.setActiveState(.systemPurple)
        } else if value == "drySand" {
            refreshColorThemesStates()
            drySandButton.setActiveState(.drySand)
        } else if value == "wetSand" {
            refreshColorThemesStates()
            wetSandButton.setActiveState(.wetSand)
        } else if value == "systemSand" {
            refreshColorThemesStates()
            systemSandButton.setActiveState(.systemSand)
        } else if value == "lightForest" {
            refreshColorThemesStates()
            lightForestButton.setActiveState(.lightForest)
        } else if value == "deepForest" {
            refreshColorThemesStates()
            deepForestButton.setActiveState(.deepForest)
        } else if value == "systemForest" {
            refreshColorThemesStates()
            systemForestButton.setActiveState(.systemForest)
        } else if value == "morningSea" {
            refreshColorThemesStates()
            morningSeaButton.setActiveState(.morningSea)
        } else if value == "eveningSea" {
            refreshColorThemesStates()
            eveningSeaButton.setActiveState(.eveningSea)
        } else if value == "systemSea" {
            refreshColorThemesStates()
            systemSeaButton.setActiveState(.systemSea)
        }
    }
    
    //MARK: - SetColorThemesStates
    
    @objc private func setColorThemesStates() {
        if whiteGraphiteButton.button.isTouchInside {
            refreshColorThemesStates()
            whiteGraphiteButton.setActiveState(.whiteGraphite)
        } else if blackGraphitButton.button.isTouchInside {
            refreshColorThemesStates()
            blackGraphitButton.setActiveState(.blackGraphite)
        } else if systemGraphiteButton.button.isTouchInside {
            refreshColorThemesStates()
            systemGraphiteButton.setActiveState(.systemGraphite)
        } else if sunriseButton.button.isTouchInside {
            refreshColorThemesStates()
            sunriseButton.setActiveState(.sunrise)
        } else if sunsetSkyButton.button.isTouchInside {
            refreshColorThemesStates()
            sunsetSkyButton.setActiveState(.sunsetSky)
        } else if systemSkyButton.button.isTouchInside {
            refreshColorThemesStates()
            systemSkyButton.setActiveState(.systemSky)
        } else if lightPurpleButton.button.isTouchInside {
            refreshColorThemesStates()
            lightPurpleButton.setActiveState(.lightPurple)
        } else if deepPurpleButton.button.isTouchInside {
            refreshColorThemesStates()
            deepPurpleButton.setActiveState(.deepPurple)
        } else if systemPurpleButton.button.isTouchInside {
            refreshColorThemesStates()
            systemPurpleButton.setActiveState(.systemPurple)
        } else if morningSeaButton.button.isTouchInside {
            refreshColorThemesStates()
            morningSeaButton.setActiveState(.morningSea)
        } else if eveningSeaButton.button.isTouchInside {
            refreshColorThemesStates()
            eveningSeaButton.setActiveState(.eveningSea)
        } else if systemSeaButton.button.isTouchInside {
            refreshColorThemesStates()
            systemSeaButton.setActiveState(.systemSea)
        } else if lightForestButton.button.isTouchInside {
            refreshColorThemesStates()
            lightForestButton.setActiveState(.lightForest)
        } else if deepForestButton.button.isTouchInside {
            refreshColorThemesStates()
            deepForestButton.setActiveState(.deepForest)
        } else if systemForestButton.button.isTouchInside {
            refreshColorThemesStates()
            systemForestButton.setActiveState(.systemForest)
        } else if drySandButton.button.isTouchInside {
            refreshColorThemesStates()
            drySandButton.setActiveState(.drySand)
        } else if wetSandButton.button.isTouchInside {
            refreshColorThemesStates()
            wetSandButton.setActiveState(.wetSand)
        } else if systemSandButton.button.isTouchInside {
            refreshColorThemesStates()
            systemSandButton.setActiveState(.systemSand)
        }
    }
    
    //MARK: - RefreshColorThemesStates
    
    private func refreshColorThemesStates() {
        whiteGraphiteButton.setInactiveState(.whiteGraphite)
        blackGraphitButton.setInactiveState(.blackGraphite)
        systemGraphiteButton.setInactiveState(.systemGraphite)
        sunriseButton.setInactiveState(.sunrise)
        sunsetSkyButton.setInactiveState(.sunsetSky)
        systemSkyButton.setInactiveState(.systemSky)
        lightPurpleButton.setInactiveState(.lightPurple)
        deepPurpleButton.setInactiveState(.deepPurple)
        systemPurpleButton.setInactiveState(.systemPurple)
        morningSeaButton.setInactiveState(.morningSea)
        eveningSeaButton.setInactiveState(.eveningSea)
        systemSeaButton.setInactiveState(.systemSea)
        lightForestButton.setInactiveState(.lightForest)
        deepForestButton.setInactiveState(.deepForest)
        systemForestButton.setInactiveState(.systemForest)
        drySandButton.setInactiveState(.drySand)
        wetSandButton.setInactiveState(.wetSand)
        systemSandButton.setInactiveState(.systemSand)
    }
    
    
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        mainTitle.translatesAutoresizingMaskIntoConstraints = false
        
        graphiteSkyPurpleStack.translatesAutoresizingMaskIntoConstraints = false
        graphiteSkyPurpleSystemStack.translatesAutoresizingMaskIntoConstraints = false
        graphiteSkyPurpleTitleStack.translatesAutoresizingMaskIntoConstraints = false
        
        seaForestSandStack.translatesAutoresizingMaskIntoConstraints = false
        seaForestSandSystemStack.translatesAutoresizingMaskIntoConstraints = false
        seaForestSandTitleStack.translatesAutoresizingMaskIntoConstraints = false
        
        systemSwithesTitle.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        NSLayoutConstraint.activate([
            mainTitle.topAnchor.constraint(equalTo: topAnchor),
            mainTitle.centerXAnchor.constraint(equalTo:
                                            centerXAnchor),
            
            graphiteSkyPurpleStack.widthAnchor.constraint(equalToConstant:
                                   (CGFloat(graphiteSkyPurpleStack.subviews.count) *
                                            selectorStackSide) +
                                   (CGFloat(graphiteSkyPurpleStack.subviews.count) *
                                            stackSpacing * 2 -
                                            stackSpacing * 2)),
            graphiteSkyPurpleStack.heightAnchor.constraint(equalToConstant:
                                            selectorStackSide),
            graphiteSkyPurpleStack.centerXAnchor.constraint(equalTo:
                                            centerXAnchor),
            graphiteSkyPurpleStack.topAnchor.constraint(equalTo:
                                            topAnchor,
                                            constant: 90),
            
            graphiteSkyPurpleSystemStack.widthAnchor.constraint(equalToConstant:
                                   (CGFloat(graphiteSkyPurpleStack.subviews.count) *
                                            selectorStackSide -
                                            selectorStackSide) +
                                   (CGFloat(graphiteSkyPurpleStack.subviews.count - 2) *
                                           (stackSpacing * 2))),
            graphiteSkyPurpleSystemStack.heightAnchor.constraint(equalToConstant:
                                            selectorStackSide),
            graphiteSkyPurpleSystemStack.centerXAnchor.constraint(equalTo:
                                            centerXAnchor),
            graphiteSkyPurpleSystemStack.topAnchor.constraint(equalTo:
                                            graphiteSkyPurpleStack.bottomAnchor,
                                            constant: stackSpacing * 2),
            
            graphiteSkyPurpleTitleStack.widthAnchor.constraint(equalToConstant:
                                   (CGFloat(graphiteSkyPurpleStack.subviews.count) *
                                            selectorStackSide) +
                                   (CGFloat(graphiteSkyPurpleStack.subviews.count) *
                                            stackSpacing * 2 -
                                            stackSpacing * 2)),
            graphiteSkyPurpleTitleStack.centerXAnchor.constraint(equalTo:
                                            centerXAnchor),
            graphiteSkyPurpleTitleStack.bottomAnchor.constraint(equalTo: 
                                            graphiteSkyPurpleStack.topAnchor,
                                            constant: -stackSpacing),
            
            seaForestSandStack.widthAnchor.constraint(equalToConstant:
                                   (CGFloat(seaForestSandStack.subviews.count) *
                                            selectorStackSide) +
                                   (CGFloat(seaForestSandStack.subviews.count) *
                                            stackSpacing * 2 -
                                            stackSpacing * 2)),
            seaForestSandStack.heightAnchor.constraint(equalToConstant:
                                            selectorStackSide),
            seaForestSandStack.centerXAnchor.constraint(equalTo:
                                            centerXAnchor),
            seaForestSandStack.bottomAnchor.constraint(equalTo:
                                            bottomAnchor,
                                            constant: -90),
            
            seaForestSandSystemStack.widthAnchor.constraint(equalToConstant:
                                   (CGFloat(seaForestSandStack.subviews.count) *
                                            selectorStackSide -
                                            selectorStackSide) +
                                   (CGFloat(seaForestSandStack.subviews.count - 2) *
                                           (stackSpacing * 2))),
            seaForestSandSystemStack.heightAnchor.constraint(equalToConstant:
                                            selectorStackSide),
            seaForestSandSystemStack.centerXAnchor.constraint(equalTo:
                                            centerXAnchor),
            seaForestSandSystemStack.bottomAnchor.constraint(equalTo:
                                            seaForestSandStack.topAnchor,
                                            constant: -stackSpacing * 2),
            
            systemSwithesTitle.centerXAnchor.constraint(equalTo: 
                                            centerXAnchor),
            systemSwithesTitle.centerYAnchor.constraint(equalTo:
                                            centerYAnchor),
            
            seaForestSandTitleStack.widthAnchor.constraint(equalToConstant:
                                   (CGFloat(seaForestSandStack.subviews.count) *
                                            selectorStackSide) +
                                   (CGFloat(seaForestSandStack.subviews.count) *
                                            stackSpacing * 2 -
                                            stackSpacing * 2)),
            seaForestSandTitleStack.centerXAnchor.constraint(equalTo:
                                            centerXAnchor),
            seaForestSandTitleStack.topAnchor.constraint(equalTo:
                                            seaForestSandStack.bottomAnchor,
                                            constant: stackSpacing),
            
            
            
            
        ])
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
