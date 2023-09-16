//
//  ActivitySelectionView.swift
//  OneDot
//
//  Created by Александр Коробицын on 11.09.2023.
//

import UIKit

class ActivitiesMenu: UIView {
    
    private let buttonsWidth: CGFloat = 40
    private let stackSpacing: CGFloat = 5
    
    let seasonView: UIView = UIView()
    let disciplineView: UIView = UIView()
    
    var gymSeasonStack: UIStackView = UIStackView()
    var summerSeasonStack: UIStackView = UIStackView()
    var winterSeasonStack: UIStackView = UIStackView()
    
    var gymSeasonButtonList: [UIButton] = [UIButton]()
    var summerSeasonButtonList: [UIButton] = [UIButton]()
    var winterSeasonButtonList: [UIButton] = [UIButton]()
    
    let swimmingButton: ActivityButton = ActivityButton()
    let paddleSwimmingButton: ActivityButton = ActivityButton()
    let hikingButton: ActivityButton = ActivityButton()
    let runningButton: ActivityButton = ActivityButton()
    let bicycleButton: ActivityButton = ActivityButton()
    let boardButton: ActivityButton = ActivityButton()
    let rollerSkatesButton: ActivityButton = ActivityButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setSummerSeasonButtons()
        setStackViews()
        setViews()
        setConstraints()
            
    }
    
    
    private func setStackViews() {
        
        //MARK: - SetSummerIconsStack
        
        summerSeasonStack = UIStackView(arrangedSubviews: summerSeasonButtonList)
        summerSeasonStack.backgroundColor = .none
        summerSeasonStack.axis = .horizontal
        summerSeasonStack.distribution = .fillEqually
        summerSeasonStack.spacing = stackSpacing
        
    }
    
    //MARK: - SetViews
    
    private func setViews() {
        
        backgroundColor = .customBlueMid.withAlphaComponent(0.8)
        layer.cornerRadius = 20
        layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        
        addSubview(seasonView)
        addSubview(disciplineView)
        
        disciplineView.addSubview(summerSeasonStack)
        
        seasonView.translatesAutoresizingMaskIntoConstraints = false
        disciplineView.translatesAutoresizingMaskIntoConstraints = false
        
        summerSeasonStack.translatesAutoresizingMaskIntoConstraints = false
    
    }
    
    //MARK: - SetButtons
    
    private func setSummerSeasonButtons() {
        
        swimmingButton.setInactiveState(.swimming)
        paddleSwimmingButton.setInactiveState(.paddleswimming)
        hikingButton.setInactiveState(.hiking)
        runningButton.setInactiveState(.running)
        bicycleButton.setInactiveState(.bicycle)
        boardButton.setInactiveState(.board)
        rollerSkatesButton.setInactiveState(.rollerSkates)
        
        summerSeasonButtonList.append(contentsOf: [swimmingButton,
                                                   paddleSwimmingButton,
                                                   hikingButton,
                                                   runningButton,
                                                   bicycleButton,
                                                   boardButton,
                                                   rollerSkatesButton])
        
        for button in summerSeasonButtonList {
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
    }
    
    @objc private func buttonTapped() {
        
        if swimmingButton.isTouchInside {
            setSummerSeasonButtons()
            print("swimming")
            swimmingButton.setActiveState(.swimming)
        } else if paddleSwimmingButton.isTouchInside {
            setSummerSeasonButtons()
            print("paddle")
            paddleSwimmingButton.setActiveState(.paddleswimming)
        } else if hikingButton.isTouchInside {
            setSummerSeasonButtons()
            print("hiking")
            hikingButton.setActiveState(.hiking)
        } else if runningButton.isTouchInside {
            setSummerSeasonButtons()
            print("running")
            runningButton.setActiveState(.running)
        } else if bicycleButton.isTouchInside {
            setSummerSeasonButtons()
            print("bicycle")
            bicycleButton.setActiveState(.bicycle)
        } else if boardButton.isTouchInside {
            setSummerSeasonButtons()
            print("board")
            boardButton.setActiveState(.board)
        } else if rollerSkatesButton.isTouchInside {
            setSummerSeasonButtons()
            print("rollerSkate")
            rollerSkatesButton.setActiveState(.rollerSkates)
        }
    }
    
    
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            disciplineView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            disciplineView.heightAnchor.constraint(equalToConstant: 75),
            disciplineView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            seasonView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            seasonView.heightAnchor.constraint(equalToConstant: 75),
            seasonView.bottomAnchor.constraint(equalTo: disciplineView.topAnchor),
            
            summerSeasonStack.bottomAnchor.constraint(equalTo: disciplineView.bottomAnchor, constant: -25),
            summerSeasonStack.heightAnchor.constraint(equalToConstant: buttonsWidth),
            summerSeasonStack.widthAnchor.constraint(equalToConstant: CGFloat(summerSeasonStack.subviews.count) * buttonsWidth + (stackSpacing * CGFloat(summerSeasonStack.subviews.count) - 1)),
            summerSeasonStack.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
