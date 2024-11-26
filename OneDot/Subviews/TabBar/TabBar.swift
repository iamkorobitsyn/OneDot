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
    
    var buttonStateHandler: ((MainVC.Mode)->())?
    
    enum Mode {
        case prepare
        case prepareToStart
        case tracking
        case hide
        case pickerDistance
        case pickerSpeed
        case pickerPace
        case PickerTime
        case pickerHide
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
    private var currentPickerState: Mode?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setViews()
        setConstraints()
        
        picker.delegate = self
        picker.dataSource = self
 
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
            buttonStateHandler?(.transitionToProfile)
        } else if prepareToStartState || trackingState {
            prepareToStartState = false
            trackingState = false
            prepareState = true
            buttonStateHandler?(.prepare)
        }
    }
    
    //MARK: - ActivateMode
    
    func activateMode(mode: Mode) {
        backgroundColor = .myPaletteBlue
        switch mode {
            
        case .prepare:
            leftButton.setImage(UIImage(named: "TBStart"), for: .normal)
            leftButton.setImage(UIImage(named: "TBStart"), for: .highlighted)
            rightButton.setImage(UIImage(named: "TBProfile"), for: .normal)
            rightButton.setImage(UIImage(named: "TBProfile"), for: .highlighted)
            leftButton.layer.removeAllAnimations()
            isHidden = false
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
        case .hide:
            self.isHidden = true
        case .pickerDistance:
            Shaper.shared.drawTabBarNumbersLineSeparator(shape: numbersLineSeparator, view: self)
            configurePickerVisibility(isHidden: false)
            currentPickerState = .pickerDistance
            picker.reloadAllComponents()
            picker.selectRow(UD.shared.calculationsDistanceValue, inComponent: 0, animated: true)
            picker.selectRow(UD.shared.calculationsDistanceDecimalValue, inComponent: 1, animated: true)
        case .pickerSpeed:
            Shaper.shared.drawTabBarNumbersLineSeparator(shape: numbersLineSeparator, view: self)
            configurePickerVisibility(isHidden: false)
            currentPickerState = .pickerSpeed
            picker.reloadAllComponents()
            picker.selectRow(UD.shared.calculationsSpeedValue, inComponent: 0, animated: true)
            picker.selectRow(UD.shared.calculationsSpeedDecimalValue, inComponent: 1, animated: true)
        case .pickerPace:
            Shaper.shared.drawTabBarNumbersLineSeparator(shape: numbersLineSeparator, view: self)
            configurePickerVisibility(isHidden: false)
            currentPickerState = .pickerPace
            picker.reloadAllComponents()
            picker.selectRow(UD.shared.calculationsPaceMinValue, inComponent: 0, animated: true)
            picker.selectRow(UD.shared.calculationsPaceSecValue, inComponent: 1, animated: true)
        case .PickerTime:
            Shaper.shared.drawTabBarNumbersTwoLineSeparator(shape: numbersLineSeparator, view: self)
            configurePickerVisibility(isHidden: false)
            currentPickerState = .PickerTime
            picker.reloadAllComponents()
            picker.selectRow(UD.shared.calculationsTimeHValue, inComponent: 0, animated: true)
            picker.selectRow(UD.shared.calculationsTimeMinValue, inComponent: 1, animated: true)
            picker.selectRow(UD.shared.calculationsTimeSecValue, inComponent: 2, animated: true)
        case .pickerHide:
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
        case .pickerSpeed, .pickerPace, .pickerDistance:
            return 2
        case .PickerTime:
            return 3
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch (currentPickerState, component) {
        case (.pickerSpeed, 0), (.pickerPace, 0), (.pickerDistance, 0), (.PickerTime, 0):
            return 100
        case (.pickerSpeed, 1), (.pickerDistance, 1):
            return 10
        case (.pickerPace, 1), (.PickerTime, 1), (.PickerTime, 2):
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
            
        case .pickerDistance:
            
            label.text = String(row)
        case .pickerSpeed:

            label.text = String(row)
        case .pickerPace:

            label.text = row < 10 ? "0\(String(row))" : String(row)
        case .PickerTime:

            label.text = row < 10 ? "0\(String(row))" : String(row)
        default:
            break
        }
       
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch (currentPickerState, component) {
            
        case (.pickerDistance, 0):
            UD.shared.calculationsDistanceValue = row
            buttonStateHandler?(.pickerDistance)
        case (.pickerDistance, 1):
            UD.shared.calculationsDistanceDecimalValue = row
            buttonStateHandler?(.pickerDistance)
            
        case (.pickerSpeed, 0):
            UD.shared.calculationsSpeedValue = row
            buttonStateHandler?(.pickerSpeed)
        case (.pickerSpeed, 1):
            UD.shared.calculationsSpeedDecimalValue = row
            buttonStateHandler?(.pickerSpeed)
            
        case (.pickerPace, 0):
            UD.shared.calculationsPaceMinValue = row
            buttonStateHandler?(.pickerPace)
        case (.pickerPace, 1):
            UD.shared.calculationsPaceSecValue = row
            buttonStateHandler?(.pickerPace)
            
        case (.PickerTime, 0):
            UD.shared.calculationsTimeHValue = row
            buttonStateHandler?(.pickerTime)
        case (.PickerTime, 1):
            UD.shared.calculationsTimeMinValue = row
            buttonStateHandler?(.pickerTime)
        case (.PickerTime, 2):
            UD.shared.calculationsTimeSecValue = row
            buttonStateHandler?(.pickerTime)
        default:
            break
        }
    }
}



