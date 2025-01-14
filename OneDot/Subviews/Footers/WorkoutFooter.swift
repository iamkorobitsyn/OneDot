//
//  TrackerButton.swift
//  OneDot
//
//  Created by Александр Коробицын on 10.07.2023.
//

import UIKit

class WorkoutFooter: UIView {
    
    var dashboardVCButtonStateHandler: ((DashboardVC.Mode)->())?
    var workoutModeVCButtonStateHandler: ((WorkoutModeVC.Mode) -> ())?
    
    
    enum Mode {
        case ready
        case prepare
        case start
        case hide
    }
    
    var currentMode: Mode = .ready
    
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
        
        switch currentMode {
        case .ready:
            dashboardVCButtonStateHandler?(.transitionToWorkoutMode)
        case .prepare:
            activateMode(mode: .start)
        case .start:
            activateMode(mode: .prepare)
        default:
            break
        }
    }
    
    @objc private func rightTapped() {
        
        switch currentMode {
        case .ready:
            dashboardVCButtonStateHandler?(.transitionToProfile)
        case .prepare:
            workoutModeVCButtonStateHandler?(.hide)
        case .start:
            workoutModeVCButtonStateHandler?(.hide)
        default:
            break
        }
    }
    
    //MARK: - ActivateMode
    
    func activateMode(mode: Mode) {
        currentMode = mode
        switch mode {
            
        case .ready:
            setButtonImages(lButtonImg: "FooterStart", rButtonImg: "FooterList")
        case .prepare:
            setButtonImages(lButtonImg: "FooterStart", rButtonImg: "FooterCancel")
            AnimationManager.shared.AnimateStartIcon(leftButton.layer)
        case .start:
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
        backgroundColor = .myPaletteBlue
        
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

