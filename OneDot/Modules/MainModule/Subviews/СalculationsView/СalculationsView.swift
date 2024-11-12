//
//  CalculationsViewCell.swift
//  OneDot
//
//  Created by Александр Коробицын on 11.01.2024.
//

import UIKit

class CalculationsView: UIVisualEffectView {
    
    typealias UD = UserDefaultsManager
    
    var completion: ((StateOfPicker) -> ())?
    
    enum StateOfPicker {
        case distance,
             speed,
             pace,
             time
    }
//    
//    private var currentStateOfPicker: StateOfPicker?
    
    private let topButton: UIButton = UIButton()
    private let bottomButton: UIButton = UIButton()
    private let leftButton: UIButton = UIButton()
    private let rightButton: UIButton = UIButton()
    
    private let distanceTitle: UILabel = UILabel()
    private let speedTitle: UILabel = UILabel()
    private let timeTitle: UILabel = UILabel()
    private let paceTitle: UILabel = UILabel()
    private let metricsTitle: UILabel = UILabel()
    

//    private let textfield: UITextField = {
//        let textView = UITextField()
//        textView.disableAutoresizingMask()
//        return textView
//    }()
    
//    private let pickerView: UIView = {
//        let view = UIView()
//        view.disableAutoresizingMask()
//        view.backgroundColor = .myPaletteBlue
//        view.layer.cornerRadius = CGFloat.barCorner
//        return view
//    }()
//    
//    private let picker: UIPickerView = {
//        let picker = UIPickerView()
//        picker.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 250)
//        return picker
//    }()
//    
//    private let pickerLabelSeparator: UILabel = {
//        let label = UILabel()
//        label.disableAutoresizingMask()
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 30, weight: .medium, width: .compressed)
//        label.textColor = .white
//        return label
//    }()

    private let doneButton: UIButton = {
        let button = UIButton()
        button.disableAutoresizingMask()
        button.setImage(UIImage(named: "toolBarCheckMarkIcon"), for: .normal)
        return button
    }()
    
    private let leftSeparator: CAShapeLayer = CAShapeLayer()
    private let rightSeparator: CAShapeLayer = CAShapeLayer()
    
    

    
    //MARK: - Init
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        
//        picker.delegate = self
//        picker.dataSource = self
        
        setViews()
        setConstraints()
        
        updateValues()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Calculations
    
    private func calculateDistance() {
        
        let lengthOfDistance = UD.shared.distance * 1000 + UD.shared.distanceDecimal * 100
        let paceOfSeconds = UD.shared.paceMin * 60 + UD.shared.paceSec
        
        let time = paceOfSeconds * lengthOfDistance / 1000
        
        UD.shared.timeH = time / 3600
        UD.shared.timeMin = time % 3600 / 60
        UD.shared.timeSec = time % 3600 % 60
    }
    
    private func calculateSpeed() {
        
        
        let lengthOfDistance = Double(UD.shared.distance * 1000 + UD.shared.distanceDecimal * 100)
        let distancePerSecond = Double(UD.shared.speed * 1000 + UD.shared.speedDecimal * 100) / 3600
        let timeOfSeconds = lengthOfDistance / distancePerSecond
        let secondsPerDistance = timeOfSeconds / lengthOfDistance * 1000

        if UD.shared.speed != 0 || UD.shared.speedDecimal != 0 {
            UD.shared.timeH = Int(timeOfSeconds) / 3600
            UD.shared.timeMin = Int(timeOfSeconds) % 3600 / 60
            UD.shared.timeSec = Int(timeOfSeconds) % 3600 % 60
            
            
            UD.shared.paceMin = Int(secondsPerDistance) / 60
            UD.shared.paceSec = Int(secondsPerDistance) % 60
        } else {
            UD.shared.timeH = 0
            UD.shared.timeMin = 0
            UD.shared.timeSec = 0
            
            UD.shared.paceMin = 0
            UD.shared.paceSec = 0
        }
    }
    
    private func calculatePace() {
        
        let lengthOfDistance = Double(UD.shared.distance * 1000 + UD.shared.distanceDecimal * 100)
        let secondsPerDistance = Double(UD.shared.paceMin * 60 + UD.shared.paceSec) / 1000
        
        let timeOfSeconds = secondsPerDistance * lengthOfDistance
        let distancePerHour = lengthOfDistance / timeOfSeconds * 60 * 60

        if UD.shared.paceMin != 0 || UD.shared.paceSec != 0 {
            UD.shared.timeH = Int(timeOfSeconds) / 3600
            UD.shared.timeMin = Int(timeOfSeconds) % 3600 / 60
            UD.shared.timeSec = Int(timeOfSeconds) % 3600 % 60
            
            UD.shared.speed = Int(distancePerHour / 1000)
            UD.shared.speedDecimal = Int(distancePerHour) % 1000 / 100
            
        } else {
            UD.shared.timeH = 0
            UD.shared.timeMin = 0
            UD.shared.timeSec = 0
            
            UD.shared.speed = 0
            UD.shared.speedDecimal = 0
        }
    }
    
    private func calculateTime() {
        let lengthOfDistance = Double(UD.shared.distance * 1000 + UD.shared.distanceDecimal * 100)
        let timeOfSeconds = Double(UD.shared.timeH * 3600 + UD.shared.timeMin * 60 + UD.shared.timeSec)

        let distancePerHour = lengthOfDistance / timeOfSeconds * 60 * 60
        let secondsPerDistance = timeOfSeconds / lengthOfDistance * 1000
        
        if UD.shared.timeH != 0 || UD.shared.timeMin != 0 || UD.shared.timeSec != 0 {
            UD.shared.speed = Int(distancePerHour / 1000)
            UD.shared.speedDecimal = Int(distancePerHour) % 1000 / 100
            
            UD.shared.paceMin = Int(secondsPerDistance) / 60
            UD.shared.paceSec = Int(secondsPerDistance) % 60
            
        } else {
            UD.shared.speed = 0
            UD.shared.speedDecimal = 0
            
            UD.shared.paceMin = 0
            UD.shared.paceSec = 0
        }
    }
    
    private func updateValues() {

        topButton.setTitle("\(UD.shared.speed):\(UD.shared.speedDecimal)", for: .normal)
        
        bottomButton.setTitle(
        "\(plusZero(UD.shared.paceMin)):\(plusZero(UD.shared.paceSec))",
        for: .normal)
        
        leftButton.setTitle("\(UD.shared.distance):\(UD.shared.distanceDecimal)", for: .normal)
        
        rightButton.setTitle(
        "\(plusZero(UD.shared.timeH)):\(plusZero(UD.shared.timeMin)):\(plusZero(UD.shared.timeSec))",
        for: .normal)
        
        func plusZero(_ int: Int) -> String {
            if int < 10 {
                return "0\(int)"
            } else {
                return "\(int)"
            }
        }
    }
    
    
    
    //MARK: - SetViews
    
    private func setViews() {
        
        layer.cornerRadius = 30
        layer.cornerCurve = .continuous
        layer.borderWidth = 0.3
        layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        
        setButton(button: topButton, titleColor: .myPaletteGold)
        setButton(button: bottomButton, titleColor: .myPaletteGold)
        setButton(button: leftButton, titleColor: .myPaletteBlue)
        setButton(button: rightButton, titleColor: .myPaletteBlue)

        setTitle(label: distanceTitle, titleText: "DISTANCE")
        setTitle(label: speedTitle, titleText: "KM / H")
        setTitle(label: timeTitle, titleText: "TIME")
        setTitle(label: paceTitle, titleText: "MIN / KM")
        setTitle(label: metricsTitle, titleText: "KM")
        
//        contentView.addSubview(textfield)
//        textfield.inputAccessoryView = pickerView
//        contentView.addSubview(pickerView)
//        pickerView.addSubview(picker)
//        picker.addSubview(pickerLabelSeparator)
//        
//        pickerView.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
    }
    
   //MARK: - SetButton
    
    private func setButton(button: UIButton, titleColor: UIColor) {
        contentView.addSubview(button)
        button.backgroundColor = .clear
        button.disableAutoresizingMask()
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30,
                                                    weight: .heavy,
                                                    width: .compressed)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    //MARK: - SetTitle
    
    private func setTitle(label: UILabel, titleText: String) {
        contentView.addSubview(label)
        label.disableAutoresizingMask()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium, width: .compressed)
        label.textColor = .myPaletteGray
        label.text = titleText
    }
    
    //MARK: - ButtonPressed
    
    @objc private func buttonPressed() {
        
        if topButton.isTouchInside {
            completion?(.distance)
//            currentStateOfPicker = .speed
//            pickerLabelSeparator.text = "."
//            picker.reloadAllComponents()
//            picker.selectRow(UD.shared.speed, inComponent: 0, animated: true)
//            picker.selectRow(UD.shared.speedDecimal, inComponent: 1, animated: true)
        } else if bottomButton.isTouchInside {
            completion?(.pace)
//            currentStateOfPicker = .pace
//            pickerLabelSeparator.text = ":"
//            picker.reloadAllComponents()
//            picker.selectRow(UD.shared.paceMin, inComponent: 0, animated: true)
//            picker.selectRow(UD.shared.paceSec, inComponent: 1, animated: true)
        } else if leftButton.isTouchInside {
            completion?(.speed)
//            currentStateOfPicker = .distance
//            pickerLabelSeparator.text = "."
//            picker.reloadAllComponents()
//            picker.selectRow(UD.shared.distance, inComponent: 0, animated: true)
//            picker.selectRow(UD.shared.distanceDecimal, inComponent: 1, animated: true)
        } else if rightButton.isTouchInside {
            completion?(.time)
//            currentStateOfPicker = .time
//            pickerLabelSeparator.text = ":          :"
//            picker.reloadAllComponents()
//            picker.selectRow(UD.shared.timeH, inComponent: 0, animated: true)
//            picker.selectRow(UD.shared.timeMin, inComponent: 1, animated: true)
//            picker.selectRow(UD.shared.timeSec, inComponent: 2, animated: true)
        }
        
//        textfield.becomeFirstResponder()
    }
    
    @objc private func donePressed() {
        endEditing(true)
    }
    
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
//            textfield.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            textfield.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            textfield.widthAnchor.constraint(equalToConstant: 0),
//            textfield.heightAnchor.constraint(equalToConstant: 0),
//            pickerView.widthAnchor.constraint(equalToConstant: .barWidth),
//            pickerView.heightAnchor.constraint(equalToConstant: 200),
//            pickerView.centerXAnchor.constraint(equalTo: centerXAnchor),
//            pickerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
            topButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            topButton.widthAnchor.constraint(equalToConstant: 100),
            topButton.heightAnchor.constraint(equalToConstant: 60),
            topButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 100),
            
            bottomButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            bottomButton.widthAnchor.constraint(equalToConstant: 100),
            bottomButton.heightAnchor.constraint(equalToConstant: 60),
            bottomButton.topAnchor.constraint(equalTo: topButton.bottomAnchor),
            
            leftButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 100),
            leftButton.trailingAnchor.constraint(equalTo: topButton.leadingAnchor),
            leftButton.heightAnchor.constraint(equalToConstant: 120),
            leftButton.widthAnchor.constraint(equalToConstant: (.barWidth - 100) / 2),
            
            rightButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 100),
            rightButton.leadingAnchor.constraint(equalTo: topButton.trailingAnchor),
            rightButton.heightAnchor.constraint(equalToConstant: 120),
            rightButton.widthAnchor.constraint(equalToConstant: (.barWidth - 100) / 2),
            
            doneButton.widthAnchor.constraint(equalToConstant: 50),
            doneButton.heightAnchor.constraint(equalToConstant: 50),
