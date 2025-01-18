//
//  AlertFooter.swift
//  OneDot
//
//  Created by Александр Коробицын on 17.01.2025.
//

import Foundation
import UIKit

class AlertFooter: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.numberOfLines = 3
        label.instance(color: .white, alignment: .center, font: .standartMid)
        label.text = "Finish the workout?"
        return label
    }()
    
    private let leftButton: UIButton = {
        let button = UIButton()
        button.disableAutoresizingMask()
        button.setImage(UIImage(named: "FooterCheckmarkGreen"), for: .normal)
        return button
    }()
    
    private let rightButton: UIButton = {
        let button = UIButton()
        button.disableAutoresizingMask()
        button.setImage(UIImage(named: "FooterCancelGray"), for: .normal)
        return button
    }()
    
    var onOkTapped: (() -> Void)?
    var onCancelTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func okTapped() {
        onOkTapped?()
    }
    
    @objc private func cancelTapped() {
        onCancelTapped?()
    }
    
    //MARK: - SetViews
    
    private func setViews() {
//        effect = UIBlurEffect(style: .extraLight)
        clipsToBounds = true
        layer.instance(border: false, corner: .max)
        backgroundColor = .myPaletteBlue
        
        addSubview(titleLabel)
        addSubview(leftButton)
        addSubview(rightButton)
        
        leftButton.addTarget(self, action: #selector(okTapped), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalToConstant: .barWidth),
            titleLabel.heightAnchor.constraint(equalToConstant: .bottomBarHeight),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            
            leftButton.widthAnchor.constraint(equalToConstant: .barWidth / 2),
            leftButton.heightAnchor.constraint(equalToConstant: .bottomBarHeight),
            leftButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            leftButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            rightButton.widthAnchor.constraint(equalToConstant: .barWidth / 2),
            rightButton.heightAnchor.constraint(equalToConstant: .bottomBarHeight),
            rightButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            rightButton.bottomAnchor.constraint(equalTo: bottomAnchor)
            
        ])
    }

}
