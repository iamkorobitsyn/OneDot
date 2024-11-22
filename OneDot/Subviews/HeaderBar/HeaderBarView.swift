//
//  ActivitySelectionView.swift
//  OneDot
//
//  Created by Александр Коробицын on 11.09.2023.
//

import UIKit
import AudioToolbox

class HeaderBarView: UIView {
    
    var buttonStateHandler: ((MainVC.MainVCMode)->())?

    private let feedbackGen = UISelectionFeedbackGenerator()
    
    private let visualEffectView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.effect = UIBlurEffect(style: .light)
        view.frame = CGRect(x: 0, y: 0,
                            width: CGFloat.barWidth,
                            height: CGFloat.headerBarHeight)
        view.clipsToBounds = true
        view.layer.cornerRadius = CGFloat.barCorner
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    private let locationStack: UIStackView = {
        let stack = UIStackView()
        stack.disableAutoresizingMask()
        stack.backgroundColor = .myPaletteGold
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 0
        stack.layer.cornerRadius = CGFloat.iconSide / 2
        return stack
    }()

    private let outdoorButton: HeaderBarButton = HeaderBarButton()
    private let indoorButton: HeaderBarButton = HeaderBarButton()
    private let notesButton: HeaderBarButton = HeaderBarButton()
    
    private let calculatorButton: HeaderBarButton = HeaderBarButton()
    private let settingsButton: HeaderBarButton = HeaderBarButton()
    private let toolsStackSeparator: CAShapeLayer = CAShapeLayer()
    
    let pickerView = HeaderBarPickerView()
    
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
   
    override init(frame: CGRect) {
        super.init(frame: frame)

        setViews()
        setConstraints()
        didBecomeObserver()
    }

    @objc private func buttonTapped() {
        switch true {
        case outdoorButton.isTouchInside:
            buttonStateHandler?(.outdoor)
        case indoorButton.isTouchInside:
            buttonStateHandler?(.indoor)
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

            pickerView.updatePicker(outdoorIs: true, row: UserDefaultsManager.shared.pickerRowOutdoor)
            
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
            
            pickerView.updatePicker(outdoorIs: false, row: UserDefaultsManager.shared.pickerRowIndoor)

        case .calculations:
            print("work")
        case .settings:
            print("work")
            
        }
    }
    
    
    //MARK: - SetViews
    private func setViews() {
        layer.cornerRadius = CGFloat.barCorner
        layer.cornerCurve = .continuous
        layer.borderWidth = 0.3
        layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        
        addSubview(visualEffectView)

        locationStack.addArrangedSubview(outdoorButton)
        locationStack.addArrangedSubview(indoorButton)
        locationStack.addArrangedSubview(notesButton)
        addSubview(locationStack)
        
        addSubview(calculatorButton)
        addSubview(settingsButton)
        addSubview(locatorView)
        addSubview(pickerView)
        
        [outdoorButton, indoorButton, notesButton, calculatorButton, settingsButton].forEach {
            $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
        
        calculatorButton.setImage(UIImage(named: "SSCalculator"), for: .normal)
        settingsButton.setImage(UIImage(named: "SSSettings"), for: .normal)
        
        Shaper.shared.drawToolsStackSeparator(shape: toolsStackSeparator, view: self)
        Shaper.shared.drawLocatorDotShape(shape: locatorDotShape, view: locatorView)
        Shaper.shared.drawLocatorFirstSircleShape(shape: locatorFirstCircleShape, view: locatorView)
        Shaper.shared.drawLocatorSecondSircleShape(shape: locatorSecondCircleShape, view: locatorView)
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
        Animator.shared.animateLocator(locatorFirstCircleShape, locatorSecondCircleShape)
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
