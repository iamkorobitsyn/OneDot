//
//  ActivitySelectionView.swift
//  OneDot
//
//  Created by Александр Коробицын on 11.09.2023.
//

import UIKit
import AudioToolbox

class TrackerBarView: UIView {
    
    var completionForActiveButton: ((UIButton)->())?

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
    
    private let toolsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .black
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 0
        stack.layer.cornerRadius = CGFloat.iconSide / 2
        return stack
    }()
    
    let toolsTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium, width: .compressed)
        label.textColor = .gray
        return label
    }()
    
    let gpsView: TrackerBarGPS = {
        let view = TrackerBarGPS()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let settingsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "trackerBarSettingsIcon"), for: .normal)
        return button
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
    let soundButton: TrackerBarButton = TrackerBarButton()
    let themesButton: TrackerBarButton = TrackerBarButton()
    
   
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
    }

    
    //MARK: - RefreshButtons
    
    func statesRefresh(locations: Bool, tools: Bool) {
        if locations != false {
            outdoorButton.setInactiveState(.outdoor)
            indoorButton.setInactiveState(.indoor)
        }
        if tools != false {
            calculatorButton.setInactiveState(.calculator)
            soundButton.setInactiveState(.sound)
            themesButton.setInactiveState(.themes)
            toolsTitle.text = ""
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
        soundButton.addTarget(self, action: #selector(buttonTapped),
                              for: .touchUpInside)
        themesButton.addTarget(self, action: #selector(buttonTapped),
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
            completionForActiveButton?(calculatorButton)
 
        } else if  soundButton.isTouchInside {
            completionForActiveButton?(soundButton)
            
            statesRefresh(locations: false, tools: true)
            soundButton.setActiveState(.sound)
            toolsTitle.text = "MUSIC"

        } else if  themesButton.isTouchInside {
            
            statesRefresh(locations: false, tools: true)
            themesButton.setActiveState(.themes)
            completionForActiveButton?(themesButton)

        } else if settingsButton.isTouchInside {
            completionForActiveButton?(settingsButton)
            
        } else if outdoorButton.isTouchInside {
            completionForActiveButton?(outdoorButton)
            setExerciseState(indoor: false)
        } else if indoorButton.isTouchInside {
            completionForActiveButton?(indoorButton)
            setExerciseState(indoor: true)
        } else if notesButton.isTouchInside {
            if gpsView.isHidden == false {
                notesButton.setActiveState(.notesOutdoor)
                completionForActiveButton?(notesButton)
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
        
        toolsStack.addArrangedSubview(calculatorButton)
        toolsStack.addArrangedSubview(soundButton)
        toolsStack.addArrangedSubview(themesButton)
        addSubview(toolsStack)
        
        addSubview(gpsView)
        addSubview(settingsButton)
        
        addSubview(toolsTitle)
    
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
        
        NSLayoutConstraint.activate([
            locationStack.widthAnchor.constraint(equalToConstant:
                                            42 * CGFloat(locationStack.subviews.count)),
            locationStack.heightAnchor.constraint(equalToConstant: 42),
            locationStack.topAnchor.constraint(equalTo: topAnchor,
                                            constant: 15),
            locationStack.centerXAnchor.constraint(equalTo: centerXAnchor,
                                            constant: -CGFloat.barWidth / 4 + 5),
            
            toolsStack.widthAnchor.constraint(equalToConstant:
                                            42 * CGFloat(toolsStack.subviews.count)),
            toolsStack.heightAnchor.constraint(equalToConstant: 42),
            toolsStack.topAnchor.constraint(equalTo: topAnchor,
                                            constant: 15),
            toolsStack.leadingAnchor.constraint(equalTo: centerXAnchor),
            
            settingsButton.widthAnchor.constraint(equalToConstant: 42),
            settingsButton.heightAnchor.constraint(equalToConstant: 42),
            settingsButton.topAnchor.constraint(equalTo: topAnchor,
                                            constant: 15),
            settingsButton.trailingAnchor.constraint(equalTo:
                                            trailingAnchor,
                                            constant: -10),
            
            pickerView.widthAnchor.constraint(equalToConstant:
                                            CGFloat.barWidth),
            pickerView.heightAnchor.constraint(equalToConstant: 50),
            pickerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            pickerView.centerYAnchor.constraint(equalTo: centerYAnchor,
                                            constant: CGFloat.trackerBarHeight / 4),
            
            toolsTitle.topAnchor.constraint(equalTo: 
                                            toolsStack.bottomAnchor,
                                            constant: 3),
            toolsTitle.centerXAnchor.constraint(equalTo:
                                            toolsStack.centerXAnchor),
            
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
