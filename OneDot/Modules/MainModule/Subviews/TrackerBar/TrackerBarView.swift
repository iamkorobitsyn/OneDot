//
//  ActivitySelectionView.swift
//  OneDot
//
//  Created by Александр Коробицын on 11.09.2023.
//

import UIKit
import AudioToolbox

class TrackerBarView: UIView {
    
    var buttonStateHandler: ((UIButton)->())?

    private let feedbackGen = UISelectionFeedbackGenerator()

    private let exercises = FactoryExercises()
    private var currentExercise: Exercise?
    
    private let visualEffectView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.effect = UIBlurEffect(style: .light)
        view.frame = CGRect(x: 0, y: 0,
                            width: CGFloat.barWidth,
                            height: CGFloat.trackerBarHeight)
        view.clipsToBounds = true
        view.layer.cornerRadius = CGFloat.barCorner
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    private let locationStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .myPaletteGold
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 0
        stack.layer.cornerRadius = CGFloat.iconSide / 2
        return stack
    }()
    
    let gpsView: TrackerBarGPS = {
        let view = TrackerBarGPS()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let pickerView: TrackerBarPickerView = {
        let view = TrackerBarPickerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .none
        return view
    }()

    
    let outdoorButton: TrackerBarButton = TrackerBarButton()
    let indoorButton: TrackerBarButton = TrackerBarButton()
    let notesButton: TrackerBarButton = TrackerBarButton()
    
    let calculatorButton: TrackerBarButton = TrackerBarButton()
    let settingsButton: TrackerBarButton = TrackerBarButton()
    let toolsStackSeparator: CAShapeLayer = CAShapeLayer()
    
    
    
   
    override init(frame: CGRect) {
        super.init(frame: frame)

        setButtonTargets()
        statesRefresh(locations: true, tools: true)
        setViews()
        setConstraints()
        didBecomeObserver()
        
        setExerciseState(indoor: UserDefaultsManager.shared.userIndoorStatus)
        
        pickerView.completion = { [weak self] exercise in
            guard let self else { return }
            currentExercise = exercise
            print(exercise.titleName)
        }
        
        Shaper.shared.drawToolsStackSeparator(shape: toolsStackSeparator, view: self)
    }

    
    //MARK: - RefreshButtons
    
    func statesRefresh(locations: Bool, tools: Bool) {
        if locations != false {
            outdoorButton.setInactiveState(.outdoor)
            indoorButton.setInactiveState(.indoor)
        }
        if tools != false {
            calculatorButton.setInactiveState(.calculator)
            settingsButton.setInactiveState(.themes)
        }
    }
    
    
    //MARK: - Targets
    
    private func setButtonTargets() {
        
        outdoorButton.addTarget(self, action: #selector(buttonTapped),
                                for: .touchUpInside)
        indoorButton.addTarget(self, action: #selector(buttonTapped),
                               for: .touchUpInside)
        calculatorButton.addTarget(self, action: #selector(buttonTapped),
                                   for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(buttonTapped),
                               for: .touchUpInside)
        notesButton.addTarget(self, action: #selector(buttonTapped),
                              for: .touchUpInside)
    }
    
    //MARK: - ButtonTapped
    
    @objc private func buttonTapped() {
        
        if calculatorButton.isTouchInside {

            statesRefresh(locations: false, tools: true)
            calculatorButton.setActiveState(.calculator)
            buttonStateHandler?(calculatorButton)
 
        } else if settingsButton.isTouchInside {
            
            statesRefresh(locations: false, tools: true)
            settingsButton.setActiveState(.themes)
            buttonStateHandler?(settingsButton)

        } else if outdoorButton.isTouchInside {
            buttonStateHandler?(outdoorButton)
            setExerciseState(indoor: false)
        } else if indoorButton.isTouchInside {
            buttonStateHandler?(indoorButton)
            setExerciseState(indoor: true)
        } else if notesButton.isTouchInside {
            if gpsView.isHidden == false {
                notesButton.setActiveState(.notesOutdoor)
                buttonStateHandler?(notesButton)
            }
        }
    }
    
    //MARK: - ExerciseStates
    
    private func setExerciseState(indoor: Bool) {
        feedbackGen.selectionChanged()
        gpsView.isHidden = indoor
        
        if indoor == true {
            pickerView.currentLocation = "room"
            pickerView.picker.reloadAllComponents()
            statesRefresh(locations: true, tools: false)
            indoorButton.setActiveState(.indoor)
            notesButton.setActiveState(.notesIndoor)
            UserDefaultsManager.shared.userIndoorStatus = true
            
            let row = UserDefaultsManager.shared.pickerRowIndoor
            pickerView.picker.selectRow(row, inComponent: 0, animated: true)
            currentExercise = nil
            currentExercise = exercises.get(.room)[row]
            pickerView.title.text = currentExercise?.titleName
            pickerView.titleView.image = UIImage(named: currentExercise?.titleIcon ?? "")
        } else {
            pickerView.currentLocation = "street"
            pickerView.picker.reloadAllComponents()
            statesRefresh(locations: true, tools: false)
            outdoorButton.setActiveState(.outdoor)
            notesButton.setInactiveState(.notesIndoor)
            
            UserDefaultsManager.shared.userIndoorStatus = false
            
            let row = UserDefaultsManager.shared.pickerRowOutdoor
            pickerView.picker.selectRow(row, inComponent: 0, animated: true)
            currentExercise = exercises.get(.street)[row]
            pickerView.title.text = currentExercise?.titleName
            pickerView.titleView.image = UIImage(named: currentExercise?.titleIcon ?? "")
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

        addSubview(gpsView)
    
        addSubview(pickerView)
        

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
        Animator.shared.animateGPSCursor(gpsView.satelliteIcon)
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        
        calculatorButton.disableAutoresizingMask()
        settingsButton.disableAutoresizingMask()
        
        NSLayoutConstraint.activate([
            locationStack.widthAnchor.constraint(equalToConstant:
                                            42 * CGFloat(locationStack.subviews.count)),
            locationStack.heightAnchor.constraint(equalToConstant: 42),
            locationStack.topAnchor.constraint(equalTo: topAnchor,
                                            constant: 15),
            locationStack.centerXAnchor.constraint(equalTo: centerXAnchor,
                                            constant: -CGFloat.barWidth / 4),
            
            calculatorButton.widthAnchor.constraint(equalToConstant: 42),
            calculatorButton.heightAnchor.constraint(equalToConstant: 42),
            calculatorButton.centerYAnchor.constraint(equalTo: locationStack.centerYAnchor),
            calculatorButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: .barWidth / 4 - 42),
            
            settingsButton.widthAnchor.constraint(equalToConstant: 42),
            settingsButton.heightAnchor.constraint(equalToConstant: 42),
            settingsButton.centerYAnchor.constraint(equalTo: locationStack.centerYAnchor),
            settingsButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: .barWidth / 4 + 42),
         
            pickerView.widthAnchor.constraint(equalToConstant:
                                            CGFloat.barWidth),
            pickerView.heightAnchor.constraint(equalToConstant: 50),
            pickerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            pickerView.centerYAnchor.constraint(equalTo: centerYAnchor,
                                            constant: CGFloat.trackerBarHeight / 4),
            
            gpsView.topAnchor.constraint(equalTo: locationStack.bottomAnchor,
                                            constant: 5),
            gpsView.leadingAnchor.constraint(equalTo: locationStack.leadingAnchor, constant: 13),
            gpsView.widthAnchor.constraint(equalToConstant: 30),
            gpsView.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
