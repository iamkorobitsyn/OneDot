//
//  NotificationsSettingsView.swift
//  OneDot
//
//  Created by Александр Коробицын on 10.10.2023.
//

import Foundation
import UIKit

class NotificationsViewCell: UITableViewCell {
    
    private var weeklyReportStackWidth = CGFloat()

    private let mainSeparator: CAShapeLayer = CAShapeLayer()
    private let weeklyReportStackSeparator: CAShapeLayer = CAShapeLayer()
    
    //MARK: - Buttons
    
    let weeklyReportTitle: UILabel = UILabel()
    let weeklyReportEmailEnabledView: NotificationButtonView = NotificationButtonView()
    let weeklyReportEmailDisabledView: NotificationButtonView = NotificationButtonView()
    
    let weeklyReportPushEnabledView: NotificationButtonView = NotificationButtonView()
    let weeklyReportPushDisabledView: NotificationButtonView = NotificationButtonView()
    
    let achievingGoalsTitle: UILabel = UILabel()
    let achievingGoalsEmailEnabledView: NotificationButtonView = NotificationButtonView()
    let achievingGoalsEmailDisabledView: NotificationButtonView = NotificationButtonView()

    var weeklyReportStack: UIStackView = UIStackView()
    var achievingGoalsStack: UIStackView = UIStackView()
    
    private let separatorLine: CAShapeLayer = CAShapeLayer()
    
    //MARK: - Metrics
    
    let heightForRow: CGFloat = 250
    
    let settingsModuleWidth: CGFloat = UIScreen.main.bounds.width / 1.05
    let selectorStackSide: CGFloat = 42
    let stackSpacing: CGFloat = 4
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
        setViews()
        setConstraints()
        
        setWeeklyReportButtons()
        getWeeklyReportStates()
        
        setAchievingGoalsButtons()
        getAchievingGoalsStates()
        
        
        Shaper.shared.drawXSeparator(shape: separatorLine,
                                     view: self,
                                     x: 100,
                                     y: heightForRow,
                                     length:
                                     UIScreen.main.bounds.width - 200,
                                     color: .lightGray)
    }
    
    //MARK: UpdateColors
    
    func updateColors(_ set: ColorSetProtocol) {
        weeklyReportStack.backgroundColor = set.mainSelectorColor
        achievingGoalsStack.backgroundColor = set.mainSelectorColor
    }
    
    
    //MARK: - SetViews
    
    private func setViews() {
        
        setTitleSettings(weeklyReportTitle, "Weekly report", .gray, 14)
        weeklyReportStack  = UIStackView(arrangedSubviews:
                                           [weeklyReportEmailEnabledView,
                                            weeklyReportEmailDisabledView,
                                            weeklyReportPushEnabledView,
                                            weeklyReportPushDisabledView])
        setStackSettings(weeklyReportStack)
        weeklyReportStackWidth = 
        (selectorStackSide * CGFloat(weeklyReportStack.subviews.count)) +
        (stackSpacing * CGFloat(weeklyReportStack.subviews.count) - stackSpacing)

        
        setTitleSettings(achievingGoalsTitle, "Achieving goals", .gray, 14)
        achievingGoalsStack = UIStackView(arrangedSubviews:
                                            [achievingGoalsEmailEnabledView,
                                             achievingGoalsEmailDisabledView])
        setStackSettings(achievingGoalsStack)
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
        stackView.backgroundColor = .currentColorSet.mainSelectorColor
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
        weeklyReportTitle.translatesAutoresizingMaskIntoConstraints = false
        weeklyReportStack.translatesAutoresizingMaskIntoConstraints = false
        achievingGoalsTitle.translatesAutoresizingMaskIntoConstraints = false
        achievingGoalsStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            achievingGoalsStack.widthAnchor.constraint(equalToConstant:
                                            (selectorStackSide *
                                     CGFloat(achievingGoalsStack.subviews.count)) +
                                            (stackSpacing *
                                     CGFloat(achievingGoalsStack.subviews.count)) -
                                             stackSpacing),
            achievingGoalsStack.heightAnchor.constraint(equalToConstant:
                                             selectorStackSide),
            achievingGoalsStack.topAnchor.constraint(equalTo: topAnchor,
                                             constant: 40),
            achievingGoalsStack.centerXAnchor.constraint(equalTo:
                                             centerXAnchor),
            
            achievingGoalsTitle.centerXAnchor.constraint(equalTo:
                                             achievingGoalsStack.centerXAnchor),
            achievingGoalsTitle.topAnchor.constraint(equalTo:
                                             achievingGoalsStack.bottomAnchor,
                                             constant: 10),

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
            weeklyReportTitle.topAnchor.constraint(equalTo:
                                             weeklyReportStack.bottomAnchor,
                                             constant: 10)
           
        ])
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
