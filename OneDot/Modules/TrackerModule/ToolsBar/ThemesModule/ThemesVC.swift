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
    
    let storiesCell = StoriesThemesViewCell()
    let widgetsCell = WidgetsThemeViewCell()
    let colorThemesCell = ColorThemeViewCell()
    
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
        sectionStack.spacing = 0
        sectionStack.layer.cornerRadius = CGFloat.iconSide / 2
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
        tableView.layer.borderWidth = 0.3
        tableView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        
        storiesSectionButton.addTarget(self,
                                         action: #selector(buttonTapt),
                                         for: .touchUpInside)
        widgetsSectionButton.addTarget(self,
                                             action: #selector(buttonTapt),
                                             for: .touchUpInside)
        colorThemesSectionButton.addTarget(self,
                                             action: #selector(buttonTapt),
                                             for: .touchUpInside)
        
        setActiveSection(.stories)
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
                     named: "themesStoriesIconFill")
            setImage(widgetsSectionButton,
                     named: "themesWidgetsIconStroke")
            setImage(colorThemesSectionButton,
                     named: "themesColorIconStroke")
            sectionTitle.text = "Stories"
            
            currentRows.removeAll()
            currentRows.append(storiesCell)
            tableView.reloadData()
        case .widgets:
            setImage(widgetsSectionButton,
                     named: "themesWidgetsIconFill")
            setImage(colorThemesSectionButton,
                     named: "themesColorIconStroke")
            setImage(storiesSectionButton,
                     named: "themesStoriesIconStroke")
            sectionTitle.text = "Widgets"
            
            currentRows.removeAll()
            currentRows.append(widgetsCell)
            tableView.reloadData()
            
        case .colorThemes:
            setImage(colorThemesSectionButton,
                     named: "themesColorIconFill")
            setImage(storiesSectionButton,
                     named: "themesStoriesIconStroke")
            setImage(widgetsSectionButton,
                     named: "themesWidgetsIconStroke")
            sectionTitle.text = "Colors"
            
            currentRows.removeAll()
            currentRows.append(colorThemesCell)
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
                                            CGFloat.iconSide) +
                                           (CGFloat(sectionStack.subviews.count) *
                                            0) -
                                            0),
            sectionStack.heightAnchor.constraint(equalToConstant:
                                            CGFloat.iconSide),
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
                                            view.leadingAnchor,
                                            constant: -0.5),
            tableView.topAnchor.constraint(equalTo:
                                            sectionTitle.bottomAnchor,
                                            constant: 10),
            tableView.trailingAnchor.constraint(equalTo:
                                            view.trailingAnchor,
                                            constant: 0.5),
            tableView.bottomAnchor.constraint(equalTo:
                                            view.bottomAnchor,
                                            constant: 0.5)
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
