//
//  CalculationsViewCell.swift
//  OneDot
//
//  Created by Александр Коробицын on 11.01.2024.
//

import UIKit

class CalculationsView: UIVisualEffectView {
    
    typealias UD = UserDefaultsManager
    
    var pickerStateHandler: ((PickerState) -> ())?
    
    enum PickerState {
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
    
    private let leftSeparator: CAShapeLayer = CAShapeLayer()
    private let rightSeparator: CAShapeLayer = CAShapeLayer()

    
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
    
    //MARK: - updatePickerForState
    
    func updatePickerForState(state: TabBar.PickerState) {
        switch state {
        case .distance:
            calculateDistance()
        case .speed:
            calculateSpeed()
        case .pace:
            calculatePace()
        case .time:
            calculateTime()
        }
        updateValues()
    }
    
    //MARK: - Calculations
    
    private func calculateDistance() {
        
        let lengthOfDistance = UD.shared.distance * 1000 + UD.shared.distanceDecimal * 100
        let paceOfSeconds = UD.shared.paceMin * 60 + UD.shared.paceSec
        
        let time = paceOfSeconds * lengthOfDistance / 1000
        
        UD.shared.timeH = time / 3600
        UD.shared.timeMin = time % 3600 / 60
        UD.shared.timeSec = time % 3600 % 60
    }
    
    private func calculateSpeed() {
        
        
        let lengthOfDistance = Double(UD.shared.distance * 1000 + UD.shared.distanceDecimal * 100)
        let distancePerSecond = Double(UD.shared.speed * 1000 + UD.shared.speedDecimal * 100) / 3600
        let timeOfSeconds = lengthOfDistance / distancePerSecond
        let secondsPerDistance = timeOfSeconds / lengthOfDistance * 1000

        if UD.shared.speed != 0 || UD.shared.speedDecimal != 0 {
            UD.shared.timeH = Int(timeOfSeconds) / 3600
            UD.shared.timeMin = Int(timeOfSeconds) % 3600 / 60
            UD.shared.timeSec = Int(timeOfSeconds) % 3600 % 60
            
            
            UD.shared.paceMin = Int(secondsPerDistance) / 60
            UD.shared.paceSec = Int(secondsPerDistance) % 60
        } else {
            UD.shared.timeH = 0
            UD.shared.timeMin = 0
            UD.shared.timeSec = 0
            
            UD.shared.paceMin = 0
            UD.shared.paceSec = 0
        }
    }
    
    private func calculatePace() {
        
        let lengthOfDistance = Double(UD.shared.distance * 1000 + UD.shared.distanceDecimal * 100)
        let secondsPerDistance = Double(UD.shared.paceMin * 60 + UD.shared.paceSec) / 1000
        
        let timeOfSeconds = secondsPerDistance * lengthOfDistance
        let distancePerHour = lengthOfDistance / timeOfSeconds * 60 * 60

        if UD.shared.paceMin != 0 || UD.shared.paceSec != 0 {
            UD.shared.timeH = Int(timeOfSeconds) / 3600
            UD.shared.timeMin = Int(timeOfSeconds) % 3600 / 60
            UD.shared.timeSec = Int(timeOfSeconds) % 3600 % 60
            
            UD.shared.speed = Int(distancePerHour / 1000)
            UD.shared.speedDecimal = Int(distancePerHour) % 1000 / 100
            
        } else {
            UD.shared.timeH = 0
            UD.shared.timeMin = 0
            UD.shared.timeSec = 0
            
            UD.shared.speed = 0
            UD.shared.speedDecimal = 0
        }
    }
    
