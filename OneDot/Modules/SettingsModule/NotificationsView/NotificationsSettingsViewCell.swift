//
//  NotificationsSettingsView.swift
//  OneDot
//
//  Created by Александр Коробицын on 10.10.2023.
//

import Foundation
import UIKit

class NotificationsSettingsViewCell: SettingsBaseViewCell {
    
    private var weeklyReportStackWidth = CGFloat()
    
//    private let mainTitle: UILabel = UILabel()
    private let mainSeparator: CAShapeLayer = CAShapeLayer()
    private let weeklyReportStackSeparator: CAShapeLayer = CAShapeLayer()
    
    //MARK: - Buttons
    
    let weeklyReportTitle: UILabel = UILabel()
    let weeklyReportEmailEnabledView: NotificationButtonView = NotificationButtonView()
    let weeklyReportEmailDisabledView: NotificationButtonView = NotificationButtonView()
    
    let weeklyReportPushEnabledView: NotificationButtonView = NotificationButtonView()
    let weeklyReportPushDisabledView: NotificationButtonView = NotificationButtonView()
    
//    let weeklyReportEmailTitle: UILabel = UILabel()
//    let weeklyReportPushTitle: UILabel = UILabel()
    
    let achievingGoalsTitle: UILabel = UILabel()
    let achievingGoalsEmailEnabledView: NotificationButtonView = NotificationButtonView()
    let achievingGoalsEmailDisabledView: NotificationButtonView = NotificationButtonView()
    
//    let achievngGoalsEmailTitle: UILabel = UILabel()
    
    var weeklyReportStack: UIStackView = UIStackView()
    var achievingGoalsStack: UIStackView = UIStackView()
    
    //MARK: - Metrics
    
    let settingsModuleWidth: CGFloat = UIScreen.main.bounds.width / 1.05
    let selectorStackSide: CGFloat = 42
    let stackSpacing: CGFloat = 4
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViews()
        setConstraints()
        
        setWeeklyReportButtons()
        getWeeklyReportStates()
        