//            doneButton.topAnchor.constraint(equalTo: picker.topAnchor, constant: 15),
//            doneButton.trailingAnchor.constraint(equalTo: picker.trailingAnchor, constant: -15),
//            
//            pickerLabelSeparator.centerXAnchor.constraint(equalTo: picker.centerXAnchor),
//            pickerLabelSeparator.centerYAnchor.constraint(equalTo: picker.centerYAnchor, constant: -3),
            
            distanceTitle.centerXAnchor.constraint(equalTo: leftButton.centerXAnchor),
            distanceTitle.bottomAnchor.constraint(equalTo: leftButton.topAnchor, constant: -5),
            
            speedTitle.centerXAnchor.constraint(equalTo: topButton.centerXAnchor),
            speedTitle.bottomAnchor.constraint(equalTo: topButton.topAnchor, constant: -5),
            
            timeTitle.centerXAnchor.constraint(equalTo: rightButton.centerXAnchor),
            timeTitle.bottomAnchor.constraint(equalTo: rightButton.topAnchor, constant: -5),
            
            paceTitle.centerXAnchor.constraint(equalTo: bottomButton.centerXAnchor),
            paceTitle.topAnchor.constraint(equalTo: bottomButton.bottomAnchor, constant: 5),
            
            metricsTitle.centerXAnchor.constraint(equalTo: leftButton.centerXAnchor),
            metricsTitle.topAnchor.constraint(equalTo: leftButton.bottomAnchor, constant: 5)
        ])
    }
    
}

