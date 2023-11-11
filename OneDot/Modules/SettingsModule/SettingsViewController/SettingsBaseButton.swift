//
//  SettingsBaseButton.swift
//  OneDot
//
//  Created by Александр Коробицын on 30.10.2023.
//

import Foundation
import UIKit

class SettingsBaseButton: UIView {
    
    let button: UIButton = UIButton()
    
    //MARK: - Metrics

    let mainButtonSide: CGFloat = 38
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .none
        setViews()
        setConstraints()
    }
    
    //MARK: - SetViews
    
    private func setViews() {
        addSubview(button)
        button.layer.cornerRadius = mainButtonSide / 2
    }
    
    
    //MARK: - ButtonSettingsMethod
    
    func setButtonSettings(_ backgroundColor: UIColor,
                                   _ titleColor: UIColor,
                                   _ title: String,
                                   _ titleFontSize: CGFloat) {
        button.backgroundColor = backgroundColor
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: titleFontSize, weight: .medium)
        button.setTitleColor(titleColor, for: .normal)
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: mainButtonSide),
            button.heightAnchor.constraint(equalToConstant: mainButtonSide),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
