//
//  MainBarBodyBaseTest.swift
//  OneDot
//
//  Created by Александр Коробицын on 03.11.2023.
//

import Foundation
import UIKit

class MainBarBodyBase: UIVisualEffectView, CAAnimationDelegate {
    
    private let collapseButton: UIButton = UIButton()
    
    private let title: UILabel = UILabel()
    
    private let separator: CAShapeLayer = CAShapeLayer()
    
    private let distancePaceButton: MainBarBodyButton = MainBarBodyButton()
    private let speedPaceButton: MainBarBodyButton = MainBarBodyButton()
    private let heartZonesButton: MainBarBodyButton = MainBarBodyButton()
    
    private let appleMusicButton: MainBarBodyButton = MainBarBodyButton()
    private let metronomeButton: MainBarBodyButton = MainBarBodyButton()
    
    private let storiesButton: MainBarBodyButton = MainBarBodyButton()
    private let widgetsButton: MainBarBodyButton = MainBarBodyButton()
    private let colorThemesButton: MainBarBodyButton = MainBarBodyButton()
    
    var calculatorButtonsList: [MainBarBodyButton] = [MainBarBodyButton]()
    var soundButtonsList: [MainBarBodyButton] = [MainBarBodyButton]()
    var themesButtonsList: [MainBarBodyButton] = [MainBarBodyButton]()
    
    var calculatorStack: UIStackView = UIStackView()
    var soundStack: UIStackView = UIStackView()
    var themesStack: UIStackView = UIStackView()
    
    private let distancePaceView: MainBarDistancePaceView = MainBarDistancePaceView()
    private let speedPaceView: MainBarSpeedPaceView = MainBarSpeedPaceView()
    private let heartZonesView: MainBarHeartZonesView = MainBarHeartZonesView()
    
    private let appleMusicView: MainBarAppleMusicView = MainBarAppleMusicView()
    private let metronomeView: MainBarMetronomeView = MainBarMetronomeView()
    
    private let storiesView: MainBarStoriesView = MainBarStoriesView()
    private let widgetsView: MainBarWidgetsView = MainBarWidgetsView()
    let colorThemesView: MainBarColorThemesView = MainBarColorThemesView()
    
    var calculatorViewsList: [UIView] = [UIView]()
    var soundViewsList: [UIView] = [UIView]()
    var themesViewsList: [UIView] = [UIView]()
    
    var completion: (() -> ())?
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        
        
        setViews()
        setButtons()
        setConstraints()

