//
//  TrackerButton.swift
//  OneDot
//
//  Created by Александр Коробицын on 10.07.2023.
//

import UIKit

class TabBar: UIView {
    
    typealias UD = UserDefaultsManager
    
    private let feedbackGen = UISelectionFeedbackGenerator()
    
    private let leftButton: UIButton = UIButton()
    private let rightButton: UIButton = UIButton()
    private let separator: CAShapeLayer = CAShapeLayer()
    
    private let picker: UIPickerView = UIPickerView()

    
    private enum TabBarStatus {
        case prepare
        case prepareToStart
        case tracking
    }
    
    private enum StateOfPicker {
        case distance,
             speed,
             pace,
             time
    }
    
    private var currentStateOfPicker: StateOfPicker?
    
    private var currentStatus: TabBarStatus = .prepare

    var showProfile: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setViews()
        setConstraints()
        
        picker.delegate = self
        picker.dataSource = self
        
        currentStateOfPicker = .distance
    }
    
    //MARK: - ButtonMethods
    
    @objc private func leftTapped() {
        feedbackGen.selectionChanged()
        
        switch currentStatus {
        case .prepare:
            currentStatus = .prepareToStart
            updateButtonImages(status: .prepareToStart)
            Animator.shared.AnimateStartIcon(leftButton.layer)
        case .prepareToStart:
            currentStatus = .tracking
            updateButtonImages(status: .tracking)
            leftButton.layer.removeAllAnimations()
        case .tracking:
            currentStatus = .prepareToStart
            updateButtonImages(status: .prepareToStart)
            Animator.shared.AnimateStartIcon(leftButton.layer)
        }
    }
    
    @objc private func rightTapped() {
        feedbackGen.selectionChanged()
        
        switch currentStatus {
        case .prepare:
            showProfile?()
        case .prepareToStart, .tracking:
            currentStatus = .prepare
            updateButtonImages(status: .prepare)
            leftButton.layer.removeAllAnimations()
        }
    }
    
    private func updateButtonImages(status: TabBarStatus) {
        switch status {
            
        case .prepare:
            leftButton.setImage(UIImage(named: "TBStart"), for: .normal)
            leftButton.setImage(UIImage(named: "TBStart"), for: .highlighted)
            rightButton.setImage(UIImage(named: "TBProfile"), for: .normal)
            rightButton.setImage(UIImage(named: "TBProfile"), for: .highlighted)
        case .prepareToStart:
            leftButton.setImage(UIImage(named: "TBStart"), for: .normal)
            leftButton.setImage(UIImage(named: "TBStart"), for: .highlighted)
            rightButton.setImage(UIImage(named: "TBCancel"), for: .normal)
            rightButton.setImage(UIImage(named: "TBCancel"), for: .highlighted)
        case .tracking:
            leftButton.setImage(UIImage(named: "TBPause"), for: .normal)
            leftButton.setImage(UIImage(named: "TBPause"), for: .highlighted)
            rightButton.setImage(UIImage(named: "TBStop"), for: .normal)
            rightButton.setImage(UIImage(named: "TBStop"), for: .highlighted)
        }
    }
    
    func test(cases: CalculationsView.StateOfPicker) {
        switch cases {
        case .distance:
            currentStateOfPicker = .distance
            picker.reloadAllComponents()
            picker.selectRow(UD.shared.distance, inComponent: 0, animated: true)
            picker.selectRow(UD.shared.distanceDecimal, inComponent: 1, animated: true)
        case .speed:
            currentStateOfPicker = .speed
            picker.reloadAllComponents()
            picker.selectRow(UD.shared.speed, inComponent: 0, animated: true)
            picker.selectRow(UD.shared.speedDecimal, inComponent: 1, animated: true)
        case .pace:
            currentStateOfPicker = .pace
            picker.reloadAllComponents()
            picker.selectRow(UD.shared.paceMin, inComponent: 0, animated: true)
            picker.selectRow(UD.shared.paceSec, inComponent: 1, animated: true)
        case .time:
            currentStateOfPicker = .time
            picker.reloadAllComponents()
            picker.selectRow(UD.shared.timeH, inComponent: 0, animated: true)
            picker.selectRow(UD.shared.timeMin, inComponent: 1, animated: true)
            picker.selectRow(UD.shared.timeSec, inComponent: 2, animated: true)
        }
    }

    
    
    //MARK: - SetViews
    
    private func setViews() {
        backgroundColor = .myPaletteBlue
        layer.cornerRadius = .barCorner
        layer.cornerCurve = .continuous
        
        addSubview(leftButton)
        addSubview(rightButton)
        
        addSubview(picker)
        
        updateButtonImages(status: .prepare)
        
        leftButton.addTarget(self, action: #selector(leftTapped), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightTapped), for: .touchUpInside)
        
        Shaper.shared.drawTabBarSeparator(shape: separator, view: self)
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
            
            picker.topAnchor.constraint(equalTo: topAnchor),
            picker.trailingAnchor.constraint(equalTo: trailingAnchor),
            picker.bottomAnchor.constraint(equalTo: bottomAnchor),
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
        label.textColor = .white
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
//                calculateSpeed()
//                updateValues()
            } else if component == 1 {
                UD.shared.speedDecimal = row
//                calculateSpeed()
//                updateValues()
            }
        case .pace:
            if component == 0 {
                UD.shared.paceMin = row
//                calculatePace()
//                updateValues()
            } else if component == 1 {
                UD.shared.paceSec = row
//                calculatePace()
//                updateValues()
            }
        case .distance:
            if component == 0 {
                UD.shared.distance = row
//                calculateDistance()
//                updateValues()
            } else if component == 1 {
                UD.shared.distanceDecimal = row
//                calculateDistance()
//                updateValues()
            }
        case .time:
            if component == 0 {
                UD.shared.timeH = row
//                calculateTime()
//                updateValues()
            } else if component == 1 {
                UD.shared.timeMin = row
//                calculateTime()
//                updateValues()
            } else if component == 2 {
                UD.shared.timeSec = row
//                calculateTime()
//                updateValues()
            }
        case .none:
            break
        }
    }
    
}


