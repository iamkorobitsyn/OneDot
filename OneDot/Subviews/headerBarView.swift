//
//  ActivitySelectionView.swift
//  OneDot
//
//  Created by Александр Коробицын on 11.09.2023.
//

import UIKit
import AudioToolbox

class headerBarView: UIVisualEffectView {
    
    var buttonStateHandler: ((DashboardVC.Mode)->())?
    
    private let hapticGenerator = UISelectionFeedbackGenerator()
    private let factoryWorkouts = FactoryWorkouts()
    private var isGeoTracking = UserDefaultsManager.shared.isGeoTracking
    
    private let locationStack: UIStackView = UIStackView()
    private let toolsStack: UIStackView = UIStackView()

    private let outdoorButton: UIButton = UIButton()
    private let indoorButton: UIButton = UIButton()
    private let notesButton: UIButton = UIButton()
    private let calculatorButton: UIButton = UIButton()
    private let settingsButton: UIButton = UIButton()
    
    private let toolsTitle: UILabel = UILabel()
    
    private let picker: UIPickerView = UIPickerView()
    
    private let gpsStateImageView: UIImageView = UIImageView()
    
    enum Mode {
        case outdoor
        case indoor
        case notes
        case calculations
        case settings
        case toolsDefault
        case trackingIndication(LocationService.LocationTrackingState)
    }
    
    //MARK: - Init
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        picker.dataSource = self
        picker.delegate = self
        
