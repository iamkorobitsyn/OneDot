//
//  ActivitySelectionView.swift
//  OneDot
//
//  Created by Александр Коробицын on 11.09.2023.
//

import UIKit
import AudioToolbox

class TrackerBarView: UIView {
    let colorSet = UIColor.currentColorSet

    let exercises = FactoryExercises()
    var currentExercise: Exercise?
    
    var completion: ((_ button: UIButton)->())?
    
    let picker: TrackerBarPicker = TrackerBarPicker()
    let gpsView: TrackerBarGPS = TrackerBarGPS()
    
    
    let feedbackGen = UISelectionFeedbackGenerator()
    

    let pickerSeparator: CAShapeLayer = CAShapeLayer()

    private let visualEffectView = UIVisualEffectView()
    
    var toolsStack: UIStackView = UIStackView()
    var locationStack: UIStackView = UIStackView()

    //MARK: - Labels

    let locationTitle: UILabel = UILabel()
    let toolsTitle: UILabel = UILabel()
    
    //MARK: - SelectorButtons
    
    
    let outdoorButton: TrackerBarButton = TrackerBarButton()
    let indoorButton: TrackerBarButton = TrackerBarButton()
    
    let calculatorButton: TrackerBarButton = TrackerBarButton()
    let soundButton: TrackerBarButton = TrackerBarButton()
    let themesButton: TrackerBarButton = TrackerBarButton()
    let settingsButton: TrackerBarButton = TrackerBarButton()
    
    
    //MARK: - Metrics
    
    let mainBarWidth: CGFloat = UIScreen.main.bounds.width / 1.05
    let mainBarHeight: CGFloat = 130
    let mainBarCorner: CGFloat = 30
    
    let selectorStackSide: CGFloat = 42
    let stackSpacing: CGFloat = 2

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        setButtonTargets()
        statesRefresh(locations: true, tools: true)
        setViews()
        setConstraints()
        didBecomeObserver()
        
        outdoorButton.setActiveState(.indoor)
        