//MARK: - PickerViewDelegate&Datasource
//
//extension CalculationsView: UIPickerViewDelegate, UIPickerViewDataSource {
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        switch currentStateOfPicker {
//            
//        case .speed:
//            return 2
//        case .pace:
//            return 2
//        case .distance:
//            return 2
//        case .time:
//            return 3
//        case .none:
//            break
//        }
//        return Int()
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        
//        switch currentStateOfPicker {
//            
//        case .speed:
//            if component == 0 {
//                return 100
//            } else if component == 1 {
//                return 10
//            }
//            
//        case .pace:
//            if component == 0 {
//                return 100
//            } else if component == 1 {
//                return 60
//            }
//        case .distance:
//            if component == 0 {
//                return 100
//            } else if component == 1 {
//                return 10
//            }
//        case .time:
//            if component == 0 {
//                return 100
//            } else if component == 1 {
//                return 60
//            } else if component == 2 {
//                return 60
//            }
//        case .none:
//            break
//        }
//        return Int()
//        
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
//        return 50
//    }
//    
//    
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//        let label = UILabel()
//        label.textColor = .white
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 30, weight: .medium, width: .compressed)
//        
//        switch currentStateOfPicker {
//            
//        case .speed:
//            label.text = String(row)
//            
//        case .pace:
//            if row < 10 {
//                label.text = "0\(String(row))"
//            } else {
//                label.text = String(row)
//            }
//        case .distance:
//            label.text = String(row)
//        case .time:
//            if row < 10 {
//                label.text = "0\(String(row))"
//            } else {
//                label.text = String(row)
//            }
//        case .none:
//            break
//        }
//       
//        return label
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        switch currentStateOfPicker {
//            
//        case .speed:
//            
//            if component == 0 {
//                UD.shared.speed = row
//                calculateSpeed()
//                updateValues()
//            } else if component == 1 {
//                UD.shared.speedDecimal = row
//                calculateSpeed()
//                updateValues()
//            }
//        case .pace:
//            if component == 0 {
//                UD.shared.paceMin = row
//                calculatePace()
//                updateValues()
//            } else if component == 1 {
//                UD.shared.paceSec = row
//                calculatePace()
//                updateValues()
//            }
//        case .distance:
//            if component == 0 {
//                UD.shared.distance = row
//                calculateDistance()
//                updateValues()
//            } else if component == 1 {
//                UD.shared.distanceDecimal = row
//                calculateDistance()
//                updateValues()
//            }
//        case .time:
//            if component == 0 {
//                UD.shared.timeH = row
//                calculateTime()
//                updateValues()
//            } else if component == 1 {
//                UD.shared.timeMin = row
//                calculateTime()
//                updateValues()
//            } else if component == 2 {
//                UD.shared.timeSec = row
//                calculateTime()
//                updateValues()
//            }
//        case .none:
//            break
//        }
//    }
//    
//}
//
