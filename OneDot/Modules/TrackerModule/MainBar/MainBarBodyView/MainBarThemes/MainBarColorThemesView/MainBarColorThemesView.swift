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
    
    let title: UILabel = UILabel()
    
    let lightTestButton = UIButton()
    let darkTestButton = UIButton()
    let systemTestButton = UIButton()
    
    var selectorList: [UIButton] = [UIButton]()
    var colorSetList = FactoryColorSet.shared.get()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        
        
     
        
        setViews()
        setConstraints()
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 220, height: 280)
        layout.scrollDirection = .horizontal
        
        let myCollectionView: UICollectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        myCollectionView.register(MainBarColorThemesCollectionCell.self, forCellWithReuseIdentifier: "MyCell")
        myCollectionView.backgroundColor = UIColor.white
        myCollectionView.backgroundColor = .red.withAlphaComponent(0.3)
        self.addSubview(myCollectionView)
        
        myCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myCollectionView.widthAnchor.constraint(equalToConstant:
                                            UIScreen.main.bounds.width),
            myCollectionView.heightAnchor.constraint(equalToConstant: 100),
            myCollectionView.centerXAnchor.constraint(equalTo: centerXAnchor),
            myCollectionView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 40)
        ])

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
        selectorList[0].isHidden = true
        selectorList[1].isHidden = true
        selectorList[2].isHidden = true
        
        registerForTraitChanges([UITraitUserInterfaceStyle.self], 
                                action: #selector(changeUserInterfaceStyle))
        
    }
    
    //MARK: - ChangeUserInterfaceStyle
    
    @objc private func changeUserInterfaceStyle() {
        if traitCollection.userInterfaceStyle == .dark {
            navigationVCDelegate?.update(UIColor.currentColorSet, false)
            mainVCDelegate?.update(UIColor.currentColorSet, false)
        } else if traitCollection.userInterfaceStyle == .light {
            navigationVCDelegate?.update(UIColor.currentColorSet, true)
            mainVCDelegate?.update(UIColor.currentColorSet, true)
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

                    navigationVCDelegate?.update(UIColor.currentColorSet, true)
                    mainVCDelegate?.update(UIColor.currentColorSet, true)
                }
                
                if i == 2 {

                    navigationVCDelegate?.update(UIColor.currentColorSet, false)
                    mainVCDelegate?.update(UIColor.currentColorSet, false)
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
                                                      constant: 50),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MainBarColorThemesView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorSetList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as? MainBarColorThemesCollectionCell
        myCell?.title.text = colorSetList[indexPath.row].textTitle
        return myCell ?? UICollectionViewCell()
    }
    
    //MARK: - DidSelectCollectionView
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        
        let colorSet = colorSetList[indexPath.row]
        UIColor.currentColorSet = colorSet
        ColorIndexManager.shared.colorIndex = indexPath.row
        
        TraitCollectionManager.shared.theme = colorSet.theme
        window?.overrideUserInterfaceStyle =
        TraitCollectionManager.shared.theme.getUserInterfaceStyle()
        
        if traitCollection.userInterfaceStyle == .light {
            navigationVCDelegate?.update(colorSet, true)
            mainVCDelegate?.update(colorSet, true)
        }
        
        if traitCollection.userInterfaceStyle == .dark {
            navigationVCDelegate?.update(colorSet, false)
            mainVCDelegate?.update(colorSet, false)
            
        }
        
        

    }
}


