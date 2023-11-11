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
    
    //MARK: - MainBody
    
    private let calculatorKey = "calculator"
    private let soundKey = "sound"
    private let themesKey = "themes"
    
    func calculatorViewLoad() -> Int {
        if let value = userDefaults.value(forKey: calculatorKey) as? Int {
            return value
        } else {
            return 0
        }
    }
    
    func calculatorViewSave(_ value: Int) {
        userDefaults.setValue(value, forKey: calculatorKey)
    }
    
    func soundViewLoad() -> Int {
        if let value = userDefaults.value(forKey: soundKey) as? Int {
            return value
        } else {
            return 0
        }
    }
    
    func soundViewSave(_ value: Int) {
        userDefaults.setValue(value, forKey: soundKey)
    }
    
    func themesViewLoad() -> Int {
        if let value = userDefaults.value(forKey: themesKey) as? Int {
            return value
        } else {
            return 0
        }
    }
    
    func themesViewSave(_ value: Int) {
        userDefaults.setValue(value, forKey: themesKey)
    }
    
    //MARK: - MainHeader
    
    private let selectorKey = "selector"
    private let inRoomKey = "inRoom"
    private let onTheStreetKey = "onTheStreet"
    
    func selectorLoad() -> String {
        if let value = userDefaults.value(forKey: selectorKey) as? String {
            return value
        } else {
            return "street"
        }
    }
    
    func selectorSave(_ value: String) {
        userDefaults.setValue(value, forKey: selectorKey)
    }
    
    func inRoomLoad() -> Int {
        if let value = userDefaults.value(forKey: inRoomKey) as? Int {
            return value
        } else {
            return 3
        }
    }
    
    func inRoomSave(_ value: Int) {
        userDefaults.setValue(value, forKey: inRoomKey)
    }
    
    func onTheStreetLoad() -> Int {
        if let value = userDefaults.value(forKey: onTheStreetKey) as? Int {
            return value
        } else {
            return 3
        }
    }
    
    func onTheStreetSave(_ value: Int) {
        userDefaults.setValue(value, forKey: onTheStreetKey)
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
    
    
    func countDownLoad() -> String {
        if let value = userDefaults.value(forKey: countDownKey) as? String {
            return value
        } else {
            return "3"
        }
    }
    
    func countDownSave(_ value: String) {
        userDefaults.setValue(value, forKey: countDownKey)
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
