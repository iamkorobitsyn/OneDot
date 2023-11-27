//
//  ThemesVC.swift
//  OneDot
//
//  Created by Александр Коробицын on 27.11.2023.
//

import UIKit

class ThemesVC: UIViewController {
    
    let storiesSectionButton: UIButton = UIButton()
    let widgetsSectionButton: UIButton = UIButton()
    let colorThemesSectionButton: UIButton = UIButton()
    var sectionButtonList: [UIButton] = [UIButton]()
    var sectionStack: UIStackView = UIStackView()
    
    let sectionTitle: UILabel = UILabel()
    
    enum CurrentSection {
        case stories,
             widgets,
             colorThemes
    }
    
    var currentRows: [ToolsBarCellBase] = []
    
    private let tableView: UITableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        sectionTitle.text = "THEMES"
        setViews()
        setConstraints()
        
    }
    
    //MARK: - SetViews
    
    private func setViews() {
        sectionButtonList.append(contentsOf: [storiesSectionButton,
                                              widgetsSectionButton,
                                              colorThemesSectionButton])
        sectionStack = UIStackView(arrangedSubviews: sectionButtonList)
        sectionStack.axis = .horizontal
        sectionStack.distribution = .fillEqually
        sectionStack.spacing = .stackSpacing
        sectionStack.layer.cornerRadius = .stackCorner
        view.addSubview(sectionStack)
        
        view.addSubview(sectionTitle)
        sectionTitle.textColor = .gray
        sectionTitle.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .none
        tableView.separatorStyle = .none
        
        storiesSectionButton.addTarget(self,
                                         action: #selector(buttonTapt),
                                         for: .touchUpInside)
        widgetsSectionButton.addTarget(self,
                                             action: #selector(buttonTapt),
                                             for: .touchUpInside)
        colorThemesSectionButton.addTarget(self,
                                             action: #selector(buttonTapt),
                                             for: .touchUpInside)
        
        setActiveSection(.colorThemes)
    }
    
    
    //MARK: - SetButtons
    
    @objc private func buttonTapt() {
        if storiesSectionButton.isTouchInside {
            setActiveSection(.stories)
        } else if widgetsSectionButton.isTouchInside {
            setActiveSection(.widgets)
        } else if colorThemesSectionButton.isTouchInside {
            setActiveSection(.colorThemes)
        }
    }

    private func setActiveSection(_ section: CurrentSection) {
        switch section {
            
        case .stories:
            setImage(storiesSectionButton,
                     named: "measuringIconFill")
            setImage(widgetsSectionButton,
                     named: "notificationsIconStroke")
            setImage(colorThemesSectionButton,
                     named: "connectionsIconStroke")
            sectionTitle.text = "Measuring"
            
            currentRows.removeAll()
            let cell = MeasuringViewCell()
            currentRows.append(cell)
            
            tableView.reloadData()
        case .widgets:
            setImage(widgetsSectionButton,
                     named: "notificationsIconFill")
            setImage(colorThemesSectionButton,
                     named: "connectionsIconStroke")
            setImage(storiesSectionButton,
                     named: "measuringIconStroke")
            sectionTitle.text = "Notifications"
            
            currentRows.removeAll()
            let cell = NotificationsViewCell()
            currentRows.append(cell)
            
            tableView.reloadData()
            
        case .colorThemes:
            setImage(colorThemesSectionButton,
                     named: "connectionsIconFill")
            setImage(storiesSectionButton,
                     named: "measuringIconStroke")
            setImage(widgetsSectionButton,
                     named: "notificationsIconStroke")
            sectionTitle.text = "Conections"
            
            currentRows.removeAll()
            let cell = ColorThemeViewCell()
            currentRows.append(cell)
            
            tableView.reloadData()
            
        }
    }
    
    private func setImage(_ button: UIButton, named: String) {
        button.setImage(UIImage(named: named), for: .normal)
        button.setImage(UIImage(named: named), for: .highlighted)
    }
    
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        
        
        sectionStack.translatesAutoresizingMaskIntoConstraints = false
        sectionTitle.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            sectionStack.widthAnchor.constraint(equalToConstant:
                                           (CGFloat(sectionStack.subviews.count) *
                                            CGFloat.mainIconSide) +
                                           (CGFloat(sectionStack.subviews.count) *
                                            CGFloat.stackSpacing) -
                                            CGFloat.stackSpacing),
            sectionStack.heightAnchor.constraint(equalToConstant:
                                            CGFloat.mainIconSide),
            sectionStack.centerXAnchor.constraint(equalTo:
                                            view.centerXAnchor),
            sectionStack.topAnchor.constraint(equalTo:
                                            view.topAnchor,
                                            constant: 20),
            
            sectionTitle.centerXAnchor.constraint(equalTo:
                                            sectionStack.centerXAnchor),
            sectionTitle.topAnchor.constraint(equalTo:
                                            sectionStack.bottomAnchor,
                                            constant: 5),
            
            tableView.leadingAnchor.constraint(equalTo:
                                            view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo:
                                            sectionTitle.bottomAnchor,
                                            constant: 10),
            tableView.trailingAnchor.constraint(equalTo:
                                            view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo:
                                            view.bottomAnchor)
        ])
    }
}

extension ThemesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        currentRows.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return currentRows[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}