        picker.completion = { [weak self] exercise in
            guard let self else { return }
            currentExercise = exercise
            print(exercise.titleName)
        }
    }
    
    //MARK: - UpdateColors
    
    func updateColors(_ set: ColorSetProtocol) {
        toolsStack.backgroundColor = set.mainSelectorColor
        locationStack.backgroundColor = set.additionalSelectorColor
    }
    
    
    //MARK: - Targets
    
    private func setButtonTargets() {
        
        outdoorButton.addTarget(self,
                                    action: #selector(buttonTapped),
                                    for: .touchUpInside)
        indoorButton.addTarget(self,
                                  action: #selector(buttonTapped),
                                  for: .touchUpInside)
        calculatorButton.addTarget(self,
                                   action: #selector(buttonTapped),
                                   for: .touchUpInside)
        soundButton.addTarget(self,
                              action: #selector(buttonTapped),
                              for: .touchUpInside)
        themesButton.addTarget(self,
                               action: #selector(buttonTapped),
                               for: .touchUpInside)
        settingsButton.addTarget(self,
                                 action: #selector(buttonTapped),
                                 for: .touchUpInside)
        
        
    }
    
    func statesRefresh(locations: Bool, tools: Bool) {
        if locations != false {
            outdoorButton.setInactiveState(.indoor)
            indoorButton.setInactiveState(.outdoor)
            locationTitle.text = ""
        }
        if tools != false {
            calculatorButton.setInactiveState(.calculator)
            soundButton.setInactiveState(.sound)
            themesButton.setInactiveState(.themes)
            settingsButton.setInactiveState(.settings)
            toolsTitle.text = ""
        }
    }
    
    
    //MARK: - ButtonTapped
    
    @objc private func buttonTapped() {
        
        if calculatorButton.isTouchInside {
            completion?(calculatorButton)
        } else if  soundButton.isTouchInside {
            completion?(soundButton)
        } else if  themesButton.isTouchInside {
            completion?(themesButton)
        } else if settingsButton.isTouchInside {
            completion?(settingsButton)
        }
        
         if outdoorButton.isTouchInside {
            gpsView.isHidden = false
            
            feedbackGen.selectionChanged()
            completion?(outdoorButton)
            
            picker.currentLocation = "street"
            picker.picker.reloadAllComponents()
            let currentRow = UserDefaultsManager.shared.onTheStreetLoad()
            picker.picker.selectRow(currentRow, inComponent: 0, animated: true)
            currentExercise = exercises.get(.street)[currentRow]
            picker.title.text = currentExercise?.titleName
            picker.titleView.image = UIImage(named: currentExercise?.titleIcon ?? "")
            
            locationTitle.text = "Outdoor"
            outdoorButton.setActiveState(.indoor)
            indoorButton.setInactiveState(.outdoor)
            UserDefaultsManager.shared.selectorSave("street")
         } else if indoorButton.isTouchInside {
             gpsView.isHidden = true
             feedbackGen.selectionChanged()
             completion?(indoorButton)
             
             picker.currentLocation = "room"
             picker.picker.reloadAllComponents()
             let currentRow = UserDefaultsManager.shared.inRoomLoad()
             picker.picker.selectRow(currentRow, inComponent: 0, animated: true)
             currentExercise = exercises.get(.room)[currentRow]
             picker.title.text = currentExercise?.titleName
             picker.titleView.image = UIImage(named: currentExercise?.titleIcon ?? "")
             
             locationTitle.text = "Indoor"
             indoorButton.setActiveState(.outdoor)
             outdoorButton.setInactiveState(.indoor)
             UserDefaultsManager.shared.selectorSave("room")
         }
        
    }
    
    
    //MARK: - SetViews
    private func setViews() {
        layer.cornerRadius = mainBarCorner
        layer.cornerCurve = .continuous
        layer.borderWidth = 0.3
        layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        
        addSubview(visualEffectView)
        
        visualEffectView.effect = UIBlurEffect(style: UIBlurEffect.Style.light)
        visualEffectView.frame = CGRect(x: 0, y: 0,
                                        width: mainBarWidth,
                                        height: mainBarHeight)
        visualEffectView.clipsToBounds = true
        visualEffectView.layer.cornerRadius = mainBarCorner
        visualEffectView.layer.cornerCurve = .continuous
        
        toolsStack = UIStackView(arrangedSubviews: [calculatorButton,
                                                    soundButton,
                                                    themesButton,
                                                   settingsButton])
        toolsStack.backgroundColor = .currentColorSet.mainSelectorColor
        toolsStack.axis = .horizontal
        toolsStack.distribution = .fillEqually
        toolsStack.spacing = stackSpacing
        toolsStack.layer.cornerRadius = selectorStackSide / 2
        addSubview(toolsStack)
        
        locationStack = UIStackView(arrangedSubviews: [outdoorButton,
                                                         indoorButton])
        locationStack.backgroundColor = .currentColorSet.additionalSelectorColor
        locationStack.axis = .horizontal
        locationStack.distribution = .fillEqually
        locationStack.spacing = stackSpacing
        locationStack.layer.cornerRadius = selectorStackSide / 2
        addSubview(locationStack)
        

        
        addSubview(picker)
        picker.backgroundColor = .none

        addSubview(gpsView)
        
        addSubview(toolsTitle)
        toolsTitle.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        toolsTitle.textColor = .gray
        
        addSubview(locationTitle)
        locationTitle.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        locationTitle.textColor = .gray
        
        Shaper.shared.drawCenterXSeparator(shape: pickerSeparator,
                                                      view: self,
                                           xMove: -mainBarWidth / 3.1,
                                                      xAdd: -mainBarWidth / 5,
                                                      y: 115,
                                                      lineWidth: 0.7,
                                                      color: .lightGray)
        
        
        
        
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
        Animator.shared.animateConnectionStick(gpsView.pillingCircle)
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        toolsStack.translatesAutoresizingMaskIntoConstraints = false
        locationStack.translatesAutoresizingMaskIntoConstraints = false
        
        toolsTitle.translatesAutoresizingMaskIntoConstraints = false
        locationTitle.translatesAutoresizingMaskIntoConstraints = false
        picker.translatesAutoresizingMaskIntoConstraints = false
        gpsView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            toolsStack.widthAnchor.constraint(equalToConstant:
                                        (selectorStackSide *
                                 CGFloat(toolsStack.subviews.count)) +
                                        (stackSpacing *
                                 CGFloat(toolsStack.subviews.count) -
                                         stackSpacing)),
            toolsStack.heightAnchor.constraint(equalToConstant:
                                         selectorStackSide),
            toolsStack.topAnchor.constraint(equalTo: 
                                         topAnchor,
                                         constant: 15),
            toolsStack.centerXAnchor.constraint(equalTo:
                                         centerXAnchor,
                                         constant: mainBarWidth / 4 - 5),
            
            locationStack.widthAnchor.constraint(equalToConstant: 
                                        (selectorStackSide *
                                 CGFloat(locationStack.subviews.count)) +
                                        (stackSpacing *
                                 CGFloat(locationStack.subviews.count) -
                                         stackSpacing)),
            locationStack.heightAnchor.constraint(equalToConstant:
                                         selectorStackSide),
            locationStack.topAnchor.constraint(equalTo:
                                         topAnchor,
                                         constant: 15),
            locationStack.centerXAnchor.constraint(equalTo:
                                         centerXAnchor,
                                                   constant: -mainBarWidth / 4 + 5),
            
            picker.widthAnchor.constraint(equalToConstant:
                                         mainBarWidth),
            picker.heightAnchor.constraint(equalToConstant: 50),
            picker.centerXAnchor.constraint(equalTo: centerXAnchor),
            picker.centerYAnchor.constraint(equalTo: centerYAnchor,
                                         constant: mainBarHeight / 4),
            
            toolsTitle.topAnchor.constraint(equalTo: 
                                         toolsStack.bottomAnchor,
                                         constant: 3),
            toolsTitle.centerXAnchor.constraint(equalTo:
                                         toolsStack.centerXAnchor),
            
            locationTitle.topAnchor.constraint(equalTo: 
                                         locationStack.bottomAnchor,
                                         constant: 3),
            locationTitle.centerXAnchor.constraint(equalTo:
                                         locationStack.centerXAnchor),
            
            gpsView.centerYAnchor.constraint(equalTo: locationStack.centerYAnchor, constant: -15),
            gpsView.trailingAnchor.constraint(equalTo: locationStack.leadingAnchor, constant: -15),
            gpsView.widthAnchor.constraint(equalToConstant: 30),
            gpsView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
