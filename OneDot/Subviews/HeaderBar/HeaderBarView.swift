//
//  ActivitySelectionView.swift
//  OneDot
//
//  Created by Александр Коробицын on 11.09.2023.
//

import UIKit
import AudioToolbox

class HeaderBarView: UIView {
    
    var buttonStateHandler: ((MainVC.ViewsState)->())?

    private let feedbackGen = UISelectionFeedbackGenerator()

    private let exercises = FactoryExercises()
    private var currentExercise: Exercise?
    
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
   
    override init(frame: CGRect) {
        super.init(frame: frame)

        setViews()
        setConstraints()
        didBecomeObserver()

        pickerView.completion = { [weak self] exercise in
            guard let self else { return }
            currentExercise = exercise
            print(exercise.titleName)
        }
        
        UserDefaultsManager.shared.userIndoorStatus ? activateIndoorMode() : activateOutdoorMode()
    }
    
    //MARK: - SetButtons
    
    private func setButtonTargets() {
        
        [outdoorButton, indoorButton, notesButton, calculatorButton, settingsButton].forEach {
            $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }

    }
    
    private func clearButtonStates() {
            outdoorButton.setInactiveState(.outdoor)
            indoorButton.setInactiveState(.indoor)
            notesButton.setInactiveState(.notesOutdoor)
            calculatorButton.setImage(UIImage(named: "SSCalculator"), for: .normal)
            settingsButton.setImage(UIImage(named: "SSSettings"), for: .normal)
    }

    @objc private func buttonTapped() {
        switch true {
        case outdoorButton.isTouchInside:
            activateOutdoorMode()
        case indoorButton.isTouchInside:
            activateIndoorMode()
        case notesButton.isTouchInside:
            activateNotesMode()
        case calculatorButton.isTouchInside:
            activateCalculatorMode()
        case settingsButton.isTouchInside:
            activateSettingsMode()
        default:
            break
        }
    }
    
    func activateOutdoorMode() {
        clearButtonStates()
        outdoorButton.setActiveState(.outdoor)
        notesButton.isUserInteractionEnabled = true
        buttonStateHandler?(.outdoor)
        
        pickerView.currentLocation = "street"
        pickerView.picker.reloadAllComponents()
        
        UserDefaultsManager.shared.userIndoorStatus = false
        
        let row = UserDefaultsManager.shared.pickerRowOutdoor
        pickerView.picker.selectRow(row, inComponent: 0, animated: true)
        currentExercise = exercises.get(.street)[row]
        pickerView.title.text = currentExercise?.titleName
    }
    
    private func activateIndoorMode() {
        clearButtonStates()
        indoorButton.setActiveState(.indoor)
        notesButton.setActiveState(.notesIndoor)
        notesButton.isUserInteractionEnabled = false
        buttonStateHandler?(.indoor)
        
        pickerView.currentLocation = "room"
        pickerView.picker.reloadAllComponents()
        UserDefaultsManager.shared.userIndoorStatus = true
        
        let row = UserDefaultsManager.shared.pickerRowIndoor
        pickerView.picker.selectRow(row, inComponent: 0, animated: true)
        currentExercise = nil
        currentExercise = exercises.get(.room)[row]
        pickerView.title.text = currentExercise?.titleName
    }
    
    private func activateNotesMode() {
        clearButtonStates()
        outdoorButton.setActiveState(.outdoor)
        notesButton.setActiveState(.notesOutdoor)
        buttonStateHandler?(.notes)
    }
    
    private func activateCalculatorMode() {
        buttonStateHandler?(.calculator)
    }
    
    private func activateSettingsMode() {
        buttonStateHandler?(.settings)
    }
    
    //MARK: - ExerciseStates
    
//    private func setExerciseState(indoor: Bool) {
//        feedbackGen.selectionChanged()
//        gpsView.isHidden = indoor
//        
//        if indoor == true {
//            pickerView.currentLocation = "room"
//            pickerView.picker.reloadAllComponents()
//            UserDefaultsManager.shared.userIndoorStatus = true
//            
//            let row = UserDefaultsManager.shared.pickerRowIndoor
//            pickerView.picker.selectRow(row, inComponent: 0, animated: true)
//            currentExercise = nil
//            currentExercise = exercises.get(.room)[row]
//            pickerView.title.text = currentExercise?.titleName
//            pickerView.titleView.image = UIImage(named: currentExercise?.titleIcon ?? "")
//        } else {
//            pickerView.currentLocation = "street"
//            pickerView.picker.reloadAllComponents()
//            
//            UserDefaultsManager.shared.userIndoorStatus = false
//            
//            let row = UserDefaultsManager.shared.pickerRowOutdoor
//            pickerView.picker.selectRow(row, inComponent: 0, animated: true)
//            currentExercise = exercises.get(.street)[row]
//            pickerView.title.text = currentExercise?.titleName
//            pickerView.titleView.image = UIImage(named: currentExercise?.titleIcon ?? "")
//        }
//    }
    
    
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
        
        setButtonTargets()
        
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
