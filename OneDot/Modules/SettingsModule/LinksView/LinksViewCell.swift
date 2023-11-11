//
//  LinksViewCell.swift
//  OneDot
//
//  Created by Александр Коробицын on 14.10.2023.
//

import Foundation
import UIKit

class LinksViewCell: SettingsBaseViewCell {

    let mainSeparator: CAShapeLayer = CAShapeLayer()
    let separator: CAShapeLayer = CAShapeLayer()
    
    let instagramButton: UIButton = UIButton()
    let postButton: UIButton = UIButton()
    
    var linksStack: UIStackView = UIStackView()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViews()
        setConstraints()
    }
    
    private func setViews() {
        Shaper.shared.drawCenterXSeparator(shape: mainSeparator,
                                                     view: self,
                                                     xMove: -30,
                                                     xAdd: 30,
                                                     y: 0,
                                                     lineWidth: 1,
                                                     color: .lightGray)
        
        
        instagramButton.setBackgroundImage(UIImage(named: "instagramImage"),
                                           for: .normal)
        instagramButton.setBackgroundImage(UIImage(named: "instagramImage"), 
                                           for: .highlighted)
        postButton.setBackgroundImage(UIImage(named: "postImage"), 
                                      for: .normal)
        postButton.setBackgroundImage(UIImage(named: "postImage"), 
                                      for: .highlighted)
        linksStack = UIStackView(arrangedSubviews: [instagramButton,
                                                   postButton])
        linksStack.axis = .horizontal
        linksStack.spacing = 20
        linksStack.distribution = .fillEqually
        addSubview(linksStack)
        
        Shaper.shared.drawCenterYSeparator(shape: separator, view: linksStack, 
                                                    moveX: 70,
                                                    moveY: 20,
                                                    addX: 70,
                                                    addY: 40,
                                                    lineWidth: 0.5,
                                                    color: .lightGray)
    }
    
    private func setConstraints() {
        linksStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            linksStack.heightAnchor.constraint(equalToConstant: 60),
            linksStack.widthAnchor.constraint(equalToConstant: 140),
            linksStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            linksStack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
   
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

