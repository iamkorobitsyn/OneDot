//
//  ScreenshotBottomBar.swift
//  OneDot
//
//  Created by Александр Коробицын on 12.12.2024.
//

import Foundation
import UIKit

class ScreenshotBottonBar: UIVisualEffectView {
    
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
    
    let separator: CAShapeLayer = CAShapeLayer()
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        setViews()
        setConstraints()
    }
    
    @objc private func buttonTapped(_ button: UIButton) {
        switch button {
        case screenShotButton:
            print("screenshot")
        case settingsButton:
            print("settings")
        default:
            break
        }
    }
    
    private func setViews() {
        effect = UIBlurEffect(style: .light)
        clipsToBounds = true
        layer.cornerRadius = .barCorner
        layer.cornerCurve = .continuous
        layer.borderWidth = 0.3
        layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        
        [screenShotButton, settingsButton].forEach { button in
            contentView.addSubview(button)
            button.addTarget(self, action: #selector(buttonTapped(_: )), for: .touchUpInside)
        }
        
        ShapeManager.shared.drawTabBarButtonsLineSeparator(shape: separator, view: self, color: .myPaletteGray)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            screenShotButton.widthAnchor.constraint(equalToConstant: .barWidth / 2),
            screenShotButton.heightAnchor.constraint(equalToConstant: .tabBarHeight),
            screenShotButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            screenShotButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            settingsButton.widthAnchor.constraint(equalToConstant: .barWidth / 2),
            settingsButton.heightAnchor.constraint(equalToConstant: .tabBarHeight),
            settingsButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            settingsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
