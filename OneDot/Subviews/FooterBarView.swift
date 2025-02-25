//
//  TrackerButton.swift
//  OneDot
//
//  Created by Александр Коробицын on 10.07.2023.
//

import UIKit

class FooterBarView: UIView {
    
    let hapticGenerator = UISelectionFeedbackGenerator()
    
    var dashboardVCButtonStateHandler: ((DashboardVC.Mode)->())?
    var workoutVCButtonStateHandler: ((WorkoutVC.Mode) -> ())?
    
    
    enum Mode {
        case dashboard
        case prepare
        case start
        case pause
        case hide
        case completion
    }
    
    var currentMode: Mode = .dashboard
    
    private let leftButton: UIButton = UIButton()
    private let rightButton: UIButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setViews()
        setConstraints()
    }
    
    //MARK: - ActivateMode
    
    func activateMode(mode: Mode) {
       
        self.isHidden = false
        currentMode = mode
        switch mode {
        case .dashboard:
            setButtonImages(lButtonImg: "FooterStart", rButtonImg: "FooterList")
        case .prepare:
            setButtonImages(lButtonImg: "FooterStart", rButtonImg: "FooterCancel")
            GraphicsService.shared.AnimateStartIcon(leftButton.layer)
        case .pause:
            setButtonImages(lButtonImg: "FooterStart", rButtonImg: "FooterStop")
            GraphicsService.shared.AnimateStartIcon(leftButton.layer)
        case .start:
            setButtonImages(lButtonImg: "FooterPause", rButtonImg: "FooterStop")
            leftButton.layer.removeAllAnimations()
        case .hide:
            self.isHidden = true
        case .completion:
            setButtonImages(lButtonImg: "FooterCheckmark", rButtonImg: "FooterBack")
            GraphicsService.shared.AnimateStartIcon(leftButton.layer)
            
        }
    }
    
    //MARK: - MainVCHandlers
    
    @objc private func leftTapped() {
        hapticGenerator.selectionChanged()
        switch currentMode {
        case .dashboard:
            dashboardVCButtonStateHandler?(.transitionToWorkoutMode)
        case .prepare:
            currentMode = .start
            workoutVCButtonStateHandler?(.countdown)
        case .start:
            currentMode = .pause
            workoutVCButtonStateHandler?(.pause)
        case .pause:
            currentMode = .start
            workoutVCButtonStateHandler?(.start)
        case .completion:
            workoutVCButtonStateHandler?(.saving)
        default:
            break
        }
    }
    
    @objc private func rightTapped() {
        hapticGenerator.selectionChanged()
        switch currentMode {
        case .dashboard:
            dashboardVCButtonStateHandler?(.transitionToProfile)
        case .prepare:
            workoutVCButtonStateHandler?(.hide)
        case .start, .pause:
            workoutVCButtonStateHandler?(.completion)
        case .completion:
            workoutVCButtonStateHandler?(.start)
        default:
            break
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

