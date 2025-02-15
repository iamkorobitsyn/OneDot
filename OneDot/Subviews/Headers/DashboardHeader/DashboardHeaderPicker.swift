//
//  MainBarRoomPicker.swift
//  OneDot
//
//  Created by Александр Коробицын on 26.10.2023.
//

import Foundation
import UIKit

class DashboardHeaderPicker: UIView, UIPickerViewDataSource, UIPickerViewDelegate {

    let factoryWorkouts = FactoryWorkouts()
    var geoTrackingState = UserDefaultsManager.shared.isGeoTracking

    let picker: UIPickerView = UIPickerView()
    let title: UILabel = UILabel()
    
    private let lineSeparator: CAShapeLayer = CAShapeLayer()
    private let dotSeparator: CAShapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        picker.dataSource = self
        picker.delegate = self
        
        setViews()
        setConstraints()
    }
    
    func updatePicker(isGeoTracking: Bool) {
        geoTrackingState = isGeoTracking
        
        if geoTrackingState {
            let row = UserDefaultsManager.shared.pickerRowWithGeoTrackingActive
            picker.reloadAllComponents()
            picker.selectRow(row, inComponent: 0, animated: true)
        } else {
            let row = UserDefaultsManager.shared.pickerRowWithGeoTrackingInactive
            picker.reloadAllComponents()
            picker.selectRow(row, inComponent: 0, animated: true)
        }
    }
    
    func updateCurrentWorkout() -> Workout {
        let workoutList = factoryWorkouts.get(isGeoTracking: geoTrackingState)
        if geoTrackingState {
            let row = UserDefaultsManager.shared.pickerRowWithGeoTrackingActive
            let workout = workoutList[row]
            title.text = workout.name
            return workout
        } else {
            let row = UserDefaultsManager.shared.pickerRowWithGeoTrackingInactive
            let workout = workoutList[row]
            title.text = workout.name
            return workout
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return factoryWorkouts.get(isGeoTracking: geoTrackingState).count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if geoTrackingState {
            UserDefaultsManager.shared.pickerRowWithGeoTrackingActive = row
        } else {
            UserDefaultsManager.shared.pickerRowWithGeoTrackingInactive = row
        }
        let workout = updateCurrentWorkout()
        title.text = workout.name
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

        let workoutList = factoryWorkouts.get(isGeoTracking: geoTrackingState)
        imageView.image = UIImage(named: workoutList[row].pickerIconName)
        
        return imageView
    }
    
    //MARK: - SetViews
    
    private func setViews() {
        addSubview(picker)
        picker.backgroundColor = .none
        picker.transform = CGAffineTransform(rotationAngle: -90 * (.pi / 180))
        
        addSubview(title)
        title.clipsToBounds = true
        title.instance(color: .myPaletteGray, alignment: .center, font: .standartMid)
        let workout = updateCurrentWorkout()
        title.text = workout.name
        
        ShapeManager.shared.drawPickerViewDotSeparator(shape: dotSeparator, view: self)
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        picker.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            picker.widthAnchor.constraint(equalToConstant: 40),
            picker.heightAnchor.constraint(equalToConstant: 150),
            picker.centerYAnchor.constraint(equalTo: centerYAnchor),
            picker.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -.barWidth / 4),
            
            title.centerYAnchor.constraint(equalTo: centerYAnchor),
            title.centerXAnchor.constraint(equalTo: centerXAnchor, constant: .barWidth / 4)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

