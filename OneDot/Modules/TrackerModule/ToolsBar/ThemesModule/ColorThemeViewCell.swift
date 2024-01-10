//
//  ColorThemeViewCell.swift
//  OneDot
//
//  Created by Александр Коробицын on 27.11.2023.
//

import UIKit

class ColorThemeViewCell: ToolsBarCellBase {
    
    var navigationVCColorSetDelegate: NavigationVCColorSetProtocol?
    var mainVCColorSetDelegate: MainVCColorSetProtocol?
    
    private let lightThemeButton = UIButton()
    private let lightTitle: UILabel = UILabel()
    
    private let darkThemeButton = UIButton()
    private let darkTitle: UILabel = UILabel()
    
    private let systemThemeButton = UIButton()
    private let systemTitle: UILabel = UILabel()
    
    private let picker = UIPickerView()
    private let colorTitle: UILabel = UILabel()
    private let pickerSeparator: CAShapeLayer = CAShapeLayer()
    
    var buttonsList: [UIButton] = [UIButton]()
    var colorSetList = FactoryColorSet.shared.get()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        picker.delegate = self
        picker.dataSource = self
        
        setViews()
        setConstraints()
        setCurrentStates()
        
        
        registerForTraitChanges([UITraitUserInterfaceStyle.self],
                                action: #selector(changeUserInterfaceStyle))
    }
    
    deinit {
        navigationVCColorSetDelegate = nil
        mainVCColorSetDelegate = nil
    }
    
    //MARK: - SetCurrentStates
    
    private func setCurrentStates() {
        
        picker.selectRow(ColorIndexManager.shared.colorIndex ?? 0,
                         inComponent: 0,
                         animated: true)
        
        setButtonImage(lightThemeButton, UIColor.currentColorSet.imageLight)
        setButtonImage(darkThemeButton, UIColor.currentColorSet.imageDeep)
        setButtonImage(systemThemeButton, UIColor.currentColorSet.imageSystem)
        
        colorTitle.text = UIColor.currentColorSet.textTitle
        
        switch TraitCollectionManager.shared.theme {
            
        case .device:
            setActiveButton(systemThemeButton)
        case .light:
            setActiveButton(lightThemeButton)
        case .dark:
            setActiveButton(darkThemeButton)
        }

    }
    
    //MARK: - SetViews

    private func setViews() {
        
        addSubview(lightThemeButton)
        lightThemeButton.imageView?.contentMode = .scaleAspectFit
        lightThemeButton.layer.cornerRadius = 15
        lightThemeButton.addTarget(self, action: #selector(buttonPressed),
                                  for: .touchUpInside)
        
        lightThemeButton.addSubview(lightTitle)
        lightTitle.text = "LIGHT"
        lightTitle.font = UIFont.systemFont(ofSize: 20,
                                            weight: .medium,
                                            width: .compressed)
        lightTitle.textColor = .gray
        
        
        addSubview(darkThemeButton)
        darkThemeButton.imageView?.contentMode = .scaleAspectFit
        darkThemeButton.layer.cornerRadius = 15
        darkThemeButton.addTarget(self, action: #selector(buttonPressed),
                                 for: .touchUpInside)
        darkThemeButton.addSubview(darkTitle)
        darkTitle.text = "DEEP"
        darkTitle.font = UIFont.systemFont(ofSize: 20,
                                            weight: .medium,
                                            width: .compressed)
        darkTitle.textColor = .gray
        
        
        addSubview(systemThemeButton)
        systemThemeButton.imageView?.contentMode = .scaleAspectFit
        systemThemeButton.layer.cornerRadius = 15
        systemThemeButton.addTarget(self, action: #selector(buttonPressed),
                                   for: .touchUpInside)
        systemThemeButton.addSubview(systemTitle)
        systemTitle.text = "SYSTEM"
        systemTitle.font = UIFont.systemFont(ofSize: 20,
                                            weight: .medium,
                                            width: .compressed)
        systemTitle.textColor = .gray
        
        
        buttonsList.append(contentsOf: [systemThemeButton,
                                         lightThemeButton,
                                         darkThemeButton])
        
        addSubview(picker)
        let rotationAngle: CGFloat = -90 * (.pi / 180)
        picker.transform = CGAffineTransform(rotationAngle: rotationAngle)
        
        addSubview(colorTitle)
        colorTitle.font = UIFont.systemFont(ofSize: 25,
                                            weight: .medium,
                                            width: .compressed)
        colorTitle.textColor = .gray
        
        Shaper.shared.drawCenterXSeparator(shape: pickerSeparator,
                                                      view: self,
                                                      xMove: -41,
                                                      xAdd: 21,
                                                      y: 310,
                                                      lineWidth: 0.7,
                                                      color: .lightGray)
 
    }
    
    //MARK: - ChangeUserInterfaceStyle
    
    @objc private func changeUserInterfaceStyle() {
        
        if traitCollection.userInterfaceStyle == .dark {
            navigationVCColorSetDelegate?.update(UIColor.currentColorSet, false)
            mainVCColorSetDelegate?.update(UIColor.currentColorSet, false)
        } else if traitCollection.userInterfaceStyle == .light {
            navigationVCColorSetDelegate?.update(UIColor.currentColorSet, true)
            mainVCColorSetDelegate?.update(UIColor.currentColorSet, true)
        }
    }
    
