//
//  SelectorThemesView.swift
//  OneDot
//
//  Created by Александр Коробицын on 01.11.2023.
//

import Foundation
import UIKit

class MainBarColorThemesView: UIView {
    
    var navigationVCDelegate: NavigationVCColorSetProtocol?
    var mainVCDelegate: MainVCColorSetProtocol?
    let factoryColorSet = FactoryColorSet()
    
    let title: UILabel = UILabel()
    
    let lightTestButton = UIButton()
    let darkTestButton = UIButton()
    let systemTestButton = UIButton()
    
    var selectorList: [UIButton] = [UIButton]()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setViews()
        setConstraints()

    }
    
    //MARK: - SetViews

    private func setViews() {
        addSubview(title)
        title.font = UIFont.systemFont(ofSize: 30, weight: .black)
        title.text = ""
        title.textColor = .lightGray
        
        addSubview(lightTestButton)
        lightTestButton.backgroundColor = .lightGray
        lightTestButton.addTarget(self, action: #selector(buttonPressed),
                                  for: .touchUpInside)
        addSubview(darkTestButton)
        darkTestButton.backgroundColor = .darkGray
        darkTestButton.addTarget(self, action: #selector(buttonPressed),
                                 for: .touchUpInside)
        addSubview(systemTestButton)
        systemTestButton.backgroundColor = .white
        systemTestButton.addTarget(self, action: #selector(buttonPressed),
                                   for: .touchUpInside)
        
        selectorList.append(contentsOf: [systemTestButton,
                                         lightTestButton,
                                         darkTestButton])
        
        registerForTraitChanges([UITraitUserInterfaceStyle.self], 
                                action: #selector(changeUserInterfaceStyle))
    }
    
    //MARK: - ChangeUserInterfaceStyle
    
    @objc private func changeUserInterfaceStyle() {
        if traitCollection.userInterfaceStyle == .dark {
            UIColor.custom = factoryColorSet.get(.sunsetSky)
            navigationVCDelegate?.update(factoryColorSet.get(.sunsetSky), false)
            mainVCDelegate?.update(factoryColorSet.get(.sunsetSky), false)
        } else if traitCollection.userInterfaceStyle == .light {
            UIColor.custom = factoryColorSet.get(.sunsetSky)
            navigationVCDelegate?.update(factoryColorSet.get(.sunsetSky), true)
            mainVCDelegate?.update(factoryColorSet.get(.sunsetSky), true)
        }
    }
    
    //MARK: - ButtonPressed
    
    @objc private func buttonPressed() {
        for i in 0..<selectorList.count {
            if selectorList[i].isTouchInside {
                
                TraitCollectionManager.shared.theme = Theme(rawValue: i) ?? .device
                window?.overrideUserInterfaceStyle =
                TraitCollectionManager.shared.theme.getUserInterfaceStyle()
                
                if i == 1 {
                    UIColor.custom = factoryColorSet.get(.sunsetSky)
                    navigationVCDelegate?.update(factoryColorSet.get(.sunsetSky), true)
                    mainVCDelegate?.update(factoryColorSet.get(.sunsetSky), true)
                }
                
                if i == 2 {
                    UIColor.custom = factoryColorSet.get(.sunsetSky)
                    navigationVCDelegate?.update(factoryColorSet.get(.sunsetSky), false)
                    mainVCDelegate?.update(factoryColorSet.get(.sunsetSky), false)
                }
                
                
            }
        }
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        title.translatesAutoresizingMaskIntoConstraints = false
        
        lightTestButton.translatesAutoresizingMaskIntoConstraints = false
        darkTestButton.translatesAutoresizingMaskIntoConstraints = false
        systemTestButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            title.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            lightTestButton.widthAnchor.constraint(equalToConstant: 50),
            lightTestButton.heightAnchor.constraint(equalToConstant: 50),
            lightTestButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            lightTestButton.centerXAnchor.constraint(equalTo: centerXAnchor,
                                                     constant: -50),
            
            darkTestButton.widthAnchor.constraint(equalToConstant: 50),
            darkTestButton.heightAnchor.constraint(equalToConstant: 50),
            darkTestButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            darkTestButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            systemTestButton.widthAnchor.constraint(equalToConstant: 50),
            systemTestButton.heightAnchor.constraint(equalToConstant: 50),
            systemTestButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            systemTestButton.centerXAnchor.constraint(equalTo: centerXAnchor,
                                                      constant: 50)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
