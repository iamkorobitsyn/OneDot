//
//  TrackerButton.swift
//  OneDot
//
//  Created by Александр Коробицын on 10.07.2023.
//

import UIKit

class TabBar: UIView {
    
    let feedbackGen = UISelectionFeedbackGenerator()
    
    enum TabBarStatus {
        case prepare
        case prepareToStart
        case tracking
    }
    
    var currentStatus: TabBarStatus = .prepare

    
    let leftButton: UIButton = UIButton()
    let rightButton: UIButton = UIButton()
    
    private let separator: CAShapeLayer = CAShapeLayer()
    
    var profileCompletion: (() -> Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setConstraints()
        
        Shaper.shared.drawYSeparator(shape: separator,
                                             view: self,
                                             x: CGFloat.trackerBarWidth / 2,
                                             y: 15,
                                             length: 65,
                                             color: .white)
    }
    
    @objc private func leftTapped() {
        feedbackGen.selectionChanged()
        
        switch currentStatus {
        case .prepare:
            currentStatus = .prepareToStart
            setImageList("tabBarStartIconRed", "tabBarCancelIcon")
        case .prepareToStart:
            currentStatus = .tracking
            setImageList("tabBarPauseIcon", "tabBarStopIcon")
        case .tracking:
            currentStatus = .prepareToStart
            setImageList("tabBarStartIconRed", "tabBarCancelIcon")
        }
    }
    
    @objc private func rightTapped() {
        feedbackGen.selectionChanged()
        
        switch currentStatus {
        case .prepare:
            profileCompletion?()
        case .prepareToStart, .tracking:
            currentStatus = .prepare
            setImageList("tabBarStartIcon", "tabBarProfileIcon")
        }
    }
    
    
    private func setImageList(_ leftImageNamed: String, _ rightImageNamed: String) {
        leftButton.setImage(UIImage(named: leftImageNamed), for: .normal)
        leftButton.setImage(UIImage(named: leftImageNamed), for: .highlighted)
        rightButton.setImage(UIImage(named: rightImageNamed), for: .normal)
        rightButton.setImage(UIImage(named: rightImageNamed), for: .highlighted)
    }
    
    
    //MARK: - SetViews
    
    private func setViews() {
        backgroundColor = .myPaletteBlue
        layer.cornerRadius = .tabBarCorner
        layer.cornerCurve = .continuous
        
        addSubview(leftButton)
        addSubview(rightButton)
        
        setImageList("tabBarStartIcon", "tabBarProfileIcon")
        
        leftButton.addTarget(self, action: #selector(leftTapped), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightTapped), for: .touchUpInside)
    }
    
    
    //MARK: - SetConstrains

    private func setConstraints() {
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leftButton.widthAnchor.constraint(equalToConstant: .tabBarWidth / 2),
            leftButton.heightAnchor.constraint(equalToConstant: .tabBarHeight),
            leftButton.leftAnchor.constraint(equalTo: leftAnchor),
            leftButton.topAnchor.constraint(equalTo: topAnchor),
            
            rightButton.widthAnchor.constraint(equalToConstant: .tabBarWidth / 2),
            rightButton.heightAnchor.constraint(equalToConstant: .tabBarHeight),
            rightButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            rightButton.topAnchor.constraint(equalTo: topAnchor),
            ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
