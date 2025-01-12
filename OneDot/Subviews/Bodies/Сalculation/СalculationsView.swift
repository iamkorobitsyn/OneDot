//
//  CalculationsViewCell.swift
//  OneDot
//
//  Created by Александр Коробицын on 11.01.2024.
//

import UIKit

class CalculationsView: UIVisualEffectView {
    
    typealias UD = UserDefaultsManager
    
    var buttonStateHandler: ((MainVC.Mode) -> Void)?
    
    enum Mode {
        case distance,
             speed,
             pace,
             time,
             hide
    }
    
    private let topButton: UIButton = UIButton()
    private let bottomButton: UIButton = UIButton()
    private let leftButton: UIButton = UIButton()
    private let rightButton: UIButton = UIButton()
    private let hideButton: UIButton = UIButton()
    
    private let distanceTitle: UILabel = UILabel()
    private let speedTitle: UILabel = UILabel()
    private let timeTitle: UILabel = UILabel()
    private let paceTitle: UILabel = UILabel()
    private let metricsTitle: UILabel = UILabel()

    
    //MARK: - Init
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        
        setViews()
        setConstraints()
        updateValues()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - MainVCHandlers
    
    @objc private func buttonPressed() {
        
        if topButton.isTouchInside {
            buttonStateHandler?(.pickerSpeed)
        } else if bottomButton.isTouchInside {
            buttonStateHandler?(.pickerPace)
        } else if leftButton.isTouchInside {
            buttonStateHandler?(.pickerDistance)
        } else if rightButton.isTouchInside {
            buttonStateHandler?(.pickerTime)
        } else if hideButton.isTouchInside {
            buttonStateHandler?(.calculationsHide)
        }
    }
    
    //MARK: - ActivateMode
    
    func activateMode(mode: Mode) {
        
        self.isHidden = false
        switch mode {
        case .distance:
            calculateDistance()
        case .speed:
            calculateSpeed()
        case .pace:
            calculatePace()
        case .time:
            calculateTime()
        case .hide:
            self.isHidden = true
        }
        updateValues()
    }
    
    //MARK: - Calculations
    
    private func calculateDistance() {
        
        let lengthOfDistance = UD.shared.calculationsDistanceValue * 1000 + UD.shared.calculationsDistanceDecimalValue * 100
        let paceOfSeconds = UD.shared.calculationsPaceMinValue * 60 + UD.shared.calculationsPaceSecValue
        
        let time = paceOfSeconds * lengthOfDistance / 1000
        
        UD.shared.calculationsTimeHValue = time / 3600
        UD.shared.calculationsTimeMinValue = time % 3600 / 60
        UD.shared.calculationsTimeSecValue = time % 3600 % 60
    }
    
    private func calculateSpeed() {
        
        
        let lengthOfDistance = Double(UD.shared.calculationsDistanceValue * 1000 + UD.shared.calculationsDistanceDecimalValue * 100)
        let distancePerSecond = Double(UD.shared.calculationsSpeedValue * 1000 + UD.shared.calculationsSpeedDecimalValue * 100) / 3600
        let timeOfSeconds = lengthOfDistance / distancePerSecond
        let secondsPerDistance = timeOfSeconds / lengthOfDistance * 1000

        if UD.shared.calculationsSpeedValue != 0 || UD.shared.calculationsSpeedDecimalValue != 0 {
            UD.shared.calculationsTimeHValue = Int(timeOfSeconds) / 3600
            UD.shared.calculationsTimeMinValue = Int(timeOfSeconds) % 3600 / 60
            UD.shared.calculationsTimeSecValue = Int(timeOfSeconds) % 3600 % 60
            
            
            UD.shared.calculationsPaceMinValue = Int(secondsPerDistance) / 60
            UD.shared.calculationsPaceSecValue = Int(secondsPerDistance) % 60
        } else {
            UD.shared.calculationsTimeHValue = 0
            UD.shared.calculationsTimeMinValue = 0
            UD.shared.calculationsTimeSecValue = 0
            
            UD.shared.calculationsPaceMinValue = 0
            UD.shared.calculationsPaceSecValue = 0
        }
    }
    
