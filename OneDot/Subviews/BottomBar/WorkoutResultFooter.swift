//
//  ScreenshotBottomBar.swift
//  OneDot
//
//  Created by Александр Коробицын on 12.12.2024.
//

import Foundation
import UIKit

class WorkoutResultFooter: UIVisualEffectView {
    
    var buttonStateHandler: ((DetailsVC.Mode) -> Void)?
    
    private let screenShotButton: UIButton = {
        let button = UIButton()
        button.disableAutoresizingMask()
        button.setImage(UIImage(named: "DSScreenshotGray"), for: .normal)
        return button
    }()
    
    private let settingsButton: UIButton = {
        let button = UIButton()
        button.disableAutoresizingMask()
        button.setImage(UIImage(named: "DSWriteGray"), for: .normal)
        return button
    }()
    
    private let shotLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.text = "Screenshot saved in gallery"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22, weight: .light, width: .compressed)
        label.textColor = .myPaletteGray
        return label
    }()
    
    let separator: CAShapeLayer = CAShapeLayer()
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        setViews()
        setConstraints()
        activateHandlers()
    }
    
    private func activateHandlers() {
        ScreenschotHelper.shared.shotStateHandler = { [weak self] shotState in
            guard let self else {return}
            screenShotButton.isHidden = shotState ? true : false
            settingsButton.isHidden = shotState ? true : false
            separator.isHidden = shotState ? true : false
            shotLabel.isHidden = shotState ? false : true
        }
    }
    
    
    
    @objc private func buttonTapped(_ button: UIButton) {
        switch button {
        case screenShotButton:
            buttonStateHandler?(.screenshot)
        case settingsButton:
            buttonStateHandler?(.settings)
        default:
            break
        }
    }
    
    private func setViews() {
        effect = UIBlurEffect(style: .light)
        clipsToBounds = true
        layer.instance(border: true, corner: .max)
        
        [screenShotButton, settingsButton].forEach { button in
            contentView.addSubview(button)
            button.addTarget(self, action: #selector(buttonTapped(_: )), for: .touchUpInside)
        }
        contentView.addSubview(shotLabel)
        shotLabel.isHidden = true
        
        ShapeManager.shared.drawTabBarButtonsLineSeparator(shape: separator, view: self, color: .myPaletteGray)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            screenShotButton.widthAnchor.constraint(equalToConstant: .barWidth / 2),
            screenShotButton.heightAnchor.constraint(equalToConstant: .bottomBarHeight),
            screenShotButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            screenShotButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            settingsButton.widthAnchor.constraint(equalToConstant: .barWidth / 2),
            settingsButton.heightAnchor.constraint(equalToConstant: .bottomBarHeight),
            settingsButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            settingsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            shotLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            shotLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
