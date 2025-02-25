//
//  CalculationsViewCell.swift
//  OneDot
//
//  Created by Александр Коробицын on 11.01.2024.
//

import UIKit

class CalculationsBodyView: UIVisualEffectView {
    
    let hapticGenerator = UISelectionFeedbackGenerator()
    var hideHandler: (() -> Void)?
    
    private let valuesContainerView = UIVisualEffectView()
    private let separator: CAShapeLayer = CAShapeLayer()
    
    private let distanceButton: UIButton = UIButton()
    private let distanceTitle: UILabel = UILabel()
    
    private let timeButton: UIButton = UIButton()
    private let durationTitle: UILabel = UILabel()
    
    private let paceButton: UIButton = UIButton()
    private let paceTitle: UILabel = UILabel()
    
    private let speedButton: UIButton = UIButton()
    private let speedTitle: UILabel = UILabel()
    
    private let eraseButton: UIButton = UIButton()
    private let hideButton: UIButton = UIButton()

    private let calculationsPicker: CalculationsPicker = CalculationsPicker()
    
    //MARK: - Init
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        
        setViews()
        setConstraints()
        updateValues()
        
        calculationsPicker.valueStateHandler = { self.updateValues() }
    }
    
    override func layoutSubviews() {
        GraphicsService.shared.drawShape(shape: separator, shapeType: .crossSeparator(color: .myPaletteGray), view: valuesContainerView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - ButtonTapped
    
    @objc private func buttonTapped(_ sender: UIButton) {
        [speedTitle, paceTitle, distanceTitle, durationTitle].forEach({$0.textColor = .myPaletteGray})
        hapticGenerator.selectionChanged()
        switch sender {
        case distanceButton:
            calculationsPicker.activateMode(mode: .pickerDistance)
            distanceTitle.textColor = .myPaletteGold
        case timeButton:
            calculationsPicker.activateMode(mode: .PickerTime)
            durationTitle.textColor = .myPaletteGold
        case speedButton:
            calculationsPicker.activateMode(mode: .pickerSpeed)
            speedTitle.textColor = .myPaletteGold
        case paceButton:
            calculationsPicker.activateMode(mode: .pickerPace)
            paceTitle.textColor = .myPaletteGold
        case eraseButton:
            CalculationsService.shared.resetValues()
            calculationsPicker.activateMode(mode: .pickerDistance)
            distanceTitle.textColor = .myPaletteGold
            updateValues()
        default: break
        }
    }
    
    //MARK: - Present
    
    @objc private func hide() {
        hideHandler?()
    }
    
    func present(_ state: Bool) {
        self.isHidden = state ? false : true
        updateValues()
    }
    
    //MARK: - UpdateValues
    
    private func updateValues() {
        let isDistanceValue = UserDefaultsManager.shared.calculationsDistanceValue == 0 && UserDefaultsManager.shared.calculationsDistanceDecimalValue == 0
        updateButtonStates(clean: isDistanceValue)
        updateButtonTitles()
    }
    
    
    
    private func updateButtonStates(clean: Bool) {
        let alpha: CGFloat = clean ? 0.5 : 1
        [speedButton, timeButton, paceButton, eraseButton].forEach {
            $0.isUserInteractionEnabled = !clean
            $0.alpha = alpha }
    }
    
    private func updateButtonTitles() {
        let speedValue = UserDefaultsManager.shared.calculationsSpeedValue
        let speedDecimalValue = UserDefaultsManager.shared.calculationsSpeedDecimalValue
        speedButton.setTitle("\(speedValue).\(speedDecimalValue)", for: .normal)
        
        let paceMinValue = UserDefaultsManager.shared.calculationsPaceMinValue
        let paceSecValue = UserDefaultsManager.shared.calculationsPaceSecValue
        paceButton.setTitle(String(format: "%02d:%02d", paceMinValue, paceSecValue), for: .normal)
        
        let distanceValue = UserDefaultsManager.shared.calculationsDistanceValue
        let distanceDecimalValue = UserDefaultsManager.shared.calculationsDistanceDecimalValue
        distanceButton.setTitle("\(distanceValue).\(distanceDecimalValue)", for: .normal)
        
        let timeHValue = UserDefaultsManager.shared.calculationsTimeHValue
        let timeMinValue = UserDefaultsManager.shared.calculationsTimeMinValue
        let timeSecValue = UserDefaultsManager.shared.calculationsTimeSecValue
        timeButton.setTitle(String(format: "%02d:%02d:%02d", timeHValue, timeMinValue, timeSecValue), for: .normal)
    }
    
    
    //MARK: - SetViews
    
    private func setViews() {
        
        effect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        clipsToBounds = true
        isHidden = true
        layer.instance(border: true, corner: .max)

        valuesContainerView.effect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        valuesContainerView.clipsToBounds = true
        valuesContainerView.layer.instance(border: true, corner: .min)
        
        [valuesContainerView, calculationsPicker, eraseButton, hideButton].forEach { view in
            contentView.addSubview(view)
            view.disableAutoresizingMask()
        }
        
        setValueButton(button: distanceButton, alignment: .right)
        setValueButton(button: timeButton, alignment: .left)
        setValueButton(button: paceButton, alignment: .right)
        setValueButton(button: speedButton, alignment: .left)
        
        setTitle(label: distanceTitle, color: .myPaletteGold, titleText: "Distance / km", alignment: .right)
        setTitle(label: durationTitle, color: .myPaletteGray, titleText: "Time", alignment: .left)
        setTitle(label: paceTitle, color: .myPaletteGray, titleText: "min / km", alignment: .right)
        setTitle(label: speedTitle, color: .myPaletteGray, titleText: "km / h", alignment: .left)
        
        
        
        eraseButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        eraseButton.setImage(UIImage(named: "BodyEraseActive"), for: .normal)
        hideButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
        hideButton.setImage(UIImage(named: "BodyHide"), for: .normal)
    }
    
   //MARK: - SetButton
    
    private func setValueButton(button: UIButton, alignment: UIControl.ContentHorizontalAlignment) {
        contentView.addSubview(button)
        button.disableAutoresizingMask()
        button.setTitleColor(.link, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .medium, width: .standard)
        button.contentHorizontalAlignment = alignment
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    //MARK: - SetTitle
    
    private func setTitle(label: UILabel, color: UIColor, titleText: String, alignment: NSTextAlignment) {
        contentView.addSubview(label)
        label.disableAutoresizingMask()
        label.instance(color: color, alignment: .center, font: .condensedMid)
        label.text = titleText
        label.textAlignment = alignment
    }
    
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            valuesContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            valuesContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60),
            valuesContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            valuesContainerView.heightAnchor.constraint(equalToConstant: 400),
            
            calculationsPicker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            calculationsPicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60),
            calculationsPicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 60),
            calculationsPicker.heightAnchor.constraint(equalToConstant: .bottomBarHeight),
            
            distanceButton.heightAnchor.constraint(equalToConstant: 100),
            distanceButton.widthAnchor.constraint(equalToConstant: 120),
            distanceButton.centerYAnchor.constraint(equalTo: valuesContainerView.centerYAnchor, constant: -70),
            distanceButton.centerXAnchor.constraint(equalTo: valuesContainerView.centerXAnchor, constant: -80),
            
            distanceTitle.centerXAnchor.constraint(equalTo: distanceButton.centerXAnchor),
            distanceTitle.topAnchor.constraint(equalTo: distanceButton.topAnchor),
            distanceTitle.widthAnchor.constraint(equalToConstant: 120),
            
            
            timeButton.heightAnchor.constraint(equalToConstant: 100),
            timeButton.widthAnchor.constraint(equalToConstant: 120),
            timeButton.centerYAnchor.constraint(equalTo: valuesContainerView.centerYAnchor, constant: -70),
            timeButton.centerXAnchor.constraint(equalTo: valuesContainerView.centerXAnchor, constant: 80),
            
            durationTitle.centerXAnchor.constraint(equalTo: timeButton.centerXAnchor),
            durationTitle.topAnchor.constraint(equalTo: timeButton.topAnchor),
            durationTitle.widthAnchor.constraint(equalToConstant: 120),
            
            
            paceButton.heightAnchor.constraint(equalToConstant: 100),
            paceButton.widthAnchor.constraint(equalToConstant: 120),
            paceButton.centerYAnchor.constraint(equalTo: valuesContainerView.centerYAnchor, constant: 70),
            paceButton.centerXAnchor.constraint(equalTo: valuesContainerView.centerXAnchor, constant: -80),
            
            paceTitle.centerXAnchor.constraint(equalTo: paceButton.centerXAnchor),
            paceTitle.bottomAnchor.constraint(equalTo: paceButton.bottomAnchor),
            paceTitle.widthAnchor.constraint(equalToConstant: 120),
            
            
            speedButton.heightAnchor.constraint(equalToConstant: 100),
            speedButton.widthAnchor.constraint(equalToConstant: 120),
            speedButton.centerYAnchor.constraint(equalTo: valuesContainerView.centerYAnchor, constant: 70),
            speedButton.centerXAnchor.constraint(equalTo: valuesContainerView.centerXAnchor, constant: 80),
            
            speedTitle.centerXAnchor.constraint(equalTo: speedButton.centerXAnchor),
            speedTitle.bottomAnchor.constraint(equalTo: speedButton.bottomAnchor),
            speedTitle.widthAnchor.constraint(equalToConstant: 120),
            
            hideButton.widthAnchor.constraint(equalToConstant: .iconSide),
            hideButton.heightAnchor.constraint(equalToConstant: .iconSide),
            hideButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            hideButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            eraseButton.widthAnchor.constraint(equalToConstant: 42),
            eraseButton.heightAnchor.constraint(equalToConstant: 42),
            eraseButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            eraseButton.bottomAnchor.constraint(equalTo: valuesContainerView.bottomAnchor)
        ])
    }
    
}