    private func calculatePace() {
        
        let lengthOfDistance = Double(UD.shared.calculationsDistanceValue * 1000 + UD.shared.calculationsDistanceDecimalValue * 100)
        let secondsPerDistance = Double(UD.shared.calculationsPaceMinValue * 60 + UD.shared.calculationsPaceSecValue) / 1000
        
        let timeOfSeconds = secondsPerDistance * lengthOfDistance
        let distancePerHour = lengthOfDistance / timeOfSeconds * 60 * 60

        if UD.shared.calculationsPaceMinValue != 0 || UD.shared.calculationsPaceSecValue != 0 {
            UD.shared.calculationsTimeHValue = Int(timeOfSeconds) / 3600
            UD.shared.calculationsTimeMinValue = Int(timeOfSeconds) % 3600 / 60
            UD.shared.calculationsTimeSecValue = Int(timeOfSeconds) % 3600 % 60
            
            UD.shared.calculationsSpeedValue = Int(distancePerHour / 1000)
            UD.shared.calculationsSpeedDecimalValue = Int(distancePerHour) % 1000 / 100
            
        } else {
            UD.shared.calculationsTimeHValue = 0
            UD.shared.calculationsTimeMinValue = 0
            UD.shared.calculationsTimeSecValue = 0
            
            UD.shared.calculationsSpeedValue = 0
            UD.shared.calculationsSpeedDecimalValue = 0
        }
    }
    
    private func calculateTime() {
        let lengthOfDistance = Double(UD.shared.calculationsDistanceValue * 1000 + UD.shared.calculationsDistanceDecimalValue * 100)
        let timeOfSeconds = Double(UD.shared.calculationsTimeHValue * 3600 + UD.shared.calculationsTimeMinValue * 60 + UD.shared.calculationsTimeSecValue)

        let distancePerHour = lengthOfDistance / timeOfSeconds * 60 * 60
        let secondsPerDistance = timeOfSeconds / lengthOfDistance * 1000
        
        if UD.shared.calculationsTimeHValue != 0 || UD.shared.calculationsTimeMinValue != 0 || UD.shared.calculationsTimeSecValue != 0 {
            UD.shared.calculationsSpeedValue = Int(distancePerHour / 1000)
            UD.shared.calculationsSpeedDecimalValue = Int(distancePerHour) % 1000 / 100
            
            UD.shared.calculationsPaceMinValue = Int(secondsPerDistance) / 60
            UD.shared.calculationsPaceSecValue = Int(secondsPerDistance) % 60
            
        } else {
            UD.shared.calculationsSpeedValue = 0
            UD.shared.calculationsSpeedDecimalValue = 0
            
            UD.shared.calculationsPaceMinValue = 0
            UD.shared.calculationsPaceSecValue = 0
        }
    }
    
    //MARK: - UpdateValues
    
    private func updateValues() {
        
        let isDistanceCleared = UD.shared.calculationsDistanceValue == 0 && UD.shared.calculationsDistanceDecimalValue == 0
        
        if isDistanceCleared {
            resetValues()
            updateButtonStates(isEnabled: false)
        } else {
            updateButtonStates(isEnabled: true)
        }
            
        updateButtonTitles()
    }
    
    private func updateButtonStates(isEnabled: Bool) {
        let alpha: CGFloat = isEnabled ? 1 : 0.5
        [topButton, rightButton, bottomButton].forEach {
            $0.isUserInteractionEnabled = isEnabled
            $0.alpha = alpha }
    }
    
    private func updateButtonTitles() {
        topButton.setTitle("\(UD.shared.calculationsSpeedValue).\(UD.shared.calculationsSpeedDecimalValue)", for: .normal)
        bottomButton.setTitle("\(addLeadingZero(UD.shared.calculationsPaceMinValue)):\(addLeadingZero(UD.shared.calculationsPaceSecValue))", for: .normal)
        leftButton.setTitle("\(UD.shared.calculationsDistanceValue).\(UD.shared.calculationsDistanceDecimalValue)", for: .normal)
        rightButton.setTitle("\(addLeadingZero(UD.shared.calculationsTimeHValue)):\(addLeadingZero(UD.shared.calculationsTimeMinValue)):\(addLeadingZero(UD.shared.calculationsTimeSecValue))", for: .normal)
    }
    
