//
//  TrackerButton.swift
//  OneDot
//
//  Created by Александр Коробицын on 10.07.2023.
//

import UIKit

class TabBar: UIView {
    
    private typealias UD = UserDefaultsManager
    
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

    private let pickerView: UIPickerView = UIPickerView()
    private var currentPickerState: Mode?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setViews()
        setConstraints()
        
        pickerView.delegate = self
        pickerView.dataSource = self
 
    }
    
    //MARK: - MainVCHandlers
    
    @objc private func leftTapped() {
        
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
            configureVisibility(picker: true, bar: false)
            setButtonImages(lButtonImg: "TBStart", rButtonImg: "TBProfile")
            leftButton.layer.removeAllAnimations()
            
        case .prepareToStart:
            configureVisibility(picker: true, bar: false)
            setButtonImages(lButtonImg: "TBStart", rButtonImg: "TBCancel")
            AnimationManager.shared.AnimateStartIcon(leftButton.layer)
            
        case .tracking:
            configureVisibility(picker: true, bar: false)
            setButtonImages(lButtonImg: "TBPause", rButtonImg: "TBStop")
            leftButton.layer.removeAllAnimations()
            
        case .hide:
            configureVisibility(picker: true, bar: true)
        case .pickerDistance:
            configureVisibility(picker: false, bar: false)
            ShapeManager.shared.drawTabBarNumbersLineSeparator(shape: numbersLineSeparator, view: self)
            currentPickerState = .pickerDistance
            pickerView.reloadAllComponents()
            pickerView.selectRow(UD.shared.calculationsDistanceValue, inComponent: 0, animated: true)
            pickerView.selectRow(UD.shared.calculationsDistanceDecimalValue, inComponent: 1, animated: true)
        case .pickerSpeed:
            ShapeManager.shared.drawTabBarNumbersLineSeparator(shape: numbersLineSeparator, view: self)
            configureVisibility(picker: false, bar: false)
            currentPickerState = .pickerSpeed
            pickerView.reloadAllComponents()
            pickerView.selectRow(UD.shared.calculationsSpeedValue, inComponent: 0, animated: true)
            pickerView.selectRow(UD.shared.calculationsSpeedDecimalValue, inComponent: 1, animated: true)
        case .pickerPace:
            ShapeManager.shared.drawTabBarNumbersLineSeparator(shape: numbersLineSeparator, view: self)
            configureVisibility(picker: false, bar: false)
            currentPickerState = .pickerPace
            pickerView.reloadAllComponents()
            pickerView.selectRow(UD.shared.calculationsPaceMinValue, inComponent: 0, animated: true)
            pickerView.selectRow(UD.shared.calculationsPaceSecValue, inComponent: 1, animated: true)
        case .PickerTime:
            ShapeManager.shared.drawTabBarNumbersTwoLineSeparator(shape: numbersLineSeparator, view: self)
            configureVisibility(picker: false, bar: false)
            currentPickerState = .PickerTime
            pickerView.reloadAllComponents()
            pickerView.selectRow(UD.shared.calculationsTimeHValue, inComponent: 0, animated: true)
            pickerView.selectRow(UD.shared.calculationsTimeMinValue, inComponent: 1, animated: true)
            pickerView.selectRow(UD.shared.calculationsTimeSecValue, inComponent: 2, animated: true)
        case .pickerHide:
            configureVisibility(picker: true, bar: false)
        }
    }
    
    private func setButtonImages(lButtonImg: String, rButtonImg: String) {
        leftButton.setImage(UIImage(named: lButtonImg), for: .normal)
        leftButton.setImage(UIImage(named: lButtonImg), for: .highlighted)
        rightButton.setImage(UIImage(named: rButtonImg), for: .normal)
        rightButton.setImage(UIImage(named: rButtonImg), for: .highlighted)
    }
    
   
    
    //MARK: - ConfigurePickerVisibility
    
    private func configureBarVisibility(hidden: Bool) {
        self.isHidden = hidden ? true : false
    }
    
    private func configureVisibility(picker: Bool, bar: Bool) {
        
        self.isHidden = bar ? true : false
        pickerView.isHidden = picker ? true : false
        
        backgroundColor = picker ? .myPaletteBlue : .none
        leftButton.isHidden = picker ? false : true
        rightButton.isHidden = picker ? false : true

        buttonsLineSeparator.isHidden = picker ? false : true
        topLineSeparator.isHidden = picker ? true : false
        
        if picker {numbersLineSeparator.removeFromSuperlayer()}
    }
 
    
    //MARK: - SetViews
    
    private func setViews() {
        
        activateMode(mode: .prepare)
        
        backgroundColor = .myPaletteBlue
        layer.cornerRadius = .barCorner
        layer.cornerCurve = .continuous
        
        addSubview(leftButton)
        addSubview(rightButton)
        
        addSubview(pickerView)

        leftButton.addTarget(self, action: #selector(leftTapped), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightTapped), for: .touchUpInside)
        
        ShapeManager.shared.drawTabBarButtonsLineSeparator(shape: buttonsLineSeparator, view: self)
        ShapeManager.shared.drawTabBarTopLineSeparator(shape: topLineSeparator, view: self)
    }
    
    
    //MARK: - SetConstrains

    private func setConstraints() {
        leftButton.disableAutoresizingMask()
        rightButton.disableAutoresizingMask()
        pickerView.disableAutoresizingMask()
        
        NSLayoutConstraint.activate([
            leftButton.widthAnchor.constraint(equalToConstant: .barWidth / 2),
            leftButton.heightAnchor.constraint(equalToConstant: .tabBarHeight),
            leftButton.leftAnchor.constraint(equalTo: leftAnchor),
            leftButton.topAnchor.constraint(equalTo: topAnchor),
            
            rightButton.widthAnchor.constraint(equalToConstant: .barWidth / 2),
            rightButton.heightAnchor.constraint(equalToConstant: .tabBarHeight),
            rightButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            rightButton.topAnchor.constraint(equalTo: topAnchor),
            
            pickerView.widthAnchor.constraint(equalToConstant: .barWidth),
            pickerView.heightAnchor.constraint(equalToConstant: .tabBarHeight),
            pickerView.topAnchor.constraint(equalTo: topAnchor),
            pickerView.leadingAnchor.constraint(equalTo: leadingAnchor)
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



