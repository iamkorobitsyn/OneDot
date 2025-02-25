//
//  CalculatorBottomBar.swift
//  OneDot
//
//  Created by Александр Коробицын on 12.12.2024.
//

import Foundation
import UIKit

class CalculationsPicker: UIVisualEffectView {
    
    private typealias UD = UserDefaultsManager
    
    enum Mode {
        case pickerDistance
        case PickerTime
        case pickerSpeed
        case pickerPace
    }
    
    var valueStateHandler: (() -> Void)?
    
    private let separator: CAShapeLayer = CAShapeLayer()

    private let pickerView: UIPickerView = UIPickerView()
    private var currentPickerState: Mode = .pickerDistance
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        pickerView.delegate = self
        pickerView.dataSource = self
        setViews()
        setConstraints()
    }
    
    override func layoutSubviews() {
        switch currentPickerState {
        case .pickerDistance, .pickerSpeed, .pickerPace:
            GraphicsService.shared.drawShape(shape: separator, shapeType: .pickerSingleSeparator, view: self)
        case .PickerTime:
            GraphicsService.shared.drawShape(shape: separator, shapeType: .pickerDoubleSeparator, view: self)
        }
    }
    
    //MARK: - ActivateMode
    
    func activateMode(mode: Mode) {
        currentPickerState = mode
        pickerView.reloadAllComponents()
        layoutSubviews()
        
        switch mode {
        case .pickerDistance:
            pickerView.selectRow(UD.shared.calculationsDistanceValue, inComponent: 0, animated: true)
            pickerView.selectRow(UD.shared.calculationsDistanceDecimalValue, inComponent: 1, animated: true)
            CalculationsService.shared.calculateDistance()
            
        case .PickerTime:
            pickerView.selectRow(UD.shared.calculationsTimeHValue, inComponent: 0, animated: true)
            pickerView.selectRow(UD.shared.calculationsTimeMinValue, inComponent: 1, animated: true)
            pickerView.selectRow(UD.shared.calculationsTimeSecValue, inComponent: 2, animated: true)
            CalculationsService.shared.calculateTime()
        
        case .pickerSpeed:
            pickerView.selectRow(UD.shared.calculationsSpeedValue, inComponent: 0, animated: true)
            pickerView.selectRow(UD.shared.calculationsSpeedDecimalValue, inComponent: 1, animated: true)
            CalculationsService.shared.calculateSpeed()
        case .pickerPace:
            pickerView.selectRow(UD.shared.calculationsPaceMinValue, inComponent: 0, animated: true)
            pickerView.selectRow(UD.shared.calculationsPaceSecValue, inComponent: 1, animated: true)
            CalculationsService.shared.calculatePace()
        }
        valueStateHandler?()
    }
    
    //MARK: - SetViews
    
    private func setViews() {
        effect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        clipsToBounds = true
        layer.instance(border: true, corner: .min)
        contentView.addSubview(pickerView)
        pickerView.disableAutoresizingMask()
    }
    
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            pickerView.topAnchor.constraint(equalTo: topAnchor),
            pickerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pickerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            pickerView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



//MARK: - PickerViewDelegate&Datasource

extension CalculationsPicker: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        switch currentPickerState {
        case .pickerSpeed, .pickerPace, .pickerDistance:
            return 2
        case .PickerTime:
            return 3
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
        return 80
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
 
        pickerView.subviews.forEach {
            $0.backgroundColor = .clear
        }
        
        let label = UILabel()
        label.instance(color: .myPaletteGray, alignment: .center, font: .condensedMax)
        
        switch currentPickerState {
        case .pickerDistance, .pickerSpeed:
            label.text = String(row)
        case .pickerPace, .PickerTime:
            label.text = row < 10 ? String(format: "%02d", row) : String(row)
        }
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch (currentPickerState, component) {
            
        case (.pickerDistance, 0):
            UD.shared.calculationsDistanceValue = row
            activateMode(mode: .pickerDistance)
        case (.pickerDistance, 1):
            UD.shared.calculationsDistanceDecimalValue = row
            activateMode(mode: .pickerDistance)
            
        case (.PickerTime, 0):
            UD.shared.calculationsTimeHValue = row
            activateMode(mode: .PickerTime)
        case (.PickerTime, 1):
            UD.shared.calculationsTimeMinValue = row
            activateMode(mode: .PickerTime)
        case (.PickerTime, 2):
            UD.shared.calculationsTimeSecValue = row
            activateMode(mode: .PickerTime)
            
        case (.pickerSpeed, 0):
            UD.shared.calculationsSpeedValue = row
            activateMode(mode: .pickerSpeed)
        case (.pickerSpeed, 1):
            UD.shared.calculationsSpeedDecimalValue = row
            activateMode(mode: .pickerSpeed)
            
        case (.pickerPace, 0):
            UD.shared.calculationsPaceMinValue = row
            activateMode(mode: .pickerPace)
        case (.pickerPace, 1):
            UD.shared.calculationsPaceSecValue = row
            activateMode(mode: .pickerPace)
        default:
            break
        }
    }
}



