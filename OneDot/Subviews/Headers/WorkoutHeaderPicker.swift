//
//  MainBarRoomPicker.swift
//  OneDot
//
//  Created by Александр Коробицын on 26.10.2023.
//

import Foundation
import UIKit

class WorkoutHeaderPicker: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    
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
    
    func updatePicker(outdoorIs: Bool, row: Int) {
        
        outdoorLocation = outdoorIs
        picker.reloadAllComponents()
        picker.selectRow(row, inComponent: 0, animated: true)
        getTitle(row: row)
    }
    
    
    private func getTitle(row: Int) {
        
        if outdoorLocation {
            title.text = exercises.get(.street)[row].name
        } else {
            title.text = exercises.get(.room)[row].name
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return outdoorLocation ? exercises.get(.street).count : exercises.get(.room).count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        getTitle(row: row)
        
        if outdoorLocation {
            UserDefaultsManager.shared.pickerRowOutdoorValue = row
        } else {
            UserDefaultsManager.shared.pickerRowIndoorValue = row
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        40
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        45
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        pickerView.subviews.forEach{$0.backgroundColor = .clear}
        
        let imageView = UIImageView()
        imageView.backgroundColor = .none
        imageView.contentMode = .scaleAspectFit
        imageView.transform = CGAffineTransform(rotationAngle: 90 * (.pi / 180))

        let exerciseList = outdoorLocation ? exercises.get(.street) : exercises.get(.room)
        imageView.image = UIImage(named: exerciseList[row].pickerIcon)
        
        return imageView
    }
    
    //MARK: - SetViews
    
    private func setViews() {
        addSubview(picker)
        picker.backgroundColor = .none
        picker.transform = CGAffineTransform(rotationAngle: -90 * (.pi / 180))
        
        addSubview(title)
        title.clipsToBounds = true
        title.instance(color: .myPaletteGray, alignment: .center, font: .condensedMax)
        
        ShapeManager.shared.drawPickerViewDotSeparator(shape: dotSeparator, view: self)
    }
    
    //MARK: - SetConstraints
    
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