    //MARK: - SettingsOfButtons
    
    private func setActiveButton(_ button: UIButton) {
        buttonsList[0].backgroundColor = .clear
        buttonsList[1].backgroundColor = .clear
        buttonsList[2].backgroundColor = .clear
        button.backgroundColor = .lightGray.withAlphaComponent(0.3)
    }
    
    private func setButtonImage(_ button: UIButton, _ imageNamed: String) {
        button.setImage(UIImage(named: imageNamed) , for: .normal)
        button.setImage(UIImage(named: imageNamed) , for: .highlighted)
    }
    
    @objc private func buttonPressed() {
        
        for i in 0..<buttonsList.count {
            if buttonsList[i].isTouchInside {

                setActiveButton(buttonsList[i])
                
                TraitCollectionManager.shared.theme = Theme(rawValue: i) ?? .device
                window?.overrideUserInterfaceStyle =
                TraitCollectionManager.shared.theme.getUserInterfaceStyle()
                
            }
        }
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        
        lightThemeButton.translatesAutoresizingMaskIntoConstraints = false
        darkThemeButton.translatesAutoresizingMaskIntoConstraints = false
        systemThemeButton.translatesAutoresizingMaskIntoConstraints = false
        
        lightTitle.translatesAutoresizingMaskIntoConstraints = false
        darkTitle.translatesAutoresizingMaskIntoConstraints = false
        systemTitle.translatesAutoresizingMaskIntoConstraints = false
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        colorTitle.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            darkThemeButton.widthAnchor.constraint(equalToConstant: 110),
            darkThemeButton.heightAnchor.constraint(equalToConstant: 200),
            darkThemeButton.centerXAnchor.constraint(equalTo: 
                                            centerXAnchor),
            darkThemeButton.topAnchor.constraint(equalTo:
                                            contentView.topAnchor,
                                            constant: 20),
            
            lightThemeButton.widthAnchor.constraint(equalToConstant: 110),
            lightThemeButton.heightAnchor.constraint(equalToConstant: 200),
            lightThemeButton.centerYAnchor.constraint(equalTo:
                                            darkThemeButton.centerYAnchor),
            lightThemeButton.trailingAnchor.constraint(equalTo:
                                            darkThemeButton.leadingAnchor),
            
            systemThemeButton.widthAnchor.constraint(equalToConstant: 110),
            systemThemeButton.heightAnchor.constraint(equalToConstant: 200),
            systemThemeButton.centerYAnchor.constraint(equalTo:
                                            darkThemeButton.centerYAnchor),
            systemThemeButton.leadingAnchor.constraint(equalTo:
                                            darkThemeButton.trailingAnchor),
            
            lightTitle.centerXAnchor.constraint(equalTo:
                                            lightThemeButton.centerXAnchor),
            lightTitle.bottomAnchor.constraint(equalTo:
                                            lightThemeButton.bottomAnchor,
                                            constant: -10),
            darkTitle.centerXAnchor.constraint(equalTo:
                                            darkThemeButton.centerXAnchor),
            darkTitle.bottomAnchor.constraint(equalTo:
                                            darkThemeButton.bottomAnchor,
                                            constant: -10),
            systemTitle.centerXAnchor.constraint(equalTo:
                                            systemThemeButton.centerXAnchor),
            systemTitle.bottomAnchor.constraint(equalTo:
                                            systemThemeButton.bottomAnchor,
                                            constant: -10),
            picker.widthAnchor.constraint(equalToConstant: 45),
            picker.heightAnchor.constraint(equalToConstant: .barWidth),
            picker.centerXAnchor.constraint(equalTo: centerXAnchor),
            picker.centerYAnchor.constraint(equalTo:
                                            darkThemeButton.bottomAnchor,
                                            constant: 60),
            
            colorTitle.topAnchor.constraint(equalTo:
                                            picker.centerYAnchor,
                                            constant: 40),
            colorTitle.centerXAnchor.constraint(equalTo: 
                                            contentView.centerXAnchor)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - PikerViewDelegate&PickerViewDataSourse


extension ColorThemeViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colorSetList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        picker.subviews.forEach() {
            $0.backgroundColor = .clear
        }
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: colorSetList[row].colorIcon)
        imageView.backgroundColor = .none
        imageView.contentMode = .scaleAspectFit
        let rotationAngle: CGFloat = 90 * (.pi / 180)
        imageView.transform = CGAffineTransform(rotationAngle: rotationAngle)
        return imageView
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        45
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        colorTitle.text = colorSetList[row].textTitle
        
        UIColor.currentColorSet = colorSetList[row]
        ColorIndexManager.shared.colorIndex = row
        
        setButtonImage(lightThemeButton, colorSetList[row].imageLight)
        setButtonImage(darkThemeButton, colorSetList[row].imageDeep)
        setButtonImage(systemThemeButton, colorSetList[row].imageSystem)

        if traitCollection.userInterfaceStyle == .dark {
            navigationVCColorSetDelegate?.update(UIColor.currentColorSet, false)
            mainVCColorSetDelegate?.update(UIColor.currentColorSet, false)
        } else if traitCollection.userInterfaceStyle == .light {
            navigationVCColorSetDelegate?.update(UIColor.currentColorSet, true)
            mainVCColorSetDelegate?.update(UIColor.currentColorSet, true)
        }
  
    }
    
    

    

}
