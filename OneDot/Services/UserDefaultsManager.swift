//
//  UserDefaultsManager.swift
//  OneDot
//
//  Created by Александр Коробицын on 28.09.2023.
//

import Foundation

class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    let userDefaults = UserDefaults.standard
    
    private init() {}
    
    private enum Keys {
        static let outdoorStatus = "outdoorStatus"
        static let pickerRowIndoor = "pickerRowIndoor"
        static let pickerRowOutdoor = "pickerRowOutdoor"
        static let calculationsDistance = "calculationsDistance"
        static let calculationsDistanceDecimal = "calculationsDistanceDecimal"
        static let calculationsSpeed = "calculationsSpeed"
        static let calculationsSpeedDecimal = "calculationsSpeedDecimal"
        static let calculationsPaceMin = "calculationsPaceMin"
        static let calculationsPaceSec = "calculationsPaceSec"
        static let calculationsTimeH = "calculationsTimeH"
        static let calculationsTimeMin = "calculationsTimeMin"
        static let calculationsTimeSec = "calculationsTimeSec"
        static let settingsDistanceValue = "settingsDistanceValue"
        static let settingsAutopauseValue = "settingsAutopauseValue"
        static let settingsCountdownValue = "settingsCountdownValue"
        static let settingsAppleHealthValue = "settingsAppleHealthValue"
        static let profileMetricsPageValue = "profileMetricsPageValue"
    }
    
    private func getValue<T> (key: String, defaultValue: T ) -> T {
        userDefaults.value(forKey: key) as? T ?? defaultValue
    }
    
    private func setValue<T> (key: String, value: T) {
        userDefaults.setValue(value, forKey: key)
        userDefaults.synchronize()
    }

    
    //MARK: - UserIndoor&ExersiseStatus
    
    var outdoorStatusValue: Bool {
        get { getValue(key: Keys.outdoorStatus, defaultValue: false) }
        set { setValue(key: Keys.outdoorStatus, value: newValue) }
    }
    
    var pickerRowIndoorValue: Int {
        get { getValue(key: Keys.pickerRowIndoor, defaultValue: 3) }
        set { setValue(key: Keys.pickerRowIndoor, value: newValue) }
    }
    
    var pickerRowOutdoorValue: Int {
        get { getValue(key: Keys.pickerRowOutdoor, defaultValue: 3) }
        set { setValue(key: Keys.pickerRowOutdoor, value: newValue) }
    }
    
    //MARK: Calculations
    
    var calculationsDistanceValue: Int {
        get { getValue(key: Keys.calculationsDistance, defaultValue: 0) }
        set { setValue(key: Keys.calculationsDistance, value: newValue) }
    }
    
    var calculationsDistanceDecimalValue: Int {
        get { getValue(key: Keys.calculationsDistanceDecimal, defaultValue: 0) }
        set { setValue(key: Keys.calculationsDistanceDecimal, value: newValue) }
    }
    
    var calculationsSpeedValue: Int {
        get { getValue(key: Keys.calculationsSpeed, defaultValue: 0) }
        set { setValue(key: Keys.calculationsSpeed, value: newValue) }
    }
    
    var calculationsSpeedDecimalValue: Int {
        get { getValue(key: Keys.calculationsSpeedDecimal, defaultValue: 0) }
        set { setValue(key: Keys.calculationsSpeedDecimal, value: newValue) }
    }
    
    var calculationsPaceMinValue: Int {
        get { getValue(key: Keys.calculationsPaceMin, defaultValue: 0) }
        set { setValue(key: Keys.calculationsPaceMin, value: newValue) }
    }
    
    var calculationsPaceSecValue: Int {
        get { getValue(key: Keys.calculationsPaceSec, defaultValue: 0) }
        set { setValue(key: Keys.calculationsPaceSec, value: newValue) }
    }
    
    var calculationsTimeHValue: Int {
        get { getValue(key: Keys.calculationsTimeH, defaultValue: 0) }
        set { setValue(key: Keys.calculationsTimeH, value: newValue) }
    }
    
    var calculationsTimeMinValue: Int {
        get { getValue(key: Keys.calculationsTimeMin, defaultValue: 0) }
        set { setValue(key: Keys.calculationsTimeMin, value: newValue) }
    }
    
    var calculationsTimeSecValue: Int {
        get { getValue(key: Keys.calculationsTimeSec, defaultValue: 0) }
        set { setValue(key: Keys.calculationsTimeSec, value: newValue) }
    }

    
    
    
    //MARK: - Settings
    
    var settingsDistanceValue: Int {
        get { getValue(key: Keys.settingsDistanceValue, defaultValue: 0) }
        set { setValue(key: Keys.settingsDistanceValue, value: newValue) }
    }
    
    var settingsAutopauseValue: Bool {
        get { getValue(key: Keys.settingsAutopauseValue, defaultValue: false) }
        set { setValue(key: Keys.settingsAutopauseValue, value: newValue)}
    }
    
    var settingsCountdownValue: Bool {
        get { getValue(key: Keys.settingsCountdownValue, defaultValue: true) }
        set { setValue(key: Keys.settingsCountdownValue, value: newValue) }
    }
    
    var settingsAppleHealthValue: Bool {
        get { getValue(key: Keys.settingsAppleHealthValue, defaultValue: false) }
        set { setValue(key: Keys.settingsAppleHealthValue, value: newValue) }
    }
    
    //MARK: - Profile
    
    var profileMetricsPageValue: Int {
        get { getValue(key: Keys.profileMetricsPageValue, defaultValue: 0) }
        set { setValue(key: Keys.profileMetricsPageValue, value: newValue) }
    }

}
