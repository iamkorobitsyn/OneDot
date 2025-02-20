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
    
    let factoryWorkouts = FactoryWorkouts()
    
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

    private let outdoorButton: UIButton = UIButton()
    private let indoorButton: UIButton = UIButton()
    
    private let notesButton: UIButton = UIButton()
    private let calculatorButton: UIButton = UIButton()
    private let settingsButton: UIButton = UIButton()
    
    private let picker: UIPickerView = UIPickerView()
    
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
        picker.dataSource = self
        picker.delegate = self
        
        setViews()
        setConstraints()
    }
    
    //MARK: - Picker Test
    
    private func updatePicker(isGeoTracking: Bool) {
        
        let row = isGeoTracking ? UserDefaultsManager.shared.pickerRowOutdoor : UserDefaultsManager.shared.pickerRowIndoor
        picker.selectRow(row, inComponent: 0, animated: true)
        picker.reloadAllComponents()
    }
    
    func updateCurrentWorkout() -> Workout {
        let isGeoTracking = UserDefaultsManager.shared.isGeoTracking
        let workoutList = factoryWorkouts.get(isGeoTracking: isGeoTracking)
        if isGeoTracking {
            let row = UserDefaultsManager.shared.pickerRowOutdoor
            let workout = workoutList[row]
            return workout
        } else {
            let row = UserDefaultsManager.shared.pickerRowIndoor
            let workout = workoutList[row]
            return workout
        }
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
        GraphicsService.shared.animateLocator(navigationStateImageView)
    }
    
    func activateMode(mode: Mode) {
        switch mode {
            
        case .outdoor:
            UserDefaultsManager.shared.isGeoTracking = true
            updateLocationButtons()
            updatePicker(isGeoTracking: true)
            
        case .indoor:
            UserDefaultsManager.shared.isGeoTracking = false
            updateLocationButtons()
            updatePicker(isGeoTracking: false)
            
        case .notes:
            updateToolsButtons(notesButton, withImageNamed: "HeaderNotesSelected")
            
        case .calculations:
            updateToolsButtons(calculatorButton, withImageNamed: "HeaderCalculationsSelected")
            
        case .settings:
            updateToolsButtons(settingsButton, withImageNamed: "HeaderSettingsSelected")
            
        case .toolsDefault:
            updateToolsButtons(nil, withImageNamed: nil)
        case .trackingIndication(let state):
            switch state {
            case .goodSignal:
                navigationStateImageView.image = UIImage(named: "navigationGreen")
            case .poorSignal:
                navigationStateImageView.image = UIImage(named: "navigationYellow")
            case .locationDisabled:
                navigationStateImageView.image = UIImage(named: "navigationGray")
            }
        }
    }
    
    //MARK: - UpdateButtons
    
    private func updateLocationButtons() {
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
    
    private func updateToolsButtons(_ active: UIButton?, withImageNamed: String?) {
        [notesButton, calculatorButton, settingsButton].forEach( {$0.isUserInteractionEnabled = true} )
        updateButtonImage(notesButton, withImageNamed: "HeaderNotes")
        updateButtonImage(calculatorButton, withImageNamed: "HeaderCalculations")
        updateButtonImage(settingsButton, withImageNamed: "HeaderSettings")
        if let button = active, let named = withImageNamed {
            updateButtonImage(button, withImageNamed: named)
            button.isUserInteractionEnabled = false
        }
    }
    
    private func updateButtonImage(_ button: UIButton, withImageNamed: String) {
        button.setImage(UIImage(named: withImageNamed), for: .normal)
        button.setImage(UIImage(named: withImageNamed), for: .highlighted)
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
        
        contentView.addSubview(picker)
        picker.transform = CGAffineTransform(rotationAngle: -90 * (.pi / 180))
        
        [outdoorButton, indoorButton, notesButton, calculatorButton, settingsButton].forEach {
            $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {

        navigationStateImageView.disableAutoresizingMask()
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
         
            picker.widthAnchor.constraint(equalToConstant: 50),
            picker.heightAnchor.constraint(equalToConstant: 150),
            picker.centerXAnchor.constraint(equalTo: locationStack.centerXAnchor),
            picker.centerYAnchor.constraint(equalTo: centerYAnchor, constant: CGFloat.headerBarHeight / 4),
            
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

extension DashboardHeaderView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let isGeoTracking = UserDefaultsManager.shared.isGeoTracking
        return factoryWorkouts.get(isGeoTracking: isGeoTracking).count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let isGeoTracking = UserDefaultsManager.shared.isGeoTracking
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
        let isGeoTracking = UserDefaultsManager.shared.isGeoTracking
        pickerView.subviews.forEach{$0.backgroundColor = .clear}
        
        let imageView = UIImageView()
        imageView.backgroundColor = .none
        imageView.contentMode = .scaleAspectFit
        imageView.transform = CGAffineTransform(rotationAngle: 90 * (.pi / 180))

        let workoutList = factoryWorkouts.get(isGeoTracking: isGeoTracking)
        imageView.image = UIImage(named: workoutList[row].pickerIconName)
        
        return imageView
    }
    
    
}
