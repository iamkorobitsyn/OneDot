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
    
    var buttonsStateHandler: (() -> Void)?
    
    enum Mode {
        case pickerDistance
        case pickerSpeed
        case pickerPace
        case PickerTime
        case hide
    }
    
    private let numbersLineSeparator: CAShapeLayer = CAShapeLayer()

    private let pickerView: UIPickerView = {
        let view = UIPickerView()
        view.disableAutoresizingMask()
        return view
    }()
    
    private var currentPickerState: Mode?
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        pickerView.delegate = self
        pickerView.dataSource = self
        setViews()
        setConstraints()
    }
    
    //MARK: - ActivateMode
    
    func activateMode(mode: Mode) {
        buttonsStateHandler?()
        switch mode {
        case .pickerDistance:
            isHidden = false
            GraphicsService.shared.drawShape(shape: numbersLineSeparator, shapeType: .pickerSingleShape, view: self)
            currentPickerState = .pickerDistance
            pickerView.reloadAllComponents()
            pickerView.selectRow(UD.shared.calculationsDistanceValue, inComponent: 0, animated: true)
            pickerView.selectRow(UD.shared.calculationsDistanceDecimalValue, inComponent: 1, animated: true)
           
        case .pickerSpeed:
            isHidden = false
            GraphicsService.shared.drawShape(shape: numbersLineSeparator, shapeType: .pickerSingleShape, view: self)
            currentPickerState = .pickerSpeed
            pickerView.reloadAllComponents()
            pickerView.selectRow(UD.shared.calculationsSpeedValue, inComponent: 0, animated: true)
            pickerView.selectRow(UD.shared.calculationsSpeedDecimalValue, inComponent: 1, animated: true)
        case .pickerPace:
            isHidden = false
            GraphicsService.shared.drawShape(shape: numbersLineSeparator, shapeType: .pickerSingleShape, view: self)
            currentPickerState = .pickerPace
            pickerView.reloadAllComponents()
            pickerView.selectRow(UD.shared.calculationsPaceMinValue, inComponent: 0, animated: true)
            pickerView.selectRow(UD.shared.calculationsPaceSecValue, inComponent: 1, animated: true)
        case .PickerTime:
            isHidden = false
            GraphicsService.shared.drawShape(shape: numbersLineSeparator, shapeType: .pickerDoubleShape, view: self)
            currentPickerState = .PickerTime
            pickerView.reloadAllComponents()
            pickerView.selectRow(UD.shared.calculationsTimeHValue, inComponent: 0, animated: true)
            pickerView.selectRow(UD.shared.calculationsTimeMinValue, inComponent: 1, animated: true)
            pickerView.selectRow(UD.shared.calculationsTimeSecValue, inComponent: 2, animated: true)
        case .hide:
            isHidden = true
            return
        }
    }
    
    //MARK: - SetViews
    
    private func setViews() {
        effect = UIBlurEffect(style: UIBlurEffect.Style.light)
        clipsToBounds = true
        layer.instance(border: true, corner: .min)
        contentView.addSubview(pickerView)
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
        return 80
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
 
        pickerView.subviews.forEach {
            $0.backgroundColor = .clear
        }
        
        let label = UILabel()
        label.instance(color: .myPaletteGray, alignment: .center, font: .condensedMax)
        
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
            activateMode(mode: .pickerDistance)
        case (.pickerDistance, 1):
            UD.shared.calculationsDistanceDecimalValue = row
            activateMode(mode: .pickerDistance)
            
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
            
        case (.PickerTime, 0):
            UD.shared.calculationsTimeHValue = row
            activateMode(mode: .PickerTime)
        case (.PickerTime, 1):
            UD.shared.calculationsTimeMinValue = row
            activateMode(mode: .PickerTime)
        case (.PickerTime, 2):
            UD.shared.calculationsTimeSecValue = row
            activateMode(mode: .PickerTime)
        default:
            break
        }
    }
}