        setAchievingGoalsButtons()
        getAchievingGoalsStates()
        
    }
    
    
    //MARK: - SetViews
    
    private func setViews() {

//        setTitleSettings(mainTitle, "Notifications", .gray, 21)
//        
        Shaper.shared.drawCenterXSeparator(shape: mainSeparator,
                                                     view: self,
                                                     xMove: -30,
                                                     xAdd: 30,
                                                     y: 27,
                                                     lineWidth: 1,
                                                     color: .lightGray)
        
        
        setTitleSettings(weeklyReportTitle, "Weekly report", .gray, 16)
        weeklyReportStack  = UIStackView(arrangedSubviews:
                                           [weeklyReportEmailEnabledView,
                                            weeklyReportEmailDisabledView,
                                            weeklyReportPushEnabledView,
                                            weeklyReportPushDisabledView])
        setStackSettings(weeklyReportStack)
        weeklyReportStackWidth = 
        (selectorStackSide * CGFloat(weeklyReportStack.subviews.count)) +
        (stackSpacing * CGFloat(weeklyReportStack.subviews.count) - stackSpacing)
//        setTitleSettings(weeklyReportEmailTitle, "Email", .gray, 16)
//        setTitleSettings(weeklyReportPushTitle, "Push", .gray, 16)
        Shaper.shared.drawCenterYSeparator(shape: weeklyReportStackSeparator,
                                                    view: weeklyReportStack,
                                                    moveX: weeklyReportStackWidth / 2,
                                                    moveY: selectorStackSide / 2 - 10,
                                                    addX: weeklyReportStackWidth / 2,
                                                    addY: selectorStackSide / 2 + 10,
                                                    lineWidth: 0.3,
                                                    color: .white)
        
        
        setTitleSettings(achievingGoalsTitle, "Achieving goals", .gray, 16)
        achievingGoalsStack = UIStackView(arrangedSubviews:
                                            [achievingGoalsEmailEnabledView,
                                             achievingGoalsEmailDisabledView])
        setStackSettings(achievingGoalsStack)
//        setTitleSettings(achievngGoalsEmailTitle, "Email", .gray, 16)
    }
    
    //MARK: - TitleSettingsMethod
    
    private func setTitleSettings(_ title: UILabel,
                                  _ textTitle: String,
                                  _ textColor: UIColor,
                                  _ fontSize: CGFloat) {
        addSubview(title)
        title.text = textTitle
        title.textColor = textColor
        title.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
    }
    
    //MARK: - StackSetttingsMethod
    
    private func setStackSettings(_ stackView: UIStackView) {
        stackView.axis = .horizontal
        stackView.spacing = stackSpacing
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .sunsetSkyColor
        stackView.layer.cornerRadius = selectorStackSide / 2
        stackView.layer.cornerCurve = .continuous
        addSubview(stackView)
    }
    
    //MARK: - WeeklyReportInstance
    
    private func setWeeklyReportButtons() {
        weeklyReportEmailEnabledView.button.addTarget(self,
                                            action: #selector(setWeeklyReportStates),
                                            for: .touchUpInside)
        weeklyReportEmailDisabledView.button.addTarget(self,
                                            action: #selector(setWeeklyReportStates),
                                            for: .touchUpInside)
        weeklyReportPushEnabledView.button.addTarget(self,
                                            action: #selector(setWeeklyReportStates),
                                            for: .touchUpInside)
        weeklyReportPushDisabledView.button.addTarget(self,
                                            action: #selector(setWeeklyReportStates),
                                            for: .touchUpInside)
    }
    
    private func getWeeklyReportStates() {   
        let weeklyReportsEmail = UserDefaultsManager.shared.weeklyReportEmailLoad()
        let weeklyReportsPush = UserDefaultsManager.shared.weeklyReportPushLoad()
        
        if weeklyReportsEmail == true {
            refreshWeeklyReportsEmailStates()
            weeklyReportEmailEnabledView.setActiveState(.weeklyReportEmailEnabled)
        } else {
            refreshWeeklyReportsEmailStates()
            weeklyReportEmailDisabledView.setActiveState(.weeklyReportEmailDisabled)
        }
        
        if weeklyReportsPush == true {
            refreshWeeklyReportsPushStates()
            weeklyReportPushEnabledView.setActiveState(.weeklyReportPushEnabled)
        } else {
            refreshWeeklyReportsPushStates()
            weeklyReportPushDisabledView.setActiveState(.weeklyReportPushDisabled)
        }
        
    }
    
    @objc private func setWeeklyReportStates() {
        if weeklyReportEmailEnabledView.button.isTouchInside {
            refreshWeeklyReportsEmailStates()
            weeklyReportEmailEnabledView.setActiveState(.weeklyReportEmailEnabled)
            UserDefaultsManager.shared.weeklyReportEmailSave(true)
        } else if weeklyReportEmailDisabledView.button.isTouchInside {
            refreshWeeklyReportsEmailStates()
            weeklyReportEmailDisabledView.setActiveState(.weeklyReportEmailDisabled)
            UserDefaultsManager.shared.weeklyReportEmailSave(false)
        } else if weeklyReportPushEnabledView.button.isTouchInside {
            refreshWeeklyReportsPushStates()
            weeklyReportPushEnabledView.setActiveState(.weeklyReportPushEnabled)
            UserDefaultsManager.shared.weeklyReportPushSave(true)
        } else if weeklyReportPushDisabledView.button.isTouchInside {
            refreshWeeklyReportsPushStates()
            weeklyReportPushDisabledView.setActiveState(.weeklyReportPushDisabled)
            UserDefaultsManager.shared.weeklyReportPushSave(false)
        }
    }
    
    private func refreshWeeklyReportsEmailStates() {
        weeklyReportEmailEnabledView.setInactiveState(.weeklyReportEmailEnabled)
        weeklyReportEmailDisabledView.setInactiveState(.weeklyReportEmailDisabled)
    }
    
    private func refreshWeeklyReportsPushStates() {
        weeklyReportPushEnabledView.setInactiveState(.weeklyReportPushEnabled)
        weeklyReportPushDisabledView.setInactiveState(.weeklyReportPushDisabled)
    }
    
    
    //MARK: - AchievingGoalsInstance
    
    private func setAchievingGoalsButtons() {
        achievingGoalsEmailEnabledView.button.addTarget(self,
                                            action: #selector(setAchievingGoalsStates),
                                            for: .touchUpInside)
        achievingGoalsEmailDisabledView.button.addTarget(self,
                                            action: #selector(setAchievingGoalsStates),
                                            for: .touchUpInside)
    }
    private func getAchievingGoalsStates() {
        let value = UserDefaultsManager.shared.achievingGoalsLoad()
        
        if value == true {
            refreshAchievingGoalsStates()
            achievingGoalsEmailEnabledView.setActiveState(.achievingGoalsEmailEnabled)
        } else {
            refreshAchievingGoalsStates()
            achievingGoalsEmailDisabledView.setActiveState(.achievingGoalsEmailDisabled)
        }
    }
    
    @objc private func setAchievingGoalsStates() {
        if achievingGoalsEmailEnabledView.button.isTouchInside {
            refreshAchievingGoalsStates()
            achievingGoalsEmailEnabledView.setActiveState(.achievingGoalsEmailEnabled)
            UserDefaultsManager.shared.acheivingGoalsSave(true)
        } else if achievingGoalsEmailDisabledView.button.isTouchInside {
            refreshAchievingGoalsStates()
            achievingGoalsEmailDisabledView.setActiveState(.achievingGoalsEmailDisabled)
            UserDefaultsManager.shared.acheivingGoalsSave(false)
        }
    }
    
    private func refreshAchievingGoalsStates() {
        achievingGoalsEmailEnabledView.setInactiveState(.achievingGoalsEmailEnabled)
        achievingGoalsEmailDisabledView.setInactiveState(.achievingGoalsEmailDisabled)
    }
    
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
//        mainTitle.translatesAutoresizingMaskIntoConstraints = false
        weeklyReportTitle.translatesAutoresizingMaskIntoConstraints = false
        weeklyReportStack.translatesAutoresizingMaskIntoConstraints = false
