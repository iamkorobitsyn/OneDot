//
//  MainBarRoomPicker.swift
//  OneDot
//
//  Created by Александр Коробицын on 26.10.2023.
//

import Foundation
import UIKit

class HeaderBarPickerView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var outdoorLocation: Bool = true
    
    let exercises = FactoryExercises()
    var completion: ((Exercise) -> ())?

    let picker: UIPickerView = UIPickerView()
    let title: UILabel = UILabel()
    
    private let lineSeparator: CAShapeLayer = CAShapeLayer()
    private let dotSeparator: CAShapeLayer = CAShapeLayer()
    
    //MARK: - Metrics
    
    let mainBarWidth: CGFloat = UIScreen.main.bounds.width / 1.05
    let pickerWidth: CGFloat = 40
    let pickerHeight: CGFloat = 150
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        picker.dataSource = self
        picker.delegate = self
        
        setViews()
        setConstraints()

    }
    
    func updatePicker(outdoor: Bool, row: Int) {
        picker.reloadAllComponents()

        if outdoor {
            outdoorLocation = outdoor
            picker.selectRow(row, inComponent: 0, animated: true)
            let currentExercise = exercises.get(.street)[row]
            title.text = currentExercise.titleName
        } else {
            outdoorLocation = outdoor
            picker.selectRow(row, inComponent: 0, animated: true)
            let currentExercise = exercises.get(.room)[row]
            title.text = currentExercise.titleName
        }
        
    }
    
        
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if outdoorLocation {
            return exercises.get(.room).count
        } else {
            return exercises.get(.street).count
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if outdoorLocation == false {
            for index in 0..<exercises.get(.room).count {
                if row == index {
                    UserDefaultsManager.shared.pickerRowIndoor = row
                    title.text = exercises.get(.room)[row].titleName
                    completion?(exercises.get(.room)[row])
                }
            }
        }
        
        if outdoorLocation == true {
                for index in 0..<exercises.get(.street).count {
                    if row == index {
                        UserDefaultsManager.shared.pickerRowOutdoor = row
                        title.text = exercises.get(.street)[row].titleName
                        completion?(exercises.get(.street)[row]) 
                }
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        40
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        45
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        pickerView.subviews.forEach {
            $0.backgroundColor = .clear
        }
        
        
        
        if outdoorLocation == false {
            let imageView = UIImageView()
            imageView.image = UIImage(named:
                                        exercises.get(.room)[row].pickerIcon)
            imageView.backgroundColor = .none
            imageView.contentMode = .scaleAspectFit
            let rotationAngle: CGFloat = 90 * (.pi / 180)
            imageView.transform = CGAffineTransform(rotationAngle: rotationAngle)
            return imageView
        }
        
        if outdoorLocation == true {
            let imageView = UIImageView()
            imageView.image = UIImage(named:
                                    exercises.get(.street)[row].pickerIcon)
            imageView.backgroundColor = .none
            imageView.contentMode = .scaleAspectFit
            let rotationAngle: CGFloat = 90 * (.pi / 180)
            imageView.transform = CGAffineTransform(rotationAngle: rotationAngle)
            return imageView
        }
        
        return UIView()
    }
    
    private func setViews() {
        addSubview(picker)
        picker.backgroundColor = .none
        
        let rotationAngle: CGFloat = -90 * (.pi / 180)
        picker.transform = CGAffineTransform(rotationAngle: rotationAngle)
        
        addSubview(title)
        title.clipsToBounds = true
        title.font = UIFont.systemFont(ofSize: 20, weight: .medium, width: .compressed)
        title.textColor = .myPaletteGray

        Shaper.shared.drawPickerViewLineSeparator(shape: lineSeparator, view: picker)
        Shaper.shared.drawPickerViewDotSeparator(shape: dotSeparator, view: self)
    }
    
    private func setConstraints() {
        picker.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            picker.widthAnchor.constraint(equalToConstant: pickerWidth),
            picker.heightAnchor.constraint(equalToConstant: pickerHeight),
            picker.centerYAnchor.constraint(equalTo: centerYAnchor),
            picker.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -mainBarWidth / 4),
            
            title.centerYAnchor.constraint(equalTo: centerYAnchor),
            title.centerXAnchor.constraint(equalTo: centerXAnchor, constant: mainBarWidth / 4)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