    private func resetValues() {
        UD.shared.calculationsDistanceValue = 0
        UD.shared.calculationsDistanceDecimalValue = 0
        UD.shared.calculationsSpeedValue = 0
        UD.shared.calculationsSpeedDecimalValue = 0
        UD.shared.calculationsPaceMinValue = 0
        UD.shared.calculationsPaceSecValue = 0
        UD.shared.calculationsTimeHValue = 0
        UD.shared.calculationsTimeMinValue = 0
        UD.shared.calculationsTimeSecValue = 0
    }
    
    private func addLeadingZero(_ int: Int) -> String {
        return int < 10 ? "0\(int)" : "\(int)"
    }
    
    
    
    //MARK: - SetViews
    
    private func setViews() {
        
        effect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        clipsToBounds = true
        isHidden = true
        
        layer.instance(border: true, corner: .max)
        
        setButton(button: topButton, titleColor: .myPaletteGold)
        setButton(button: bottomButton, titleColor: .myPaletteGold)
        setButton(button: leftButton, titleColor: .myPaletteBlue)
        setButton(button: rightButton, titleColor: .myPaletteBlue)
        setButton(button: hideButton, titleColor: .clear)

        setTitle(label: distanceTitle, titleText: "Distance")
        setTitle(label: speedTitle, titleText: "Km / h")
        setTitle(label: timeTitle, titleText: "Time")
        setTitle(label: paceTitle, titleText: "Min / Km")
        setTitle(label: metricsTitle, titleText: "Km")

    }
    
   //MARK: - SetButton
    
    private func setButton(button: UIButton, titleColor: UIColor) {
        contentView.addSubview(button)
        button.disableAutoresizingMask()
        button.backgroundColor = .clear
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .medium, width: .standard)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        hideButton.setImage(UIImage(named: "NavigationHide"), for: .normal)
    }
    
    //MARK: - SetTitle
    
    private func setTitle(label: UILabel, titleText: String) {
        contentView.addSubview(label)
        label.disableAutoresizingMask()
        label.instance(color: .myPaletteGray, alignment: .center, font: .condensedMid)
        label.text = titleText
    }
    
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            topButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            topButton.widthAnchor.constraint(equalToConstant: 100),
            topButton.heightAnchor.constraint(equalToConstant: 60),
            topButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 100),
            
            bottomButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            bottomButton.widthAnchor.constraint(equalToConstant: 100),
            bottomButton.heightAnchor.constraint(equalToConstant: 60),
            bottomButton.topAnchor.constraint(equalTo: topButton.bottomAnchor),
            
            leftButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 100),
            leftButton.trailingAnchor.constraint(equalTo: topButton.leadingAnchor),
            leftButton.heightAnchor.constraint(equalToConstant: 120),
            leftButton.widthAnchor.constraint(equalToConstant: (.barWidth - 100) / 2),
            
            rightButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 100),
            rightButton.leadingAnchor.constraint(equalTo: topButton.trailingAnchor),
            rightButton.heightAnchor.constraint(equalToConstant: 120),
            rightButton.widthAnchor.constraint(equalToConstant: (.barWidth - 100) / 2),
            
            hideButton.widthAnchor.constraint(equalToConstant: .iconSide),
            hideButton.heightAnchor.constraint(equalToConstant: .iconSide),
            hideButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            hideButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            distanceTitle.centerXAnchor.constraint(equalTo: leftButton.centerXAnchor),
            distanceTitle.bottomAnchor.constraint(equalTo: leftButton.topAnchor, constant: -5),
            
            speedTitle.centerXAnchor.constraint(equalTo: topButton.centerXAnchor),
            speedTitle.bottomAnchor.constraint(equalTo: topButton.topAnchor, constant: -5),
            
            timeTitle.centerXAnchor.constraint(equalTo: rightButton.centerXAnchor),
            timeTitle.bottomAnchor.constraint(equalTo: rightButton.topAnchor, constant: -5),
            
            paceTitle.centerXAnchor.constraint(equalTo: bottomButton.centerXAnchor),
            paceTitle.topAnchor.constraint(equalTo: bottomButton.bottomAnchor, constant: 5),
            
            metricsTitle.centerXAnchor.constraint(equalTo: leftButton.centerXAnchor),
            metricsTitle.topAnchor.constraint(equalTo: leftButton.bottomAnchor, constant: 5)
        ])
    }
    
}