        setStatesFor(calculatorStack, nil)
        setStatesFor(soundStack, nil)
        setStatesFor(themesStack, nil)
        title.text = "Distance / Pace"
    }
    
    @objc func selfHide() {
        completion?()
        Animator.shared.MainBarBodyHide(self, self)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.isHidden = true
    }
  
    
    //MARK: - SetButtons
    
    
    func setStatesFor(_ stack: UIStackView, _ i: Int?) {
        guard let i = i else {return}
        hideViews()
        if stack == calculatorStack {
            calculatorStack.isHidden = false
            soundStack.isHidden = true
            themesStack.isHidden = true
            distancePaceButton.setInactiveState(.distancePace)
            speedPaceButton.setInactiveState(.speedPace)
            heartZonesButton.setInactiveState(.pulseZones)
            title.text = calculatorButtonsList[i].getCalculatorActive(i)
            calculatorViewsList[i].isHidden = false
        } else if stack == soundStack {
            soundStack.isHidden = false
            themesStack.isHidden = true
            calculatorStack.isHidden = true
            appleMusicButton.setInactiveState(.appleMusic)
            metronomeButton.setInactiveState(.metronome)
            title.text = soundButtonsList[i].getSoundActive(i)
            soundViewsList[i].isHidden = false
        } else if stack == themesStack {
            themesStack.isHidden = false
            calculatorStack.isHidden = true
            soundStack.isHidden = true
            storiesButton.setInactiveState(.stories)
            widgetsButton.setInactiveState(.widjets)
            colorThemesButton.setInactiveState(.colorThemes)
            title.text = themesButtonsList[i].getThemesActive(i)
            themesViewsList[i].isHidden = false
        }
    }
    
    private func setButtons() {
        distancePaceButton.addTarget(self, action: #selector(buttonTapt),
                                     for: .touchUpInside)
        speedPaceButton.addTarget(self, action: #selector(buttonTapt),
                                  for: .touchUpInside)
        heartZonesButton.addTarget(self, action: #selector(buttonTapt),
                                   for: .touchUpInside)
        
        appleMusicButton.addTarget(self, action: #selector(buttonTapt),
                                   for: .touchUpInside)
        metronomeButton.addTarget(self, action: #selector(buttonTapt),
                                  for: .touchUpInside)
        
        storiesButton.addTarget(self, action: #selector(buttonTapt),
                                for: .touchUpInside)
        widgetsButton.addTarget(self, action: #selector(buttonTapt),
                                for: .touchUpInside)
        colorThemesButton.addTarget(self, action: #selector(buttonTapt), 
                                    for: .touchUpInside)
    }
    
    @objc private func buttonTapt() {
        for i in 0..<calculatorButtonsList.count {
            if calculatorButtonsList[i].isTouchInside {
                setStatesFor(calculatorStack, i)
                UserDefaultsManager.shared.calculatorViewSave(i)
            }
        }
        
        for i in 0..<soundButtonsList.count {
            if soundButtonsList[i].isTouchInside {
                setStatesFor(soundStack, i)
                UserDefaultsManager.shared.soundViewSave(i)
            }
        }

        for i in 0..<themesButtonsList.count {
            if themesButtonsList[i].isTouchInside {
                setStatesFor(themesStack, i)
                UserDefaultsManager.shared.themesViewSave(i)
            }
        }
    }
    
    //MARK: - SetView
    
    private func setViews() {
        isHidden = true
        layer.borderWidth = 0.3
        layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        effect = UIBlurEffect(style: UIBlurEffect.Style.light)
        clipsToBounds = true
        layer.cornerRadius = 30
        layer.cornerCurve = .continuous
        translatesAutoresizingMaskIntoConstraints = false
        
        calculatorViewsList.append(contentsOf: [distancePaceView,
                                                speedPaceView,
                                                heartZonesView])
        contentView.addSubview(distancePaceView)
        contentView.addSubview(speedPaceView)
        contentView.addSubview(heartZonesView)
        
        soundViewsList.append(contentsOf: [appleMusicView,
                                          metronomeView])
        contentView.addSubview(appleMusicView)
        contentView.addSubview(metronomeView)
        
        themesViewsList.append(contentsOf: [storiesView,
                                            widgetsView,
                                            colorThemesView])
        contentView.addSubview(storiesView)
        contentView.addSubview(widgetsView)
        contentView.addSubview(colorThemesView)
        
        
        contentView.addSubview(collapseButton)
        collapseButton.backgroundColor = .clear
        collapseButton.setBackgroundImage(UIImage(named: "hideUpShevronIconGray"), for: .normal)
        collapseButton.setBackgroundImage(UIImage(named: "hideUpShevronIconGray"), for: .highlighted)
        collapseButton.layer.borderWidth = 1
        collapseButton.layer.borderColor = UIColor.gray.cgColor
        collapseButton.layer.cornerRadius = 21
        collapseButton.addTarget(self, action: #selector(selfHide), for: .touchUpInside)
        
        calculatorButtonsList.append(contentsOf: [distancePaceButton, 
                                               speedPaceButton,
                                               heartZonesButton])
        calculatorStack = UIStackView(arrangedSubviews: calculatorButtonsList)
        calculatorStack.axis = .horizontal
        calculatorStack.spacing = CGFloat.stackSpacing
        calculatorStack.distribution = .fillEqually
        calculatorStack.layer.cornerRadius = CGFloat.stackCorner
        contentView.addSubview(calculatorStack)
        
        soundButtonsList.append(contentsOf: [appleMusicButton, 
                                          metronomeButton])
        soundStack = UIStackView(arrangedSubviews: soundButtonsList)
        soundStack.axis = .horizontal
        soundStack.spacing = CGFloat.stackSpacing
        soundStack.distribution = .fillEqually
        soundStack.layer.cornerRadius = CGFloat.stackCorner
        contentView.addSubview(soundStack)
        
        themesButtonsList.append(contentsOf: [storiesButton,
                              widgetsButton,
                              colorThemesButton])
        themesStack = UIStackView(arrangedSubviews: themesButtonsList)
        themesStack.axis = .horizontal
        themesStack.spacing = CGFloat.stackSpacing
        themesStack.distribution = .fillEqually
        themesStack.layer.cornerRadius = CGFloat.stackCorner
        contentView.addSubview(themesStack)
        
        contentView.addSubview(title)
        title.textColor = .gray
        title.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
    }
    
    private func hideViews() {
        distancePaceView.isHidden = true
        speedPaceView.isHidden = true
        heartZonesView.isHidden = true
        appleMusicView.isHidden = true
        metronomeView.isHidden = true
        storiesView.isHidden = true
        widgetsView.isHidden = true
        colorThemesView.isHidden = true
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        collapseButton.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collapseButton.widthAnchor.constraint(equalToConstant: 42),
            collapseButton.heightAnchor.constraint(equalToConstant: 42),
            collapseButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            collapseButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            title.topAnchor.constraint(equalTo: topAnchor, constant: 67)
        ])
        
        stackViewConstraintBuild(calculatorStack)
        stackViewConstraintBuild(soundStack)
        stackViewConstraintBuild(themesStack)
        
        viewConstraintBuild(distancePaceView)
        viewConstraintBuild(speedPaceView)
        viewConstraintBuild(heartZonesView)
        viewConstraintBuild(appleMusicView)
        viewConstraintBuild(metronomeView)
        viewConstraintBuild(storiesView)
        viewConstraintBuild(widgetsView)
        viewConstraintBuild(colorThemesView)
    }
    
    private func stackViewConstraintBuild(_ stack: UIStackView) {
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.widthAnchor.constraint(equalToConstant:
                                           (CGFloat(stack.subviews.count) *
                                            CGFloat.mainIconSide) +
                                           (CGFloat(stack.subviews.count) *
                                            CGFloat.stackSpacing) -
                                            CGFloat.stackSpacing),
            stack.heightAnchor.constraint(equalToConstant: CGFloat.stackSide),
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 20)
        ])
    }
    
    private func viewConstraintBuild(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
