//
//  MainBarRoomPicker.swift
//  OneDot
//
//  Created by Александр Коробицын on 26.10.2023.
//

import Foundation
import UIKit

class TrackerBarPickerView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var currentLocation: String = ""
    
    let exercises = FactoryExercises()
    var completion: ((Exercise) -> ())?

    
    let picker: UIPickerView = UIPickerView()
    let title: UILabel = UILabel()
    let titleView: UIImageView = UIImageView()
    
    
    //MARK: - Metrics
    
    let mainBarWidth: CGFloat = UIScreen.main.bounds.width / 1.05
    let pickerWidth: CGFloat = 40
    let pickerHeight: CGFloat = 150
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setViews()
        setConstraints()
    }
    
        
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if currentLocation == "room" {
            return exercises.get(.room).count
        }
        if currentLocation == "street" {
            return exercises.get(.street).count
        }
            return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if currentLocation == "room" {
            for index in 0..<exercises.get(.room).count {
                if row == index {
                    UserDefaultsManager.shared.pickerRowIndoor = row
                    title.text = exercises.get(.room)[row].titleName
                    titleView.image = UIImage(named:
                    exercises.get(.room)[row].titleIcon)
                    completion?(exercises.get(.room)[row])
                }
            }
        }
        
        if currentLocation == "street" {
                for index in 0..<exercises.get(.street).count {
                    if row == index {
                        UserDefaultsManager.shared.pickerRowOutdoor = row
                        title.text = exercises.get(.street)[row].titleName
                        titleView.image = UIImage(named:
                        exercises.get(.street)[row].titleIcon)
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
        
        
        
        if currentLocation == "room" {
            let imageView = UIImageView()
            imageView.image = UIImage(named:
                                        exercises.get(.room)[row].pickerIcon)
            imageView.backgroundColor = .none
            imageView.contentMode = .scaleAspectFit
            let rotationAngle: CGFloat = 90 * (.pi / 180)
            imageView.transform = CGAffineTransform(rotationAngle: rotationAngle)
            return imageView
        }
        
        if currentLocation == "street" {
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
        picker.dataSource = self
        picker.delegate = self
        
        let rotationAngle: CGFloat = -90 * (.pi / 180)
        picker.transform = CGAffineTransform(rotationAngle: rotationAngle)
        
        addSubview(title)
        title.clipsToBounds = true
        title.font = UIFont.systemFont(ofSize: 20, weight: .medium, width: .compressed)
        title.textColor = .gray
        
        addSubview(titleView)
        titleView.contentMode = .scaleAspectFit
    }
    
    private func setConstraints() {
        picker.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            picker.widthAnchor.constraint(equalToConstant: pickerWidth),
            picker.heightAnchor.constraint(equalToConstant: pickerHeight),
            picker.centerYAnchor.constraint(equalTo: centerYAnchor),
            picker.centerXAnchor.constraint(equalTo: centerXAnchor, constant:
                                            -mainBarWidth / 4 + 5),
            
            title.centerYAnchor.constraint(equalTo: centerYAnchor),
            title.centerXAnchor.constraint(equalTo: centerXAnchor, constant:
                                            mainBarWidth / 4 - 5),
            
            titleView.widthAnchor.constraint(equalToConstant: 25),
            titleView.heightAnchor.constraint(equalToConstant: 25),
            titleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