    private func calculateTime() {
        let lengthOfDistance = Double(UD.shared.distance * 1000 + UD.shared.distanceDecimal * 100)
        let timeOfSeconds = Double(UD.shared.timeH * 3600 + UD.shared.timeMin * 60 + UD.shared.timeSec)

        let distancePerHour = lengthOfDistance / timeOfSeconds * 60 * 60
        let secondsPerDistance = timeOfSeconds / lengthOfDistance * 1000
        
        if UD.shared.timeH != 0 || UD.shared.timeMin != 0 || UD.shared.timeSec != 0 {
            UD.shared.speed = Int(distancePerHour / 1000)
            UD.shared.speedDecimal = Int(distancePerHour) % 1000 / 100
            
            UD.shared.paceMin = Int(secondsPerDistance) / 60
            UD.shared.paceSec = Int(secondsPerDistance) % 60
            
        } else {
            UD.shared.speed = 0
            UD.shared.speedDecimal = 0
            
            UD.shared.paceMin = 0
            UD.shared.paceSec = 0
        }
    }
    
    //MARK: - UpdateValues
    
    private func updateValues() {
        
        let isDistanceCleared = UD.shared.distance == 0 && UD.shared.distanceDecimal == 0
        
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
        topButton.setTitle("\(UD.shared.speed):\(UD.shared.speedDecimal)", for: .normal)
        bottomButton.setTitle("\(addLeadingZero(UD.shared.paceMin)):\(addLeadingZero(UD.shared.paceSec))", for: .normal)
        leftButton.setTitle("\(UD.shared.distance):\(UD.shared.distanceDecimal)", for: .normal)
        rightButton.setTitle("\(addLeadingZero(UD.shared.timeH)):\(addLeadingZero(UD.shared.timeMin)):\(addLeadingZero(UD.shared.timeSec))", for: .normal)
    }
    
    private func resetValues() {
        UD.shared.distance = 0
        UD.shared.distanceDecimal = 0
        UD.shared.speed = 0
        UD.shared.speedDecimal = 0
        UD.shared.paceMin = 0
        UD.shared.paceSec = 0
        UD.shared.timeH = 0
        UD.shared.timeMin = 0
        UD.shared.timeSec = 0
    }
    
    private func addLeadingZero(_ int: Int) -> String {
        return int < 10 ? "0\(int)" : "\(int)"
    }
    
    
    
    //MARK: - SetViews
    
    private func setViews() {
        
        layer.cornerRadius = 30
        layer.cornerCurve = .continuous
        layer.borderWidth = 0.3
        layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        
        setButton(button: topButton, titleColor: .myPaletteGold)
        setButton(button: bottomButton, titleColor: .myPaletteGold)
        setButton(button: leftButton, titleColor: .myPaletteBlue)
        setButton(button: rightButton, titleColor: .myPaletteBlue)
        setButton(button: hideButton, titleColor: .clear)

        setTitle(label: distanceTitle, titleText: "DISTANCE")
        setTitle(label: speedTitle, titleText: "KM / H")
        setTitle(label: timeTitle, titleText: "TIME")
        setTitle(label: paceTitle, titleText: "MIN / KM")
        setTitle(label: metricsTitle, titleText: "KM")

    }
    
   //MARK: - SetButton
    
    private func setButton(button: UIButton, titleColor: UIColor) {
        contentView.addSubview(button)
        button.backgroundColor = .clear
        button.disableAutoresizingMask()
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30,
                                                    weight: .heavy,
                                                    width: .compressed)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        hideButton.setImage(UIImage(named: "SSHideGray"), for: .normal)
    }
    
    //MARK: - SetTitle
    
    private func setTitle(label: UILabel, titleText: String) {
        contentView.addSubview(label)
        label.disableAutoresizingMask()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium, width: .compressed)
        label.textColor = .myPaletteGray
        label.text = titleText
    }
    
    //MARK: - ButtonPressed
    
    @objc private func buttonPressed() {
        
        if topButton.isTouchInside {
            pickerStateHandler?(.speed)
        } else if bottomButton.isTouchInside {
            pickerStateHandler?(.pace)
        } else if leftButton.isTouchInside {
            pickerStateHandler?(.distance)
        } else if rightButton.isTouchInside {
            pickerStateHandler?(.time)
        } else if hideButton.isTouchInside {
            pickerStateHandler?(.hide)
            self.isHidden = true
        }
    }
    
    @objc private func donePressed() {
        endEditing(true)
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
