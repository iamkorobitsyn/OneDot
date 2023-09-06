//
//  TrackerButton.swift
//  OneDot
//
//  Created by Александр Коробицын on 10.07.2023.
//

import UIKit

class TrackerButton: UIButton {
    
    let buttonDiameter: CGFloat = 70
    
    private let dot = UIView()
    private let dotDiameter: CGFloat = 10

    enum State {
        case pressed, free
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(dot)
        setView()
    }
    
    private func setView() {
        layer.cornerRadius = buttonDiameter / 2
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.customBlueLight.cgColor
        
        dot.layer.cornerRadius = dotDiameter / 2
        dot.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dot.widthAnchor.constraint(equalToConstant: dotDiameter),
            dot.heightAnchor.constraint(equalToConstant: dotDiameter),
            dot.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            dot.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func setState(_ state: State) {
        switch state {
        case .pressed:
            backgroundColor = UIColor.customBlueLight
            dot.backgroundColor = UIColor.customBlueDeep
           
        case .free:
            backgroundColor = UIColor.customBlueDeep
            dot.backgroundColor = UIColor.customBlueLight
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
