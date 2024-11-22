//
//  TrackerButton.swift
//  OneDot
//
//  Created by Александр Коробицын on 10.07.2023.
//

import UIKit

class TabBar: UIView {
    
    private typealias UD = UserDefaultsManager
    private let feedbackGen = UISelectionFeedbackGenerator()
    
    var buttonStateHandler: ((MainVC.MainVCMode)->())?
    
    enum TabBarMode {
        case prepare
        case prepareToStart
        case tracking
        case distance
        case speed
        case pace
        case time
        case hide
    }
    
    private var prepareState: Bool = true
    private var prepareToStartState: Bool = false
    private var trackingState: Bool = false
    
    private let leftButton: UIButton = UIButton()
    private let rightButton: UIButton = UIButton()
    private let buttonsLineSeparator: CAShapeLayer = CAShapeLayer()
    private let topLineSeparator: CAShapeLayer = CAShapeLayer()
    private let numbersLineSeparator: CAShapeLayer = CAShapeLayer()

    private let picker: UIPickerView = UIPickerView()

    private var currentPickerState: TabBarMode?

    var previousProfileHandler: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setViews()
        setConstraints()
        
        picker.delegate = self
        picker.dataSource = self
        
        currentPickerState = .prepare
        
    }
    
    //MARK: - MainVCHandlers
    
    @objc private func leftTapped() {
        feedbackGen.selectionChanged()
        
        if prepareState {
            prepareState.toggle()
            prepareToStartState.toggle()
            buttonStateHandler?(.prepareToStart)
        } else if prepareToStartState {
            prepareToStartState.toggle()
            trackingState.toggle()
            buttonStateHandler?(.tracking)
        } else if trackingState {
            trackingState.toggle()
            prepareToStartState.toggle()
            buttonStateHandler?(.prepareToStart)
        }
    }
    
    @objc private func rightTapped() {
        feedbackGen.selectionChanged()
        
        if prepareState {
            previousProfileHandler?()
        } else if prepareToStartState || trackingState {
            prepareToStartState = false
            trackingState = false
            prepareState = true
            buttonStateHandler?(.prepare)
        }
    }
    
    //MARK: - ActivateMode
    
    func activateMode(mode: TabBarMode) {
        backgroundColor = .myPaletteBlue
        switch mode {
            
        case .prepare:
            leftButton.setImage(UIImage(named: "TBStart"), for: .normal)
            leftButton.setImage(UIImage(named: "TBStart"), for: .highlighted)
            rightButton.setImage(UIImage(named: "TBProfile"), for: .normal)
            rightButton.setImage(UIImage(named: "TBProfile"), for: .highlighted)
            leftButton.layer.removeAllAnimations()
        case .prepareToStart:
            leftButton.setImage(UIImage(named: "TBStart"), for: .normal)
            leftButton.setImage(UIImage(named: "TBStart"), for: .highlighted)
            rightButton.setImage(UIImage(named: "TBCancel"), for: .normal)
            rightButton.setImage(UIImage(named: "TBCancel"), for: .highlighted)
            Animator.shared.AnimateStartIcon(leftButton.layer)
        case .tracking:
            leftButton.setImage(UIImage(named: "TBPause"), for: .normal)
            leftButton.setImage(UIImage(named: "TBPause"), for: .highlighted)
            rightButton.setImage(UIImage(named: "TBStop"), for: .normal)
            rightButton.setImage(UIImage(named: "TBStop"), for: .highlighted)
            leftButton.layer.removeAllAnimations()
        case .distance:
            Shaper.shared.drawTabBarNumbersLineSeparator(shape: numbersLineSeparator, view: self)
            configurePickerVisibility(isHidden: false)
            currentPickerState = .distance
            picker.reloadAllComponents()
            picker.selectRow(UD.shared.distance, inComponent: 0, animated: true)
            picker.selectRow(UD.shared.distanceDecimal, inComponent: 1, animated: true)
        case .speed:
            Shaper.shared.drawTabBarNumbersLineSeparator(shape: numbersLineSeparator, view: self)
            configurePickerVisibility(isHidden: false)
            currentPickerState = .speed
            picker.reloadAllComponents()
            picker.selectRow(UD.shared.speed, inComponent: 0, animated: true)
            picker.selectRow(UD.shared.speedDecimal, inComponent: 1, animated: true)
        case .pace:
            Shaper.shared.drawTabBarNumbersLineSeparator(shape: numbersLineSeparator, view: self)
            configurePickerVisibility(isHidden: false)
            currentPickerState = .pace
            picker.reloadAllComponents()
            picker.selectRow(UD.shared.paceMin, inComponent: 0, animated: true)
            picker.selectRow(UD.shared.paceSec, inComponent: 1, animated: true)
        case .time:
            Shaper.shared.drawTabBarNumbersTwoLineSeparator(shape: numbersLineSeparator, view: self)
            configurePickerVisibility(isHidden: false)
            currentPickerState = .time
            picker.reloadAllComponents()
            picker.selectRow(UD.shared.timeH, inComponent: 0, animated: true)
            picker.selectRow(UD.shared.timeMin, inComponent: 1, animated: true)
            picker.selectRow(UD.shared.timeSec, inComponent: 2, animated: true)
        case .hide:
            configurePickerVisibility(isHidden: true)
            numbersLineSeparator.removeFromSuperlayer()
        }
    }
    
   
    
    //MARK: - ConfigurePickerVisibility
    
    func configurePickerVisibility(isHidden: Bool) {
        feedbackGen.selectionChanged()
        
        backgroundColor = isHidden ? .myPaletteBlue : .none
        picker.isHidden = isHidden ? true : false
        leftButton.isHidden = isHidden ? false : true
        rightButton.isHidden = isHidden ? false : true
        
        buttonsLineSeparator.isHidden = isHidden ? false : true
        topLineSeparator.isHidden = isHidden ? true : false
        
    }
 
    
    //MARK: - SetViews
    
    private func setViews() {
        
        activateMode(mode: .prepare)
        
        backgroundColor = .myPaletteBlue
        layer.cornerRadius = .barCorner
        layer.cornerCurve = .continuous
        
        addSubview(leftButton)
        addSubview(rightButton)
        
        addSubview(picker)

        leftButton.addTarget(self, action: #selector(leftTapped), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightTapped), for: .touchUpInside)
        
        Shaper.shared.drawTabBarButtonsLineSeparator(shape: buttonsLineSeparator, view: self)
        Shaper.shared.drawTabBarTopLineSeparator(shape: topLineSeparator, view: self)
    }
    
    
    //MARK: - SetConstrains

    private func setConstraints() {
        leftButton.disableAutoresizingMask()
        rightButton.disableAutoresizingMask()
        picker.disableAutoresizingMask()
        
        NSLayoutConstraint.activate([
            leftButton.widthAnchor.constraint(equalToConstant: .barWidth / 2),
            leftButton.heightAnchor.constraint(equalToConstant: .tabBarHeight),
            leftButton.leftAnchor.constraint(equalTo: leftAnchor),
            leftButton.topAnchor.constraint(equalTo: topAnchor),
            
            rightButton.widthAnchor.constraint(equalToConstant: .barWidth / 2),
            rightButton.heightAnchor.constraint(equalToConstant: .tabBarHeight),
            rightButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            rightButton.topAnchor.constraint(equalTo: topAnchor),
            
            picker.widthAnchor.constraint(equalToConstant: .barWidth),
            picker.heightAnchor.constraint(equalToConstant: .tabBarHeight),
            picker.topAnchor.constraint(equalTo: topAnchor),
            picker.leadingAnchor.constraint(equalTo: leadingAnchor)
            ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


//MARK: - PickerViewDelegate&Datasource

extension TabBar: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        switch currentPickerState {
        case .speed, .pace, .distance:
            return 2
        case .time:
            return 3
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch (currentPickerState, component) {
        case (.speed, 0), (.pace, 0), (.distance, 0), (.time, 0):
            return 100
        case (.speed, 1), (.distance, 1):
            return 10
        case (.pace, 1), (.time, 1), (.time, 2):
            return 60
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return .barWidth / 6.5
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
 
        pickerView.subviews.forEach {
            $0.backgroundColor = .clear
        }
        
        let label = UILabel()
        label.textColor = .myPaletteGray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25, weight: .light)
        
        switch currentPickerState {
            
        case .distance:
            
            label.text = String(row)
        case .speed:

            label.text = String(row)
        case .pace:

            label.text = row < 10 ? "0\(String(row))" : String(row)
        case .time:

            label.text = row < 10 ? "0\(String(row))" : String(row)
        default:
            break
        }
       
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch (currentPickerState, component) {
            
        case (.distance, 0):
            UD.shared.distance = row
            buttonStateHandler?(.distancePicker)
        case (.distance, 1):
            UD.shared.distanceDecimal = row
            buttonStateHandler?(.distancePicker)
            
        case (.speed, 0):
            UD.shared.speed = row
            buttonStateHandler?(.speedPicker)
        case (.speed, 1):
            UD.shared.speedDecimal = row
            buttonStateHandler?(.speedPicker)
            
        case (.pace, 0):
            UD.shared.paceMin = row
            buttonStateHandler?(.pacePicker)
        case (.pace, 1):
            UD.shared.paceSec = row
            buttonStateHandler?(.pacePicker)
            
        case (.time, 0):
            UD.shared.timeH = row
            buttonStateHandler?(.timePicker)
        case (.time, 1):
            UD.shared.timeMin = row
            buttonStateHandler?(.timePicker)
        case (.time, 2):
            UD.shared.timeSec = row
            buttonStateHandler?(.timePicker)
        default:
            break
        }
    }
}



