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
    
    private init() {
    }

    
    //MARK: - GETSET
    
    func getInteger(forKey: String, defaultValue: Int) -> Int {
        UserDefaults.standard.value(forKey: forKey) as? Int ?? defaultValue
    }
    
    func setInteger(value: Int, forKey: String) {
        UserDefaults.standard.setValue(value, forKey: forKey)
    }
    
    
    //MARK: - Metronome
    
    var bpmState: Int {
        get { getInteger(forKey: "bpmState", defaultValue: 150) }
        set { setInteger(value: newValue, forKey: "bpmState") }
    }
    
    var beatState: Int {
        get { getInteger(forKey: "beatState", defaultValue: 0) }
        set { setInteger(value: newValue, forKey: "beatState") }
    }
    
    //MARK: Calculations
    
    var distance: Int {
        get { getInteger(forKey: "distance", defaultValue: 0) }
        set { setInteger(value: newValue, forKey: "distance") }
    }
    
    var distanceDecimal: Int {
        get { getInteger(forKey: "distanceDecimal", defaultValue: 0) }
        set { setInteger(value: newValue, forKey: "distanceDecimal") }
    }
    
    var speed: Int {
        get { getInteger(forKey: "speed", defaultValue: 0) }
        set { setInteger(value: newValue, forKey: "speed") }
    }
    
    var speedDecimal: Int {
        get { getInteger(forKey: "speedDecimal", defaultValue: 0) }
        set { setInteger(value: newValue, forKey: "speedDecimal") }
    }
    
    var paceMin: Int {
        get { getInteger(forKey: "paceMin", defaultValue: 0) }
        set { setInteger(value: newValue, forKey: "paceMin") }
    }
    
    var paceSec: Int {
        get { getInteger(forKey: "paceSec", defaultValue: 0) }
        set { setInteger(value: newValue, forKey: "paceSec") }
    }
    
    var timeH: Int {
        get { getInteger(forKey: "timeH", defaultValue: 0) }
        set { setInteger(value: newValue, forKey: "timeH") }
    }
    
    var timeMin: Int {
        get { getInteger(forKey: "timeMin", defaultValue: 0) }
        set { setInteger(value: newValue, forKey: "timeMin") }
    }
    
    var timeSec: Int {
        get { getInteger(forKey: "timeSec", defaultValue: 0) }
        set { setInteger(value: newValue, forKey: "timeSec") }
    }
    
    //MARK: ToolsStatus
    
    var calculationsStatus: Int {
        get {
            return userDefaults.value(forKey: "calculationsState") as? Int ?? 0
        } set {
            userDefaults.setValue(newValue, forKey: "calculationsState")
        }
    }
    
    var themesStatus: Int {
        get {
            return userDefaults.value(forKey: "themesStatus") as? Int ?? 0
        } set {
            userDefaults.setValue(newValue, forKey: "themesStatus")
        }
    }
    
    //MARK: - UserIndoor&ExersiseStatus
    
    var userIndoorStatus: Bool {
        get {
            return userDefaults.value(forKey: "userIndoorStatus") as? Bool ?? false
        } set {
            userDefaults.setValue(newValue, forKey: "userIndoorStatus")
            userDefaults.synchronize()
        }
    }
    
    var pickerRowIndoor: Int {
        get {
            return userDefaults.value(forKey: "pickerRowIndoor") as? Int ?? 3
        } set {
            userDefaults.setValue(newValue, forKey: "pickerRowIndoor")
            userDefaults.synchronize()
        }
    }
    
    var pickerRowOutdoor: Int {
        get {
            return userDefaults.value(forKey: "pickerRowOutdoor") as? Int ?? 3
        } set {
            userDefaults.setValue(newValue, forKey: "pickerRowOutdoor")
            userDefaults.synchronize()
        }
    }
    
    //MARK: - Settings
    
    private let countDownKey = "countDown"
    private let autopauseKey = "autopause"
    private let unitKey = "unit"
    private let temperatureKey = "temperature"
    
    private let weeklyReportEmailKey = "weeklyReportEmail"
    private let weeklyReportPushKey = "weeklyReportPush"
    private let achievingGoalsKey = "achievingGoals"
    
    private let appleWatchKey = "appleWatch"
    private let garminKey = "garmin"
    private let fitbitKey = "fitbit"
    private let appleMusicKey = "appleMusic"
    private let spotifyKey = "spotify"
    
    private let colorThemeKey = "color"
    
    //MARK: - MeasuringView
    
    var countDownValue: Int {
        get {
            userDefaults.value(forKey: "countDownValue") as? Int ?? 3
        } set {
            userDefaults.setValue(newValue, forKey: "countDownValue")
            userDefaults.synchronize()
        }
    }
    
    func autopauseLoad() -> Bool {
        if let value = userDefaults.value(forKey: autopauseKey) as? Bool {
            return value
        } else {
            return false
        }
    }
    
    func autopauseSave(_ value: Bool) {
        userDefaults.setValue(value, forKey: autopauseKey)
    }
    
    func unitLoad() -> Bool {
        if let value = userDefaults.value(forKey: unitKey) as? Bool {
            return value
        } else {
            return true
        }
    }
    
    func unitSave(_ value: Bool) {
        userDefaults.setValue(value, forKey: unitKey)
    }
    
    func temperatureLoad() -> Bool {
        if let value = userDefaults.value(forKey: temperatureKey) as? Bool {
            return value
        } else {
            return true
        }
    }
    
    func temperatureSave(_ value: Bool) {
        userDefaults.setValue(value, forKey: temperatureKey)
    }
    
    //MARK: - NotificationsView
    
    func weeklyReportEmailLoad() -> Bool {
        if let value = userDefaults.value(forKey: weeklyReportEmailKey) as? Bool {
            return value
        } else {
            return false
        }
    }
    
    func weeklyReportPushLoad() -> Bool {
        if let value = userDefaults.value(forKey: weeklyReportPushKey) as? Bool {
            return value
        } else {
            return false
        }
    }
    
    func weeklyReportEmailSave(_ value: Bool) {
        userDefaults.setValue(value, forKey: weeklyReportEmailKey)
    }
    
    func weeklyReportPushSave(_ value: Bool) {
        userDefaults.setValue(value, forKey: weeklyReportPushKey)
    }
    
    func achievingGoalsLoad() -> Bool {
        if let value = userDefaults.value(forKey: achievingGoalsKey) as? Bool {
            return value
        } else {
            return false
        }
    }
    
    func acheivingGoalsSave(_ value: Bool) {
        userDefaults.setValue(value, forKey: achievingGoalsKey)
    }
    
    //MARK: - IntegrationsView
    
    func appleWatchLoad() -> Bool {
        if let value = userDefaults.value(forKey: appleWatchKey) as? Bool {
            return value
        } else {
            return false
        }
    }
    
    func appleWatchSave(_ value: Bool) {
        userDefaults.setValue(value, forKey: appleWatchKey)
    }
    
    func garminLoad() -> Bool {
        if let value = userDefaults.value(forKey: garminKey) as? Bool {
            return value
        } else {
            return false
        }
    }
    
    func garminSave(_ value: Bool) {
        userDefaults.setValue(value, forKey: garminKey)
    }
    
    func fitbitLoad() -> Bool {
        if let value = userDefaults.value(forKey: fitbitKey) as? Bool {
            return value
        } else {
            return false
        }
    }
    
    func fitbitSave(_ value: Bool) {
        userDefaults.setValue(value, forKey: fitbitKey)
    }
    
    func appleMusicLoad() -> Bool {
        if let value = userDefaults.value(forKey: appleMusicKey) as? Bool {
            return value
        } else {
            return false
        }
    }
    
    func appleMusicSave(_ value: Bool) {
        userDefaults.setValue(value, forKey: appleMusicKey)
    }
    
    func spotifyLoad() -> Bool {
        if let value = userDefaults.value(forKey: spotifyKey) as? Bool {
            return value
        } else {
            return false
        }
    }
    
    func spotifySave(_ value: Bool) {
        userDefaults.setValue(value, forKey: spotifyKey)
    }
    
    //MARK: - ColorThemesView
    
    
    func colorThemeLoad() -> String {
        if let value = userDefaults.value(forKey: colorThemeKey) as? String {
            return value
        } else {
            return "sunsetSky"
        }
    }
    
    func colorThemeSave(_ value: String) {
        userDefaults.setValue(value, forKey: countDownKey)
    }
    
}
