//
//  ActivitySelectionView.swift
//  OneDot
//
//  Created by Александр Коробицын on 11.09.2023.
//

import UIKit
import AudioToolbox

class DashboardHeaderView: UIVisualEffectView {
    
    let hapticGenerator = UISelectionFeedbackGenerator()
    
    var buttonStateHandler: ((DashboardVC.Mode)->())?
    
    private let locationStack: UIStackView = {
        let stack = UIStackView()
        stack.disableAutoresizingMask()
        stack.backgroundColor = .myPaletteGold
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 0
        stack.layer.cornerRadius = 14
        stack.layer.cornerCurve = .continuous
        return stack
    }()
    
    private let toolsStack: UIStackView = {
        let stack = UIStackView()
        stack.disableAutoresizingMask()
        stack.backgroundColor = .myPaletteGold
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 0
        stack.layer.cornerRadius = 14
        stack.layer.cornerCurve = .continuous
        return stack
    }()

    private let outdoorButton: DashboardHeaderButton = DashboardHeaderButton()
    private let indoorButton: DashboardHeaderButton = DashboardHeaderButton()
    
    private let notesButton: DashboardHeaderButton = DashboardHeaderButton()
    private let calculatorButton: DashboardHeaderButton = DashboardHeaderButton()
    private let settingsButton: DashboardHeaderButton = DashboardHeaderButton()
    
    let pickerView = DashboardHeaderPicker()
    
    private let navigationStateImageView: UIImageView = {
        let view = UIImageView()
        view.disableAutoresizingMask()
        return view
    }()
    
    enum Mode {
        case outdoor
        case indoor
        case notes
        case calculations
        case settings
        case toolsDefault
        case trackingIndication(LocationService.LocationTrackingState)
    }
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        setViews()
        setConstraints()
    }

    @objc private func buttonTapped() {
        hapticGenerator.selectionChanged()
        switch true {
        case outdoorButton.isTouchInside:
            buttonStateHandler?(.geoTrackingActive)
        case indoorButton.isTouchInside:
            buttonStateHandler?(.geoTrackingInactive)
        case notesButton.isTouchInside:
            buttonStateHandler?(.notes)
        case calculatorButton.isTouchInside:
            buttonStateHandler?(.calculations)
        case settingsButton.isTouchInside:
            buttonStateHandler?(.settings)
        default:
            break
        }
    }
    
    @objc func animateNavigationView() {
        AnimationManager.shared.animateLocator(navigationStateImageView)
    }
    
    func activateMode(mode: Mode) {
        switch mode {
            
        case .outdoor:
            
            outdoorButton.setActiveState(.outdoor)
            outdoorButton.isUserInteractionEnabled = false
            indoorButton.setInactiveState(.indoor)
            indoorButton.isUserInteractionEnabled = true
            UserDefaultsManager.shared.isGeoTracking = true
            pickerView.updatePicker(isGeoTracking: true)
            
        case .indoor:
            
            indoorButton.setActiveState(.indoor)
            indoorButton.isUserInteractionEnabled = false
            outdoorButton.setInactiveState(.outdoor)
            outdoorButton.isUserInteractionEnabled = true
            UserDefaultsManager.shared.isGeoTracking = false
            pickerView.updatePicker(isGeoTracking: false)
            
        case .notes:
            notesButton.setActiveState(.notes)
            notesButton.isUserInteractionEnabled = false
            calculatorButton.setInactiveState(.calculations)
            calculatorButton.isUserInteractionEnabled = true
            settingsButton.setInactiveState(.settings)
            settingsButton.isUserInteractionEnabled = true
            
        case .calculations:
            calculatorButton.setActiveState(.calculations)
            calculatorButton.isUserInteractionEnabled = false
            notesButton.setInactiveState(.notes)
            notesButton.isUserInteractionEnabled = true
            settingsButton.setInactiveState(.settings)
            settingsButton.isUserInteractionEnabled = true
            
        case .settings:
            settingsButton.setActiveState(.settings)
            settingsButton.isUserInteractionEnabled = false
            notesButton.setInactiveState(.notes)
            notesButton.isUserInteractionEnabled = true
            calculatorButton.setInactiveState(.calculations)
            calculatorButton.isUserInteractionEnabled = true
        case .toolsDefault:
            notesButton.setInactiveState(.notes)
            notesButton.isUserInteractionEnabled = true
            calculatorButton.setInactiveState(.calculations)
            calculatorButton.isUserInteractionEnabled = true
            settingsButton.setInactiveState(.settings)
            settingsButton.isUserInteractionEnabled = true
        case .trackingIndication(let state):
            switch state {
            case .goodSignal:
                navigationStateImageView.image = UIImage(named: "navigationGreen")
            case .poorSignal:
                navigationStateImageView.image = UIImage(named: "navigationYellow")
            case .locationDisabled:
                navigationStateImageView.image = UIImage(named: "navigationRed")
            }
        }
    }
    
    
    //MARK: - SetViews
    private func setViews() {
        effect = UIBlurEffect(style: .extraLight)
        clipsToBounds = true
        layer.instance(border: true, corner: .max)

        locationStack.addArrangedSubview(outdoorButton)
        locationStack.addArrangedSubview(indoorButton)
        contentView.addSubview(locationStack)
        
        toolsStack.addArrangedSubview(notesButton)
        toolsStack.addArrangedSubview(calculatorButton)
        toolsStack.addArrangedSubview(settingsButton)
        contentView.addSubview(toolsStack)
        
        contentView.addSubview(navigationStateImageView)
        contentView.addSubview(pickerView)
        
        [outdoorButton, indoorButton, notesButton, calculatorButton, settingsButton].forEach {
            $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {

        navigationStateImageView.disableAutoresizingMask()
        pickerView.disableAutoresizingMask()
        
        NSLayoutConstraint.activate([
            locationStack.widthAnchor.constraint(equalToConstant: 42 * CGFloat(locationStack.subviews.count)),
            locationStack.heightAnchor.constraint(equalToConstant: 42),
            locationStack.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            locationStack.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -CGFloat.barWidth / 4),
            
            toolsStack.widthAnchor.constraint(equalToConstant: 42 * CGFloat(toolsStack.subviews.count)),
            toolsStack.heightAnchor.constraint(equalToConstant: 42),
            toolsStack.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            toolsStack.centerXAnchor.constraint(equalTo: centerXAnchor, constant: CGFloat.barWidth / 4),
         
            pickerView.widthAnchor.constraint(equalToConstant: CGFloat.barWidth),
            pickerView.heightAnchor.constraint(equalToConstant: 50),
            pickerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            pickerView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: CGFloat.headerBarHeight / 4),
            
            navigationStateImageView.centerYAnchor.constraint(equalTo: locationStack.centerYAnchor),
            navigationStateImageView.trailingAnchor.constraint(equalTo: locationStack.leadingAnchor),
            navigationStateImageView.widthAnchor.constraint(equalToConstant: 42),
            navigationStateImageView.heightAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
