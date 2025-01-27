//
//  CalculationsViewCell.swift
//  OneDot
//
//  Created by Александр Коробицын on 11.01.2024.
//

import UIKit

class CalculationsBodyView: UIVisualEffectView {
    
    let hapticGenerator = UISelectionFeedbackGenerator()
    
    typealias UD = UserDefaultsManager
    
    var buttonStateHandler: ((DashboardVC.Mode) -> Void)?
    
    enum Mode {
        case distance,
             speed,
             pace,
             time,
             hide
    }
    
    private let distanceButton: UIButton = UIButton()
    private let distanceTitle: UILabel = UILabel()
    
    private let durationButton: UIButton = UIButton()
    private let durationTitle: UILabel = UILabel()
    
    private let paceButton: UIButton = UIButton()
    private let paceTitle: UILabel = UILabel()
    
    private let speedButton: UIButton = UIButton()
    private let speedTitle: UILabel = UILabel()
    
    private let eraseButton: UIButton = {
        let button = UIButton()
        button.disableAutoresizingMask()
        return button
    }()
    
    private let hideButton: UIButton = {
        let button = UIButton()
        button.disableAutoresizingMask()
        button.setImage(UIImage(named: "BodyHide"), for: .normal)
        button.setImage(UIImage(named: "BodyHide"), for: .highlighted)
        return button
    }()
    
    private let crossSeparator: UIImageView = {
        let view = UIImageView()
        view.disableAutoresizingMask()
        view.image = UIImage(named: "crossSeparatorGray")
        return view
    }()

    
    private let containerView = {
        let view = UIVisualEffectView()
        view.disableAutoresizingMask()
        view.effect = UIBlurEffect(style: UIBlurEffect.Style.light)
        view.clipsToBounds = true
        view.layer.instance(border: true, corner: .min)
        return view
    }()

    
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
    
    
    //MARK: - ButtonTapped
    
    @objc private func buttonTapped() {
        
        hapticGenerator.selectionChanged()
        switch true {
        case speedButton.isTouchInside:
            buttonStateHandler?(.pickerSpeed)
        case paceButton.isTouchInside:
            buttonStateHandler?(.pickerPace)
        case distanceButton.isTouchInside:
            buttonStateHandler?(.pickerDistance)
        case durationButton.isTouchInside:
            buttonStateHandler?(.pickerTime)
        case eraseButton.isTouchInside:
            CalculationsService.shared.resetValues()
            buttonStateHandler?(.pickerDistance)
            updateValues()
        default:
            break
        }
    }
    
    @objc private func hide() {
        buttonStateHandler?(.calculationsHide)
    }
    
    //MARK: - ActivateMode
    
    func activateMode(mode: Mode) {
        self.isHidden = false
        switch mode {
        case .distance:
            CalculationsService.shared.calculateDistance()
        case .speed:
            CalculationsService.shared.calculateSpeed()
        case .pace:
            CalculationsService.shared.calculatePace()
        case .time:
            CalculationsService.shared.calculateTime()
        case .hide:
            self.isHidden = true
        }
        updateValues()
    }
    
    //MARK: - UpdateValues
    
    private func updateValues() {
        
        let isDistanceCleared = UD.shared.calculationsDistanceValue == 0 && UD.shared.calculationsDistanceDecimalValue == 0
        
        if isDistanceCleared {
            eraseButton.setImage(UIImage(named: "BodyEraseInactive"), for: .normal)
            eraseButton.setImage(UIImage(named: "BodyEraseInactive"), for: .highlighted)
            CalculationsService.shared.resetValues()
            updateButtonStates(isEnabled: false)
        } else {
            eraseButton.setImage(UIImage(named: "BodyEraseActive"), for: .normal)
            eraseButton.setImage(UIImage(named: "BodyEraseActive"), for: .highlighted)
            updateButtonStates(isEnabled: true)
        }
            
        updateButtonTitles()
    }
    
    
    
    private func updateButtonStates(isEnabled: Bool) {
        let alpha: CGFloat = isEnabled ? 1 : 0.5
        [speedButton, durationButton, paceButton].forEach {
            $0.isUserInteractionEnabled = isEnabled
            $0.alpha = alpha }
    }
    
    private func updateButtonTitles() {
        
        let speedValue = UD.shared.calculationsSpeedValue
        let speedDecimalValue = UD.shared.calculationsSpeedDecimalValue
        speedButton.setTitle("\(speedValue).\(speedDecimalValue)", for: .normal)
        
        let paceMinValue = UD.shared.calculationsPaceMinValue
        let paceSecValue = UD.shared.calculationsPaceSecValue
        paceButton.setTitle(String(format: "%02d:%02d", paceMinValue, paceSecValue), for: .normal)
        
        let distanceValue = UD.shared.calculationsDistanceValue
        let distanceDecimalValue = UD.shared.calculationsDistanceDecimalValue
        distanceButton.setTitle("\(distanceValue).\(distanceDecimalValue)", for: .normal)
        
        let timeHValue = UD.shared.calculationsTimeHValue
        let timeMinValue = UD.shared.calculationsTimeMinValue
        let timeSecValue = UD.shared.calculationsTimeSecValue
        durationButton.setTitle(String(format: "%02d:%02d:%02d", timeHValue, timeMinValue, timeSecValue), for: .normal)
    }
    
    
    //MARK: - SetViews
    
