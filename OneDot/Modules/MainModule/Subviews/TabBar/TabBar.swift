//
//  TrackerButton.swift
//  OneDot
//
//  Created by Александр Коробицын on 10.07.2023.
//

import UIKit

class TabBar: UIView {
    
    private let feedbackGen = UISelectionFeedbackGenerator()
    
    private let leftButton: UIButton = UIButton()
    private let rightButton: UIButton = UIButton()
    private let separator: CAShapeLayer = CAShapeLayer()
    
    private enum TabBarStatus {
        case prepare
        case prepareToStart
        case tracking
    }
    
    private var currentStatus: TabBarStatus = .prepare

    var showProfile: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setViews()
        setConstraints()
    
    }
    
    //MARK: - ButtonMethods
    
    @objc private func leftTapped() {
        feedbackGen.selectionChanged()
        
        switch currentStatus {
        case .prepare:
            currentStatus = .prepareToStart
            updateButtonImages(status: .prepareToStart)
            Animator.shared.AnimateStartIcon(leftButton.layer)
        case .prepareToStart:
            currentStatus = .tracking
            updateButtonImages(status: .tracking)
            leftButton.layer.removeAllAnimations()
        case .tracking:
            currentStatus = .prepareToStart
            updateButtonImages(status: .prepareToStart)
            Animator.shared.AnimateStartIcon(leftButton.layer)
        }
    }
    
    @objc private func rightTapped() {
        feedbackGen.selectionChanged()
        
        switch currentStatus {
        case .prepare:
            showProfile?()
        case .prepareToStart, .tracking:
            currentStatus = .prepare
            updateButtonImages(status: .prepare)
            leftButton.layer.removeAllAnimations()
        }
    }
    
    private func updateButtonImages(status: TabBarStatus) {
        switch status {
            
        case .prepare:
            leftButton.setImage(UIImage(named: "TBStart"), for: .normal)
            leftButton.setImage(UIImage(named: "TBStart"), for: .highlighted)
            rightButton.setImage(UIImage(named: "TBProfile"), for: .normal)
            rightButton.setImage(UIImage(named: "TBProfile"), for: .highlighted)
        case .prepareToStart:
            leftButton.setImage(UIImage(named: "TBStart"), for: .normal)
            leftButton.setImage(UIImage(named: "TBStart"), for: .highlighted)
            rightButton.setImage(UIImage(named: "TBCancel"), for: .normal)
            rightButton.setImage(UIImage(named: "TBCancel"), for: .highlighted)
        case .tracking:
            leftButton.setImage(UIImage(named: "TBPause"), for: .normal)
            leftButton.setImage(UIImage(named: "TBPause"), for: .highlighted)
            rightButton.setImage(UIImage(named: "TBStop"), for: .normal)
            rightButton.setImage(UIImage(named: "TBStop"), for: .highlighted)
        }
    }
    
    
    //MARK: - SetViews
    
    private func setViews() {
        backgroundColor = .myPaletteBlue
        layer.cornerRadius = .barCorner
        layer.cornerCurve = .continuous
        
        addSubview(leftButton)
        addSubview(rightButton)
        
        updateButtonImages(status: .prepare)
        
        leftButton.addTarget(self, action: #selector(leftTapped), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightTapped), for: .touchUpInside)
        
        Shaper.shared.drawTabBarSeparator(shape: separator, view: self)
    }
    
    
    //MARK: - SetConstrains

    private func setConstraints() {
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leftButton.widthAnchor.constraint(equalToConstant: .barWidth / 2),
            leftButton.heightAnchor.constraint(equalToConstant: .tabBarHeight),
            leftButton.leftAnchor.constraint(equalTo: leftAnchor),
            leftButton.topAnchor.constraint(equalTo: topAnchor),
            
            rightButton.widthAnchor.constraint(equalToConstant: .barWidth / 2),
            rightButton.heightAnchor.constraint(equalToConstant: .tabBarHeight),
            rightButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            rightButton.topAnchor.constraint(equalTo: topAnchor),
            ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
