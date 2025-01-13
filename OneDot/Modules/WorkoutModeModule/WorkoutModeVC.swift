//
//  WorkoutModeModule.swift
//  OneDot
//
//  Created by Александр Коробицын on 13.01.2025.
//

import Foundation
import UIKit

class WorkoutModeVC: UIViewController {
    
    
    
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
    
    
    override func viewDidLoad() {
        view.backgroundColor = .myPaletteBlue
        view.addSubview(textLabel)
        
        setConstraints()
        
        self.view.isHidden = true
    }
    
    func activateMode(mode: Mode) {
        switch mode {
            
        case .prepareToStart:
            self.view.isHidden = false
        case .countdownStart:
            self.view.isHidden = false
        case .hide:
            self.view.isHidden = true
        }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            textLabel.widthAnchor.constraint(equalToConstant: .barWidth - 100),
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}