        setViews()
        setConstraints()
    }
    
    //MARK: - public: ActivateMode
    
    func activateMode(mode: Mode) {
        switch mode {
            
        case .outdoor:
            updateGeoTracking(state: true)
            updateLocationStackButtons()
            updatePicker()
            
        case .indoor:
            updateGeoTracking(state: false)
            updateLocationStackButtons()
            updatePicker()
            
        case .notes:
            updateToolsStackButtons(notesButton, withImageNamed: "HeaderNotesSelected")
            
        case .calculations:
            updateToolsStackButtons(calculatorButton, withImageNamed: "HeaderCalculationsSelected")
            
        case .settings:
            updateToolsStackButtons(settingsButton, withImageNamed: "HeaderSettingsSelected")
            
        case .toolsDefault:
            updateToolsStackButtons(nil, withImageNamed: nil)
        case .trackingIndication(let state):
            switch state {
            case .goodSignal:
                gpsStateImageView.image = UIImage(named: "navigationGreen")
            case .poorSignal:
                gpsStateImageView.image = UIImage(named: "navigationYellow")
            case .locationDisabled:
                gpsStateImageView.image = UIImage(named: "navigationGray")
            }
        }
    }
    
    //MARK: - UbdateGeoTracking
    
    private func updateGeoTracking(state: Bool) {
        UserDefaultsManager.shared.isGeoTracking = state
        isGeoTracking = state
    }
    
    //MARK: - public: GPSStateImageView
    
    @objc func animateNavigationView() {
        GraphicsService.shared.animateLocator(gpsStateImageView)
    }
    
    //MARK: - Buttons

    @objc private func buttonTapped() {
        hapticGenerator.selectionChanged()
        switch true {
        case outdoorButton.isTouchInside:
            buttonStateHandler?(.geoTrackingActive)
        case indoorButton.isTouchInside:
            buttonStateHandler?(.geoTrackingInactive)
        case notesButton.isTouchInside:
            buttonStateHandler?(.notes)
            toolsTitle.text = "Notes"
        case calculatorButton.isTouchInside:
            buttonStateHandler?(.calculations)
            toolsTitle.text = "Calculations"
        case settingsButton.isTouchInside:
            buttonStateHandler?(.settings)
            toolsTitle.text = "Settings"
        default:
            break
        }
    }


    private func updateLocationStackButtons() {
        let isGeoTracking = UserDefaultsManager.shared.isGeoTracking
        outdoorButton.isUserInteractionEnabled = !isGeoTracking ? true : false
        indoorButton.isUserInteractionEnabled = isGeoTracking ? true : false
        if isGeoTracking {
            updateButtonImage(outdoorButton, withImageNamed: "HeaderOutdoorSelected")
            updateButtonImage(indoorButton, withImageNamed: "HeaderIndoor")
        } else {
            updateButtonImage(indoorButton, withImageNamed: "HeaderIndoorSelected")
            updateButtonImage(outdoorButton, withImageNamed: "HeaderOutdoor")
        }
    }
    
    private func updateToolsStackButtons(_ active: UIButton?, withImageNamed: String?) {
        [notesButton, calculatorButton, settingsButton].forEach( {$0.isUserInteractionEnabled = true} )
        updateButtonImage(notesButton, withImageNamed: "HeaderNotes")
        updateButtonImage(calculatorButton, withImageNamed: "HeaderCalculations")
        updateButtonImage(settingsButton, withImageNamed: "HeaderSettings")
        toolsTitle.text = ""
        if let button = active, let named = withImageNamed {
            updateButtonImage(button, withImageNamed: named)
            button.isUserInteractionEnabled = false
        }
    }
    
    private func updateButtonImage(_ button: UIButton, withImageNamed: String) {
        button.setImage(UIImage(named: withImageNamed), for: .normal)
        button.setImage(UIImage(named: withImageNamed), for: .highlighted)
    }
    
    //MARK: - Picker
    
    private func updatePicker() {
        
        let row = isGeoTracking ? UserDefaultsManager.shared.pickerRowOutdoor : UserDefaultsManager.shared.pickerRowIndoor
        picker.reloadAllComponents()
        picker.selectRow(row, inComponent: 0, animated: true)
    }
    
    func getCurrentWorkout() -> Workout {
        let workoutList = factoryWorkouts.get(isGeoTracking: isGeoTracking)
        let workout = isGeoTracking ?
        workoutList[UserDefaultsManager.shared.pickerRowOutdoor] : workoutList[UserDefaultsManager.shared.pickerRowIndoor]
        return workout
    }
    
    //MARK: - SetViews
    private func setViews() {
        effect = UIBlurEffect(style: .extraLight)
        layer.instance(border: true, corner: .max)
        clipsToBounds = true
        
        [locationStack, toolsStack].forEach { stack in
            stack.disableAutoresizingMask()
            stack.backgroundColor = .myPaletteGold
            stack.axis = .horizontal
            stack.distribution = .fillEqually
            stack.spacing = 0
            stack.layer.cornerRadius = 14
            stack.layer.cornerCurve = .continuous
            contentView.addSubview(stack)
        }

        locationStack.addArrangedSubview(outdoorButton)
        locationStack.addArrangedSubview(indoorButton)
        toolsStack.addArrangedSubview(notesButton)
        toolsStack.addArrangedSubview(calculatorButton)
        toolsStack.addArrangedSubview(settingsButton)
        
        contentView.addSubview(toolsTitle)
        toolsTitle.instance(color: .myPaletteGray, alignment: .center, font: .condensedMin)
        toolsTitle.disableAutoresizingMask()
        
        contentView.addSubview(gpsStateImageView)
        
        contentView.addSubview(picker)
        picker.transform = CGAffineTransform(rotationAngle: -90 * (.pi / 180))
        
        [outdoorButton, indoorButton, notesButton, calculatorButton, settingsButton].forEach {
            $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {

        gpsStateImageView.disableAutoresizingMask()
        picker.disableAutoresizingMask()
        
        NSLayoutConstraint.activate([
            locationStack.widthAnchor.constraint(equalToConstant: 42 * CGFloat(locationStack.subviews.count)),
            locationStack.heightAnchor.constraint(equalToConstant: 42),
            locationStack.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            locationStack.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -CGFloat.barWidth / 4),
            
            toolsStack.widthAnchor.constraint(equalToConstant: 42 * CGFloat(toolsStack.subviews.count)),
            toolsStack.heightAnchor.constraint(equalToConstant: 42),
            toolsStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            toolsStack.centerXAnchor.constraint(equalTo: centerXAnchor, constant: CGFloat.barWidth / 4),
            
            toolsTitle.widthAnchor.constraint(equalToConstant: 100),
            toolsTitle.heightAnchor.constraint(equalToConstant: 40),
            toolsTitle.topAnchor.constraint(equalTo: toolsStack.bottomAnchor),
            toolsTitle.centerXAnchor.constraint(equalTo: toolsStack.centerXAnchor),
         
            picker.widthAnchor.constraint(equalToConstant: 50),
            picker.heightAnchor.constraint(equalToConstant: 150),
            picker.centerXAnchor.constraint(equalTo: locationStack.centerXAnchor),
            picker.centerYAnchor.constraint(equalTo: centerYAnchor, constant: CGFloat.headerBarHeight / 4),
            
            gpsStateImageView.centerYAnchor.constraint(equalTo: locationStack.centerYAnchor),
            gpsStateImageView.trailingAnchor.constraint(equalTo: locationStack.leadingAnchor),
            gpsStateImageView.widthAnchor.constraint(equalToConstant: 42),
            gpsStateImageView.heightAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - PickerDataSource&Delegate

extension headerBarView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return factoryWorkouts.get(isGeoTracking: isGeoTracking).count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if isGeoTracking {
            UserDefaultsManager.shared.pickerRowOutdoor = row
        } else {
            UserDefaultsManager.shared.pickerRowIndoor = row
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        40
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        45
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        pickerView.subviews.forEach{$0.backgroundColor = .clear}
        
        let workoutList = factoryWorkouts.get(isGeoTracking: isGeoTracking)
        let imageView = UIImageView()
        
        imageView.backgroundColor = .none
        imageView.contentMode = .scaleAspectFit
        imageView.transform = CGAffineTransform(rotationAngle: 90 * (.pi / 180))
        imageView.image = UIImage(named: workoutList[row].pickerIconName)
        return imageView
    }
}