//        weeklyReportEmailTitle.translatesAutoresizingMaskIntoConstraints = false
//        weeklyReportPushTitle.translatesAutoresizingMaskIntoConstraints = false
        achievingGoalsTitle.translatesAutoresizingMaskIntoConstraints = false
        achievingGoalsStack.translatesAutoresizingMaskIntoConstraints = false
//        achievngGoalsEmailTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
//            mainTitle.centerXAnchor.constraint(equalTo: centerXAnchor),
//            mainTitle.topAnchor.constraint(equalTo: topAnchor),
            
            
            achievingGoalsStack.widthAnchor.constraint(equalToConstant:
                                            (selectorStackSide *
                                     CGFloat(achievingGoalsStack.subviews.count)) +
                                            (stackSpacing *
                                     CGFloat(achievingGoalsStack.subviews.count)) -
                                             stackSpacing),
            achievingGoalsStack.heightAnchor.constraint(equalToConstant:
                                             selectorStackSide),
            achievingGoalsStack.topAnchor.constraint(equalTo: topAnchor,
                                             constant: 100),
            achievingGoalsStack.centerXAnchor.constraint(equalTo:
                                             centerXAnchor),
            
            achievingGoalsTitle.centerXAnchor.constraint(equalTo:
                                             achievingGoalsStack.centerXAnchor),
            achievingGoalsTitle.bottomAnchor.constraint(equalTo:
                                             achievingGoalsStack.topAnchor,
                                             constant: -stackSpacing),
            
//            achievngGoalsEmailTitle.centerYAnchor.constraint(equalTo:
//                                             achievingGoalsStack.centerYAnchor),
//            achievngGoalsEmailTitle.trailingAnchor.constraint(equalTo:
//                                             achievingGoalsStack.leadingAnchor,
//                                             constant: -stackSpacing),
            
            
            
            weeklyReportStack.widthAnchor.constraint(equalToConstant:
                                             weeklyReportStackWidth),
            weeklyReportStack.heightAnchor.constraint(equalToConstant:
                                             selectorStackSide),
            weeklyReportStack.centerXAnchor.constraint(equalTo:
                                             centerXAnchor),
            weeklyReportStack.topAnchor.constraint(equalTo:
                                                    achievingGoalsStack.bottomAnchor,
                                             constant: 50),
            
            weeklyReportTitle.centerXAnchor.constraint(equalTo:
                                             weeklyReportStack.centerXAnchor),
            weeklyReportTitle.bottomAnchor.constraint(equalTo:
                                             weeklyReportStack.topAnchor,
                                             constant: -stackSpacing),
//            
//            weeklyReportEmailTitle.centerYAnchor.constraint(equalTo:
//                                             weeklyReportStack.centerYAnchor),
//            weeklyReportEmailTitle.trailingAnchor.constraint(equalTo:
//                                             weeklyReportStack.leadingAnchor,
//                                             constant: -stackSpacing),
//            
//            weeklyReportPushTitle.centerYAnchor.constraint(equalTo:
//                                             weeklyReportStack.centerYAnchor),
//            weeklyReportPushTitle.leadingAnchor.constraint(equalTo:
//                                             weeklyReportStack.trailingAnchor,
//                                             constant: stackSpacing),
            
            
           
        ])
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
