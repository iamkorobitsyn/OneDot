//
//  CalculatorBottomBar.swift
//  OneDot
//
//  Created by Александр Коробицын on 12.12.2024.
//

import Foundation
import UIKit

class CalculationFooterView: UIView {
    
    private typealias UD = UserDefaultsManager
    
    var buttonStateHandler: ((DashboardVC.Mode)->())?
    
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
    
    let pickerLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.instance(color: .myPaletteGray, alignment: .left, font: .condensedMin)
        return label
    }()
    private var currentPickerState: Mode?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        backgroundColor = .myPaletteBlue
        pickerView.delegate = self
        pickerView.dataSource = self
        setViews()
        setConstraints()
    }
    
    //MARK: - ActivateMode
    
    func activateMode(mode: Mode) {
        switch mode {
        case .pickerDistance:
            isHidden = false
            pickerLabel.text = "Distance"
            GraphicsService.shared.drawShape(shape: numbersLineSeparator, shapeType: .footerSingleShape, view: self)
            currentPickerState = .pickerDistance
            pickerView.reloadAllComponents()
            pickerView.selectRow(UD.shared.calculationsDistanceValue, inComponent: 0, animated: true)
            pickerView.selectRow(UD.shared.calculationsDistanceDecimalValue, inComponent: 1, animated: true)
        case .pickerSpeed:
            isHidden = false
            pickerLabel.text = "Speed"
            GraphicsService.shared.drawShape(shape: numbersLineSeparator, shapeType: .footerSingleShape, view: self)
            currentPickerState = .pickerSpeed
            pickerView.reloadAllComponents()
            pickerView.selectRow(UD.shared.calculationsSpeedValue, inComponent: 0, animated: true)
            pickerView.selectRow(UD.shared.calculationsSpeedDecimalValue, inComponent: 1, animated: true)
        case .pickerPace:
            isHidden = false
            pickerLabel.text = "Pace"
            GraphicsService.shared.drawShape(shape: numbersLineSeparator, shapeType: .footerSingleShape, view: self)
            currentPickerState = .pickerPace
            pickerView.reloadAllComponents()
            pickerView.selectRow(UD.shared.calculationsPaceMinValue, inComponent: 0, animated: true)
            pickerView.selectRow(UD.shared.calculationsPaceSecValue, inComponent: 1, animated: true)
        case .PickerTime:
            isHidden = false
            pickerLabel.text = "Time"
            GraphicsService.shared.drawShape(shape: numbersLineSeparator, shapeType: .footerDoubleShape, view: self)
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
        backgroundColor = .myPaletteBlue
        layer.instance(border: false, corner: .max)
        addSubview(pickerView)
        addSubview(pickerLabel)
    }
    
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            pickerView.topAnchor.constraint(equalTo: topAnchor),
            pickerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pickerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            pickerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            pickerLabel.widthAnchor.constraint(equalToConstant: 100),
            pickerLabel.heightAnchor.constraint(equalToConstant: 50),
            pickerLabel.leadingAnchor.constraint(equalTo: pickerView.leadingAnchor, constant: 50),
            pickerLabel.bottomAnchor.constraint(equalTo: pickerView.topAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



//MARK: - PickerViewDelegate&Datasource

extension CalculationFooterView: UIPickerViewDelegate, UIPickerViewDataSource {
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
        label.instance(color: .white, alignment: .center, font: .standartExtra)
        
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



