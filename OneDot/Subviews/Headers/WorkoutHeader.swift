//
//  ActivitySelectionView.swift
//  OneDot
//
//  Created by Александр Коробицын on 11.09.2023.
//

import UIKit
import AudioToolbox

class WorkoutHeader: UIVisualEffectView {
    
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

    private let outdoorButton: WorkoutHeaderButton = WorkoutHeaderButton()
    private let indoorButton: WorkoutHeaderButton = WorkoutHeaderButton()
    private let notesButton: WorkoutHeaderButton = WorkoutHeaderButton()
    
    private let calculatorButton: WorkoutHeaderButton = WorkoutHeaderButton()
    private let settingsButton: WorkoutHeaderButton = WorkoutHeaderButton()
    private let toolsStackSeparator: CAShapeLayer = CAShapeLayer()
    
    let pickerView = WorkoutHeaderPicker()
    
    let locatorView = UIView()
    private let locatorDotShape: CAShapeLayer = CAShapeLayer()
    private let locatorFirstCircleShape: CAShapeLayer = CAShapeLayer()
    private let locatorSecondCircleShape: CAShapeLayer = CAShapeLayer()
    
    enum Mode {
        case outdoor
        case outdoorNotes
        case indoor
        case calculations
        case settings
        
    }
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        setViews()
        setConstraints()
        didBecomeObserver()
    }

    @objc private func buttonTapped() {
        switch true {
        case outdoorButton.isTouchInside:
            buttonStateHandler?(.geoTrackingActive)
        case indoorButton.isTouchInside:
            buttonStateHandler?(.geoTrackingInactive)
        case notesButton.isTouchInside:
            buttonStateHandler?(.outdoorNotes)
        case calculatorButton.isTouchInside:
            buttonStateHandler?(.calculations)
        case settingsButton.isTouchInside:
            buttonStateHandler?(.settings)
        default:
            break
        }
    }
    
    func activateMode(mode: Mode) {
        switch mode {
            
        case .outdoor:
            
            outdoorButton.setActiveState(.outdoor)
            outdoorButton.isUserInteractionEnabled = false
            indoorButton.setInactiveState(.indoor)
            indoorButton.isUserInteractionEnabled = true
            notesButton.setInactiveState(.notesOutdoor)
            notesButton.isUserInteractionEnabled = true

            
            UserDefaultsManager.shared.isGeoTracking = true
            pickerView.updatePicker(isGeoTracking: true)
            
        case .outdoorNotes:
            outdoorButton.setActiveState(.outdoor)
            outdoorButton.isUserInteractionEnabled = false
            notesButton.setActiveState(.notesOutdoor)
            notesButton.isUserInteractionEnabled = false
            
            
        case .indoor:
            
            indoorButton.setActiveState(.indoor)
            notesButton.setActiveState(.notesIndoor)
            indoorButton.isUserInteractionEnabled = false
            notesButton.isUserInteractionEnabled = false
            outdoorButton.setInactiveState(.outdoor)
            outdoorButton.isUserInteractionEnabled = true
            
            UserDefaultsManager.shared.isGeoTracking = false
            pickerView.updatePicker(isGeoTracking: false)
            
        case .calculations:
            print("calculations")
        case .settings:
            print("settings")
            
        }
    }
    
    
    //MARK: - SetViews
    private func setViews() {
        effect = UIBlurEffect(style: .extraLight)
        clipsToBounds = true
        layer.instance(border: true, corner: .max)

        locationStack.addArrangedSubview(outdoorButton)
        locationStack.addArrangedSubview(indoorButton)
        locationStack.addArrangedSubview(notesButton)
        contentView.addSubview(locationStack)
        
        contentView.addSubview(calculatorButton)
        contentView.addSubview(settingsButton)
        contentView.addSubview(locatorView)
        contentView.addSubview(pickerView)
        
        [outdoorButton, indoorButton, notesButton, calculatorButton, settingsButton].forEach {
            $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
        
        calculatorButton.setImage(UIImage(named: "HeaderCalculator"), for: .normal)
        settingsButton.setImage(UIImage(named: "HeaderSettings"), for: .normal)
        
        ShapeManager.shared.drawToolsStackSeparator(shape: toolsStackSeparator, view: self)
        ShapeManager.shared.drawLocatorDotShape(shape: locatorDotShape, view: locatorView)
        ShapeManager.shared.drawLocatorFirstSircleShape(shape: locatorFirstCircleShape, view: locatorView)
        ShapeManager.shared.drawLocatorSecondSircleShape(shape: locatorSecondCircleShape, view: locatorView)
    }
    
    //MARK: - NavigationControllerObserver
    
    private func didBecomeObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(animations),
                                               name: UIApplication.didBecomeActiveNotification ,
                                               object: nil)
    }
    
    //MARK: - ObserverAnimation
    
    @objc private func animations() {
        AnimationManager.shared.animateLocator(locatorFirstCircleShape, locatorSecondCircleShape)
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        
        calculatorButton.disableAutoresizingMask()
        settingsButton.disableAutoresizingMask()
        locatorView.disableAutoresizingMask()
        pickerView.disableAutoresizingMask()
        
        NSLayoutConstraint.activate([
            locationStack.widthAnchor.constraint(equalToConstant: 42 * CGFloat(locationStack.subviews.count)),
            locationStack.heightAnchor.constraint(equalToConstant: 42),
            locationStack.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            locationStack.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -CGFloat.barWidth / 4),
            
            calculatorButton.widthAnchor.constraint(equalToConstant: 42),
            calculatorButton.heightAnchor.constraint(equalToConstant: 42),
            calculatorButton.centerYAnchor.constraint(equalTo: locationStack.centerYAnchor),
            calculatorButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: .barWidth / 4 - 30),
            
            settingsButton.widthAnchor.constraint(equalToConstant: 42),
            settingsButton.heightAnchor.constraint(equalToConstant: 42),
            settingsButton.centerYAnchor.constraint(equalTo: locationStack.centerYAnchor),
            settingsButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: .barWidth / 4 + 30),
         
            pickerView.widthAnchor.constraint(equalToConstant: CGFloat.barWidth),
            pickerView.heightAnchor.constraint(equalToConstant: 50),
            pickerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            pickerView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: CGFloat.headerBarHeight / 4),
            
            locatorView.centerYAnchor.constraint(equalTo: locationStack.centerYAnchor),
            locatorView.trailingAnchor.constraint(equalTo: locationStack.leadingAnchor, constant: -8),
            locatorView.widthAnchor.constraint(equalToConstant: 12),
            locatorView.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
