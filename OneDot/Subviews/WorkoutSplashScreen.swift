//
//  WorkoutSplashScreen.swift
//  OneDot
//
//  Created by Александр Коробицын on 12.01.2025.
//

import Foundation
import UIKit

class WorkoutSplashScreen: UIView {
    
    enum Mode {
        case prepareToStart
        case countdownStart
        case hide
    }
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.instance(color: .white, alignment: .center, font: .standartMid)
        label.text = "Get ready to start and click on the indicator, good luck in training and competitions"
        label.numberOfLines = 5
        return label
    }()
    
    private let countDownLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .myPaletteBlue
        addSubview(textLabel)
        
        setConstraints()
        
        self.isHidden = true
    }
    
    func activateMode(mode: Mode) {
        switch mode {
            
        case .prepareToStart:
            self.isHidden = false
        case .countdownStart:
            self.isHidden = false
        case .hide:
            self.isHidden = true
        }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            textLabel.widthAnchor.constraint(equalToConstant: .barWidth - 100),
            textLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
