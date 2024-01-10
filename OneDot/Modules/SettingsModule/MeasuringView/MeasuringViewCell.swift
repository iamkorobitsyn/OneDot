//
//  MeasuringSettingsView.swift
//  OneDot
//
//  Created by Александр Коробицын on 08.10.2023.
//

import Foundation
import UIKit

class MeasuringViewCell: ToolsBarCellBase {
    
    private let countdownTitle: UILabel = UILabel()
    private let countDownNineSecView: MeasuringButtonView = MeasuringButtonView()
    private let countDownSixSecView: MeasuringButtonView = MeasuringButtonView()
    private let countDownThreeSecView: MeasuringButtonView = MeasuringButtonView()
    private let countDownDisabledView: MeasuringButtonView = MeasuringButtonView()
    
    private let autopauseTitle: UILabel = UILabel()
    private let autopauseEnabledView: MeasuringButtonView = MeasuringButtonView()
    private let autopauseDisabledView: MeasuringButtonView = MeasuringButtonView()
    
    private let unitTitle: UILabel = UILabel()
    private let unitKmView: MeasuringButtonView = MeasuringButtonView()
    private let unitMiView: MeasuringButtonView = MeasuringButtonView()
    
    private let temperatureTitle: UILabel = UILabel()
    private let temperatureCelciusView: MeasuringButtonView = MeasuringButtonView()
    private let temperatureFahrenheitView: MeasuringButtonView = MeasuringButtonView()
    
    private var countDownStack: UIStackView = UIStackView()
    private var autopauseStack: UIStackView = UIStackView()
    private var unitStack: UIStackView = UIStackView()
    private var temperatureStack: UIStackView = UIStackView()
    
    private let separatorLine: CAShapeLayer = CAShapeLayer()
    
    //MARK: - Metrics
    
    let heightForRow: CGFloat = 490
    
    let settingsModuleWidth: CGFloat = UIScreen.main.bounds.width / 1.05
    let selectorStackSide: CGFloat = 42
    let stackSpacing: CGFloat = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViews()
        setConstraints()
        
        setCountDownButtons(buttons: [countDownNineSecView.button,
                                      countDownSixSecView.button,
                                      countDownThreeSecView.button,
                                      countDownDisabledView.button])
        
        getCountDownStates(value: UserDefaultsManager.shared.countDownValue)
        
        setAutopauseButtons()
        getAutopauseStates()
        setUnitButtons()
        getUnitStates()
        setTemperatureButtons()
        getTemperatureStates()
        