    private func setViews() {
        
        effect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        clipsToBounds = true
        isHidden = true
        
        layer.instance(border: true, corner: .max)
        
        contentView.addSubview(containerView)
        contentView.addSubview(crossSeparator)
        
        setButton(button: distanceButton, titleColor: .link, alignment: .right)
        setTitle(label: distanceTitle, titleText: "Distance / km", alignment: .right)
        
        setButton(button: durationButton, titleColor: .link, alignment: .left)
        setTitle(label: durationTitle, titleText: "Time", alignment: .left)
        
        setButton(button: paceButton, titleColor: .myPaletteGold, alignment: .right)
        setTitle(label: paceTitle, titleText: "Pace", alignment: .right)
        
        setButton(button: speedButton, titleColor: .myPaletteGold, alignment: .left)
        setTitle(label: speedTitle, titleText: "Speed / km | h", alignment: .left)
        
        contentView.addSubview(eraseButton)
        contentView.addSubview(hideButton)
        
        eraseButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        hideButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
    }
    
   //MARK: - SetButton
    
    private func setButton(button: UIButton, titleColor: UIColor, alignment: UIControl.ContentHorizontalAlignment) {
        contentView.addSubview(button)
        button.disableAutoresizingMask()
        button.backgroundColor = .clear
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .medium, width: .standard)
        button.contentHorizontalAlignment = alignment
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    //MARK: - SetTitle
    
    private func setTitle(label: UILabel, titleText: String, alignment: NSTextAlignment) {
        contentView.addSubview(label)
        label.disableAutoresizingMask()
        label.instance(color: .myPaletteGray, alignment: .center, font: .condensedMid)
        label.text = titleText
        label.textAlignment = alignment
    }
    
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.heightAnchor.constraint(equalToConstant: 400),
            
            distanceButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 100),
            distanceButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            distanceButton.heightAnchor.constraint(equalToConstant: 60),
            distanceButton.widthAnchor.constraint(equalToConstant: 130),
            
            distanceTitle.centerXAnchor.constraint(equalTo: distanceButton.centerXAnchor),
            distanceTitle.bottomAnchor.constraint(equalTo: distanceButton.topAnchor, constant: -5),
            distanceTitle.widthAnchor.constraint(equalToConstant: 130),
            
            durationButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 100),
            durationButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            durationButton.heightAnchor.constraint(equalToConstant: 60),
            durationButton.widthAnchor.constraint(equalToConstant: 130),
            
            durationTitle.centerXAnchor.constraint(equalTo: durationButton.centerXAnchor),
            durationTitle.bottomAnchor.constraint(equalTo: durationButton.topAnchor, constant: -5),
            durationTitle.widthAnchor.constraint(equalToConstant: 130),
            
            paceButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -100),
            paceButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            paceButton.heightAnchor.constraint(equalToConstant: 60),
            paceButton.widthAnchor.constraint(equalToConstant: 130),
            
            paceTitle.centerXAnchor.constraint(equalTo: paceButton.centerXAnchor),
            paceTitle.topAnchor.constraint(equalTo: paceButton.bottomAnchor, constant: 5),
            paceTitle.widthAnchor.constraint(equalToConstant: 130),
            
            speedButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -100),
            speedButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            speedButton.heightAnchor.constraint(equalToConstant: 60),
            speedButton.widthAnchor.constraint(equalToConstant: 130),
            
            speedTitle.centerXAnchor.constraint(equalTo: speedButton.centerXAnchor),
            speedTitle.topAnchor.constraint(equalTo: speedButton.bottomAnchor, constant: 5),
            speedTitle.widthAnchor.constraint(equalToConstant: 130),
            
            crossSeparator.widthAnchor.constraint(equalToConstant: 42),
            crossSeparator.heightAnchor.constraint(equalToConstant: 42),
            crossSeparator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            crossSeparator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),

            hideButton.widthAnchor.constraint(equalToConstant: .iconSide),
            hideButton.heightAnchor.constraint(equalToConstant: .iconSide),
            hideButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            hideButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            eraseButton.widthAnchor.constraint(equalToConstant: 42),
            eraseButton.heightAnchor.constraint(equalToConstant: 42),
            eraseButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            eraseButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
    
}
