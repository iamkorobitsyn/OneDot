//
//  CalculationsViewCell.swift
//  OneDot
//
//  Created by Александр Коробицын on 11.01.2024.
//

import UIKit

class CalculationsViewCell: UITableViewCell {
    
    typealias UD = UserDefaultsManager
    
    private enum StateOfPicker {
        case distance,
             speed,
             pace,
             time
    }
    
    private var currentStateOfPicker: StateOfPicker?
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    private let visualView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 250)
        view.effect = UIBlurEffect(style: UIBlurEffect.Style.light)
        view.clipsToBounds = true
        view.layer.cornerRadius = CGFloat.trackerBarCorner
        view.layer.cornerCurve = .continuous
        view.layer.borderWidth = 0.3
        view.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        return view
    }()
    
    private let textfield: UITextField = {
        let textView = UITextField()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let picker: UIPickerView = {
        let picker = UIPickerView()
        picker.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 250)
        return picker
    }()
    
    
    
    private let topButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.textColor = .white
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30,
                                                    weight: .heavy,
                                                    width: .compressed)
        return button
    }()
    
    private let bottomButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.textColor = .white
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30,
                                                    weight: .heavy,
                                                    width: .compressed)
        return button
    }()
    
    private let leftButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.textColor = .white
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30,
                                                    weight: .heavy,
                                                    width: .compressed)
        return button
    }()
    
    private let rightButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.textColor = .white
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30,
                                                    weight: .heavy,
                                                    width: .compressed)
        return button
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "toolBarCheckMarkIcon"), for: .normal)
        return button
    }()
    
    private let leftSeparator: CAShapeLayer = CAShapeLayer()
    private let rightSeparator: CAShapeLayer = CAShapeLayer()
    
    private let pickerTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium, width: .compressed)
        label.textColor = .gray
        return label
    }()
    
    private let distanceTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium, width: .compressed)
        label.textColor = .gray
        label.text = "DISTANCE"
        return label
    }()
    
    private let speedTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium, width: .compressed)
        label.textColor = .gray
        label.text = "KM / H"
        return label
    }()
    
    private let timeTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium, width: .compressed)
        label.textColor = .gray
        label.text = "TIME"
        return label
    }()
    
    private let paceTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium, width: .compressed)
        label.textColor = .gray
        label.text = "MIN / KM"
        return label
    }()
    
    private let metricsTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium, width: .compressed)
        label.textColor = .gray
        label.text = "KM"
        return label
    }()
   
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
        
        picker.delegate = self
        picker.dataSource = self
        
        setViews()
        setConstraints()
        
        Shaper.shared.drawYSeparator(shape: leftSeparator,
                                     view: containerView,
                                     x: (CGFloat.toolBarWidth - 100) / 2,
                                     y: 20,
                                     length: 80,
                                     color: .white)
        
        Shaper.shared.drawYSeparator(shape: rightSeparator,
                                     view: containerView,
                                     x: (CGFloat.toolBarWidth - 100) / 2 + 100,
                                     y: 20,
                                     length: 80,
                                     color: .white)
        
        updateValues()
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
        
        contentView.addSubview(containerView)
        
        containerView.addSubview(textfield)
        textfield.inputView = UIView()
        textfield.inputAccessoryView = visualView
        visualView.contentView.addSubview(picker)
        picker.addSubview(pickerTitle)

        setButton(button: topButton)
        setButton(button: bottomButton)
        setButton(button: leftButton)
        setButton(button: rightButton)
        visualView.contentView.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(donePressed), for: .touchUpInside)

        containerView.addSubview(distanceTitle)
        containerView.addSubview(speedTitle)
        containerView.addSubview(timeTitle)
        containerView.addSubview(paceTitle)
        containerView.addSubview(metricsTitle)
    }
    
   
    
    private func setButton(button: UIButton) {
        contentView.addSubview(button)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    @objc private func buttonPressed() {
        
        if topButton.isTouchInside {
            currentStateOfPicker = .speed
            pickerTitle.text = "."
            picker.reloadAllComponents()
            picker.selectRow(UD.shared.speed, inComponent: 0, animated: true)
            picker.selectRow(UD.shared.speedDecimal, inComponent: 1, animated: true)
        } else if bottomButton.isTouchInside {
            currentStateOfPicker = .pace
            pickerTitle.text = ":"
            picker.reloadAllComponents()
            picker.selectRow(UD.shared.paceMin, inComponent: 0, animated: true)
            picker.selectRow(UD.shared.paceSec, inComponent: 1, animated: true)
        } else if leftButton.isTouchInside {
            currentStateOfPicker = .distance
            pickerTitle.text = "."
            picker.reloadAllComponents()
            picker.selectRow(UD.shared.distance, inComponent: 0, animated: true)
            picker.selectRow(UD.shared.distanceDecimal, inComponent: 1, animated: true)
        } else if rightButton.isTouchInside {
            currentStateOfPicker = .time
            pickerTitle.text = ":          :"
            picker.reloadAllComponents()
            picker.selectRow(UD.shared.timeH, inComponent: 0, animated: true)
            picker.selectRow(UD.shared.timeMin, inComponent: 1, animated: true)
            picker.selectRow(UD.shared.timeSec, inComponent: 2, animated: true)
        }
        
        textfield.becomeFirstResponder()
    }
    
    @objc private func donePressed() {
        endEditing(true)
    }
    
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalToConstant: 
                                            CGFloat.toolBarWidth),
            containerView.heightAnchor.constraint(equalToConstant: 120),
            containerView.centerXAnchor.constraint(equalTo: 
                                            contentView.centerXAnchor),
            containerView.topAnchor.constraint(equalTo: 
                                            contentView.topAnchor,
                                            constant: 50),
            
            textfield.centerXAnchor.constraint(equalTo: 
                                            containerView.centerXAnchor),
            textfield.centerYAnchor.constraint(equalTo:
                                            containerView.centerYAnchor),
            textfield.widthAnchor.constraint(equalToConstant: 0),
            textfield.heightAnchor.constraint(equalToConstant: 0),
            
            topButton.centerXAnchor.constraint(equalTo:
                                            containerView.centerXAnchor),
            topButton.widthAnchor.constraint(equalToConstant: 100),
            topButton.heightAnchor.constraint(equalToConstant: 60),
            topButton.topAnchor.constraint(equalTo:
                                            containerView.topAnchor),
            
            bottomButton.centerXAnchor.constraint(equalTo: 
                                            containerView.centerXAnchor),
            bottomButton.widthAnchor.constraint(equalToConstant: 100),
            bottomButton.heightAnchor.constraint(equalToConstant: 60),
            bottomButton.bottomAnchor.constraint(equalTo:
                                            containerView.bottomAnchor),
            
            leftButton.topAnchor.constraint(equalTo:
                                            containerView.topAnchor),
            leftButton.trailingAnchor.constraint(equalTo:
                                                    topButton.leadingAnchor),
            leftButton.heightAnchor.constraint(equalToConstant: 120),
            leftButton.widthAnchor.constraint(equalToConstant:
                                            (CGFloat.toolBarWidth - 100) / 2),
            
            rightButton.topAnchor.constraint(equalTo:
                                            containerView.topAnchor),
            rightButton.leadingAnchor.constraint(equalTo:
                                                        topButton.trailingAnchor),
            rightButton.heightAnchor.constraint(equalToConstant: 120),
            rightButton.widthAnchor.constraint(equalToConstant:
                                            (CGFloat.toolBarWidth - 100) / 2),
            
            doneButton.widthAnchor.constraint(equalToConstant: 50),
            doneButton.heightAnchor.constraint(equalToConstant: 50),
            doneButton.topAnchor.constraint(equalTo: 
                                            picker.topAnchor, 
                                            constant: 15),
            doneButton.trailingAnchor.constraint(equalTo:
                                            picker.trailingAnchor,
                                            constant: -15),
            
            pickerTitle.centerXAnchor.constraint(equalTo: picker.centerXAnchor),
            pickerTitle.centerYAnchor.constraint(equalTo: picker.centerYAnchor,
                                                 constant: -3),
            
            distanceTitle.centerXAnchor.constraint(equalTo: 
                                                    leftButton.centerXAnchor),
            distanceTitle.bottomAnchor.constraint(equalTo:
                                            containerView.topAnchor, 
                                            constant: -5),
            
            speedTitle.centerXAnchor.constraint(equalTo: textfield.centerXAnchor),
            speedTitle.bottomAnchor.constraint(equalTo: 
                                            containerView.topAnchor,
                                            constant: -5),
            
            timeTitle.centerXAnchor.constraint(equalTo: 
                                                rightButton.centerXAnchor),
            timeTitle.bottomAnchor.constraint(equalTo:
                                            containerView.topAnchor,
                                            constant: -5),
            
            paceTitle.centerXAnchor.constraint(equalTo: bottomButton.centerXAnchor),
            paceTitle.topAnchor.constraint(equalTo:
                                                containerView.bottomAnchor,
                                                constant: 5),
            
            metricsTitle.centerXAnchor.constraint(equalTo:
                                                    leftButton.centerXAnchor),
            metricsTitle.topAnchor.constraint(equalTo:
                                                containerView.bottomAnchor,
                                                constant: 5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - PickerViewDelegate&Datasource

extension CalculationsViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch currentStateOfPicker {
            
        case .speed:
            return 2
        case .pace:
            return 2
        case .distance:
            return 2
        case .time:
            return 3
        case .none:
            break
        }
        return Int()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch currentStateOfPicker {
            
        case .speed:
            if component == 0 {
                return 100
            } else if component == 1 {
                return 10
            }
            
        case .pace:
            if component == 0 {
                return 100
            } else if component == 1 {
                return 60
            }
        case .distance:
            if component == 0 {
                return 100
            } else if component == 1 {
                return 10
            }
        case .time:
            if component == 0 {
                return 100
            } else if component == 1 {
                return 60
            } else if component == 2 {
                return 60
            }
        case .none:
            break
        }
        return Int()
        
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 50
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium, width: .compressed)
        
        switch currentStateOfPicker {
            
        case .speed:
            label.text = String(row)
            
        case .pace:
            if row < 10 {
                label.text = "0\(String(row))"
            } else {
                label.text = String(row)
            }
        case .distance:
            label.text = String(row)
        case .time:
            if row < 10 {
                label.text = "0\(String(row))"
            } else {
                label.text = String(row)
            }
        case .none:
            break
        }
       
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch currentStateOfPicker {
            
        case .speed:
            
            if component == 0 {
                UD.shared.speed = row
                calculateSpeed()
                updateValues()
            } else if component == 1 {
                UD.shared.speedDecimal = row
                calculateSpeed()
                updateValues()
            }
        case .pace:
            if component == 0 {
                UD.shared.paceMin = row
                calculatePace()
                updateValues()
            } else if component == 1 {
                UD.shared.paceSec = row
                calculatePace()
                updateValues()
            }
        case .distance:
            if component == 0 {
                UD.shared.distance = row
                calculateDistance()
                updateValues()
            } else if component == 1 {
                UD.shared.distanceDecimal = row
                calculateDistance()
                updateValues()
            }
        case .time:
            if component == 0 {
                UD.shared.timeH = row
                calculateTime()
                updateValues()
            } else if component == 1 {
                UD.shared.timeMin = row
                calculateTime()
                updateValues()
            } else if component == 2 {
                UD.shared.timeSec = row
                calculateTime()
                updateValues()
            }
        case .none:
            break
        }
    }
    
}

