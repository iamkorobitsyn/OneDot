//
//  TrackerButton.swift
//  OneDot
//
//  Created by Александр Коробицын on 10.07.2023.
//

import UIKit

class WorkoutFooter: UIView {
    
    var buttonStateHandler: ((MainVC.Mode)->())?
    
    enum Mode {
        case prepare
        case prepareToStart
        case tracking
        case hide
    }
    
    private var prepareState: Bool = true
    private var prepareToStartState: Bool = false
    private var trackingState: Bool = false
    
    private let leftButton: UIButton = UIButton()
    private let rightButton: UIButton = UIButton()
    
    private let buttonsLineSeparator: CAShapeLayer = CAShapeLayer()
  

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setViews()
        setConstraints()
    }
    
    //MARK: - MainVCHandlers
    
    @objc private func leftTapped() {
        
        if prepareState {
            prepareState.toggle()
            prepareToStartState.toggle()
            buttonStateHandler?(.prepareToStart)
        } else if prepareToStartState {
            prepareToStartState.toggle()
            trackingState.toggle()
            buttonStateHandler?(.tracking)
        } else if trackingState {
            trackingState.toggle()
            prepareToStartState.toggle()
            buttonStateHandler?(.prepareToStart)
        }
    }
    
    @objc private func rightTapped() {
        
        if prepareState {
            buttonStateHandler?(.transitionToProfile)
        } else if prepareToStartState || trackingState {
            prepareToStartState = false
            trackingState = false
            prepareState = true
            buttonStateHandler?(.prepare)
        }
    }
    
    //MARK: - ActivateMode
    
    func activateMode(mode: Mode) {
        backgroundColor = .myPaletteBlue
        switch mode {
            
        case .prepare:
            self.isHidden = false
            setButtonImages(lButtonImg: "FooterStart", rButtonImg: "FooterProfile")
            leftButton.layer.removeAllAnimations()
            
        case .prepareToStart:
            setButtonImages(lButtonImg: "FooterStart", rButtonImg: "FooterCancel")
            AnimationManager.shared.AnimateStartIcon(leftButton.layer)
            
        case .tracking:
            setButtonImages(lButtonImg: "FooterPause", rButtonImg: "FooterStop")
            leftButton.layer.removeAllAnimations()
            
        case .hide:
            self.isHidden = true
        }
    }
    
    private func setButtonImages(lButtonImg: String, rButtonImg: String) {
        leftButton.setImage(UIImage(named: lButtonImg), for: .normal)
        leftButton.setImage(UIImage(named: lButtonImg), for: .highlighted)
        rightButton.setImage(UIImage(named: rButtonImg), for: .normal)
        rightButton.setImage(UIImage(named: rButtonImg), for: .highlighted)
    }
 
    
    //MARK: - SetViews
    
    private func setViews() {
        activateMode(mode: .prepare)
        
        layer.instance(border: false, corner: .max)
        
        addSubview(leftButton)
        addSubview(rightButton)
        leftButton.addTarget(self, action: #selector(leftTapped), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightTapped), for: .touchUpInside)
        
        ShapeManager.shared.drawTabBarButtonsLineSeparator(shape: buttonsLineSeparator, view: self, color: .white)
    }
    
    
    //MARK: - SetConstrains

    private func setConstraints() {
        leftButton.disableAutoresizingMask()
        rightButton.disableAutoresizingMask()
        
        NSLayoutConstraint.activate([
            leftButton.widthAnchor.constraint(equalToConstant: .barWidth / 2),
            leftButton.heightAnchor.constraint(equalToConstant: .bottomBarHeight),
            leftButton.leftAnchor.constraint(equalTo: leftAnchor),
            leftButton.topAnchor.constraint(equalTo: topAnchor),
            
            rightButton.widthAnchor.constraint(equalToConstant: .barWidth / 2),
            rightButton.heightAnchor.constraint(equalToConstant: .bottomBarHeight),
            rightButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            rightButton.topAnchor.constraint(equalTo: topAnchor)
            ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