        Shaper.shared.drawCenterXSeparator(shape: separatorLine,
                                           view: self,
                                           xMove: -20,
                                           xAdd: 20,
                                           y: heightForRow,
                                           lineWidth: 4,
                                           color: .lightGray)
    }
    
    //MARK: UpdateColors
    
    func updateColors(_ set: ColorSetProtocol) {
        countDownStack.backgroundColor = set.mainSelectorColor
        autopauseStack.backgroundColor = set.mainSelectorColor
        unitStack.backgroundColor = set.mainSelectorColor
        temperatureStack.backgroundColor = set.mainSelectorColor
    }
    
    
    //MARK: - SetViews
    
    private func setViews() {
        setTitleSettings(countdownTitle, "Countdown", .gray, 14)
        countDownStack  = UIStackView(arrangedSubviews: [countDownDisabledView,
                                                         countDownThreeSecView,
                                                         countDownSixSecView,
                                                         countDownNineSecView])
        setStackSettings(countDownStack)

        setTitleSettings(autopauseTitle, "Autopause", .gray, 14)
        autopauseStack = UIStackView(arrangedSubviews: [autopauseEnabledView,
                                                        autopauseDisabledView])
        setStackSettings(autopauseStack)
        
        setTitleSettings(unitTitle, "Unit", .gray, 14)
        unitStack = UIStackView(arrangedSubviews: [unitKmView,
                                                   unitMiView])
        setStackSettings(unitStack)
        
        setTitleSettings(temperatureTitle, "Temperature", .gray, 14)
        temperatureStack = UIStackView(arrangedSubviews: [temperatureCelciusView,
                                                          temperatureFahrenheitView])
        setStackSettings(temperatureStack)
        
        
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
    }
    
    //MARK: - StackSetttingsMethod
    
    private func setStackSettings(_ stackView: UIStackView) {
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .currentColorSet.mainSelectorColor
        stackView.layer.cornerRadius = selectorStackSide / 2
        stackView.layer.cornerCurve = .continuous
        addSubview(stackView)
    }

    
    //MARK: - CountDownInstance
    
    private func setCountDownButtons(buttons: [UIButton]) {
        
        buttons.forEach { button in
            button.addTarget(self,
                             action: #selector(setCountDownStates),
                             for: .touchUpInside)
        }

    }
    
    @objc private func setCountDownStates() {
        if countDownNineSecView.button.isTouchInside {
            UserDefaultsManager.shared.countDownValue = 9
            getCountDownStates(value: UserDefaultsManager.shared.countDownValue)
            
        } else if countDownSixSecView.button.isTouchInside {
            UserDefaultsManager.shared.countDownValue = 6
            getCountDownStates(value: UserDefaultsManager.shared.countDownValue)
            
        } else if countDownThreeSecView.button.isTouchInside {
            UserDefaultsManager.shared.countDownValue = 3
            getCountDownStates(value: UserDefaultsManager.shared.countDownValue)
            
        } else if countDownDisabledView.button.isTouchInside {
            UserDefaultsManager.shared.countDownValue = 0
            getCountDownStates(value: UserDefaultsManager.shared.countDownValue)
        }
        
    }
    
    private func getCountDownStates(value: Int) {
        if value == 9 {
            refreshCountDownStates()
            countDownNineSecView.setActiveState(state: .countDownNineSeconds)
        } else if value == 6 {
            refreshCountDownStates()
            countDownSixSecView.setActiveState(state: .countDownSixSeconds)
        } else if value == 3 {
            refreshCountDownStates()
            countDownThreeSecView.setActiveState(state: .countDownThreeSeconds)
        } else if value == 0 {
            refreshCountDownStates()
            countDownDisabledView.setActiveState(state: .countDownDisabled)
        }
    }
    
    private func refreshCountDownStates() {
        countDownNineSecView.setInactiveState(state: .countDownNineSeconds)
        countDownSixSecView.setInactiveState(state: .countDownSixSeconds)
        countDownThreeSecView.setInactiveState(state: .countDownThreeSeconds)
        countDownDisabledView.setInactiveState(state: .countDownDisabled)
    }
    
    //MARK: - AutopauseInstance
    
    private func setAutopauseButtons() {
        autopauseEnabledView.button.addTarget(self,
                                         action: #selector(setAutopauseStates),
                                         for: .touchUpInside)
        autopauseDisabledView.button.addTarget(self,
                                          action: #selector(setAutopauseStates),
                                          for: .touchUpInside)
    }
    
    private func getAutopauseStates() {
        let value = UserDefaultsManager.shared.autopauseLoad()
        if value == true {
            refreshAutopauseStates()
            autopauseEnabledView.setActiveState(state: .autopauseEnabled)
        } else {
            refreshAutopauseStates()
            autopauseDisabledView.setActiveState(state: .autopauseDisabled)
        }
    }
    
    @objc private func setAutopauseStates() {
        if autopauseEnabledView.button.isTouchInside {
            refreshAutopauseStates()
            autopauseEnabledView.setActiveState(state: .autopauseEnabled)
            UserDefaultsManager.shared.autopauseSave(true)
        } else if autopauseDisabledView.button.isTouchInside {
            refreshAutopauseStates()
            autopauseDisabledView.setActiveState(state: .autopauseDisabled)
            UserDefaultsManager.shared.autopauseSave(false)
        }
    }
    
    private func refreshAutopauseStates() {
        autopauseEnabledView.setInactiveState(state: .autopauseEnabled)
        autopauseDisabledView.setInactiveState(state: .autopauseDisabled)
    }
    
    //MARK: - UnitInstance
    
    private func setUnitButtons() {
        unitKmView.button.addTarget(self,
                               action: #selector(setUnitStates),
                               for: .touchUpInside)
        unitMiView.button.addTarget(self,
                               action: #selector(setUnitStates),
                               for: .touchUpInside)
    }
    
    private func getUnitStates() {
        let value = UserDefaultsManager.shared.unitLoad()
        if value == true {
            refreshUnitStates()
            unitKmView.setActiveState(state: .unitKm)
        } else {
            refreshUnitStates()
            unitMiView.setActiveState(state: .unitMi)
        }
    }
    
    @objc private func setUnitStates() {
        
        if unitKmView.button.isTouchInside {
            refreshUnitStates()
            unitKmView.setActiveState(state: .unitKm)
            UserDefaultsManager.shared.unitSave(true)
        } else if unitMiView.button.isTouchInside {
            refreshUnitStates()
            unitMiView.setActiveState(state: .unitMi)
            UserDefaultsManager.shared.unitSave(false)
        }
    }
    
    private func refreshUnitStates() {
        unitKmView.setInactiveState(state: .unitKm)
        unitMiView.setInactiveState(state: .unitMi)
    }
    
    
    //MARK: - TemperatureInstance
    
    private func setTemperatureButtons() {
        temperatureCelciusView.button.addTarget(self,
                               action: #selector(setTemperatureButtonsStates),
                               for: .touchUpInside)
        temperatureFahrenheitView.button.addTarget(self,
                               action: #selector(setTemperatureButtonsStates),
                               for: .touchUpInside)
    }
    
    private func getTemperatureStates() {
        let value = UserDefaultsManager.shared.temperatureLoad()
        if value == true {
            refreshTemperatureButtonsStates()
            temperatureCelciusView.setActiveState(state: .temperatureCelcius)
        } else {
            refreshTemperatureButtonsStates()
            temperatureFahrenheitView.setActiveState(state: .temperatureFahrenheit)
        }
    }
    
    @objc private func setTemperatureButtonsStates() {
        
        if temperatureCelciusView.button.isTouchInside {
            refreshTemperatureButtonsStates()
            temperatureCelciusView.setActiveState(state: .temperatureCelcius)
            UserDefaultsManager.shared.temperatureSave(true)
        } else if temperatureFahrenheitView.button.isTouchInside {
            refreshTemperatureButtonsStates()
            temperatureFahrenheitView.setActiveState(state: .temperatureFahrenheit)
            UserDefaultsManager.shared.temperatureSave(false)
        }
    }
    
    private func refreshTemperatureButtonsStates() {
        temperatureCelciusView.setInactiveState(state: .temperatureCelcius)
        temperatureFahrenheitView.setInactiveState(state: .temperatureFahrenheit)
    }
    
  
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        countdownTitle.translatesAutoresizingMaskIntoConstraints = false
        countDownStack.translatesAutoresizingMaskIntoConstraints = false
        autopauseTitle.translatesAutoresizingMaskIntoConstraints = false
        autopauseStack.translatesAutoresizingMaskIntoConstraints = false
        unitTitle.translatesAutoresizingMaskIntoConstraints = false
        unitStack.translatesAutoresizingMaskIntoConstraints = false
        temperatureTitle.translatesAutoresizingMaskIntoConstraints = false
        temperatureStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            unitStack.widthAnchor.constraint(equalToConstant:
                                           (selectorStackSide *
                                    CGFloat(unitStack.subviews.count)) +
                                           (stackSpacing *
                                    CGFloat(unitStack.subviews.count)) -
                                            stackSpacing),
            unitStack.heightAnchor.constraint(equalToConstant:
                                            selectorStackSide),
            unitStack.topAnchor.constraint(equalTo: topAnchor,
                                            constant: 100),
            unitStack.centerXAnchor.constraint(equalTo:
                                            centerXAnchor),
            
            unitTitle.centerXAnchor.constraint(equalTo:
                                            unitStack.centerXAnchor),
            unitTitle.topAnchor.constraint(equalTo:
                                            unitStack.bottomAnchor, 
                                            constant: 10),
            
            temperatureStack.widthAnchor.constraint(equalToConstant:
                                           (selectorStackSide *
                                     CGFloat(temperatureStack.subviews.count)) +
                                           (stackSpacing *
                                     CGFloat(temperatureStack.subviews.count)) -
                                            stackSpacing),
            temperatureStack.heightAnchor.constraint(equalToConstant:
                                            selectorStackSide),
            temperatureStack.topAnchor.constraint(equalTo:
                                            unitStack.bottomAnchor,
                                            constant: 50),
            temperatureStack.centerXAnchor.constraint(equalTo:
                                            unitStack.centerXAnchor),
            
            temperatureTitle.centerXAnchor.constraint(equalTo:
                                            temperatureStack.centerXAnchor),
            temperatureTitle.topAnchor.constraint(equalTo:
                                            temperatureStack.bottomAnchor,
                                            constant: 10),
            
            autopauseStack.widthAnchor.constraint(equalToConstant:
                                           (selectorStackSide *
                                   CGFloat(autopauseStack.subviews.count)) +
                                           (stackSpacing *
                                   CGFloat(autopauseStack.subviews.count) -
                                            stackSpacing)),
            autopauseStack.heightAnchor.constraint(equalToConstant:
                                            selectorStackSide),
            autopauseStack.centerXAnchor.constraint(equalTo:
                                            countDownStack.centerXAnchor),
            autopauseStack.topAnchor.constraint(equalTo:
                                            temperatureStack.bottomAnchor,
                                            constant: 50),
            
            autopauseTitle.centerXAnchor.constraint(equalTo:
                                            autopauseStack.centerXAnchor),
            autopauseTitle.topAnchor.constraint(equalTo:
                                            autopauseStack.bottomAnchor,
                                            constant: 10),

            
            countDownStack.widthAnchor.constraint(equalToConstant:
                                          (selectorStackSide *
                                   CGFloat(countDownStack.subviews.count)) +
                                          (stackSpacing *
                                   CGFloat(countDownStack.subviews.count) -
                                           stackSpacing)),
            countDownStack.heightAnchor.constraint(equalToConstant:
                                           selectorStackSide),
            countDownStack.centerXAnchor.constraint(equalTo: 
                                           centerXAnchor),
            countDownStack.topAnchor.constraint(equalTo:
                                           autopauseStack.bottomAnchor,
                                           constant: 50),
            
            countdownTitle.centerXAnchor.constraint(equalTo:
                                            countDownStack.centerXAnchor),
            countdownTitle.topAnchor.constraint(equalTo:
                                            countDownStack.bottomAnchor,
                                            constant: 10),
            
           
        ])
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
