//
//  ThemesVC.swift
//  OneDot
//
//  Created by Александр Коробицын on 27.11.2023.
//

import UIKit

class ThemesVC: UIViewController {
    
    private let storiesShowButton: UIButton = UIButton()
    private let colorThemesShowButton: UIButton = UIButton()
    private var buttonList: [UIButton] = [UIButton]()
    
    let storiesCell = StoriesThemesViewCell()
    let colorThemesCell = ColorThemeViewCell()
    
    private var currentRows: [UITableViewCell] = []
    
    var titleCompletion: ((String) -> ())?
    
    private var buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .none
        tableView.separatorStyle = .none
        tableView.layer.borderWidth = 0.3
        tableView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        return tableView
    }()
    
    
    enum CurrentSection: Int {
        case stories = 0,
             colorThemes = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setConstraints()
    }
    
    //MARK: - SetViews
    
    private func setViews() {
        buttonList.append(contentsOf: [storiesShowButton,
                                       colorThemesShowButton])
        
        buttonList.forEach { selector in
            buttonsStack.addArrangedSubview(selector)
            selector.addTarget(self, action: #selector(buttonTapped), 
                               for: .touchUpInside)
        }

        view.addSubview(buttonsStack)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    
    //MARK: - SetButtons
    
    @objc private func buttonTapped() {
        
        for i in 0..<buttonList.count {
            if buttonList[i].isTouchInside {
                setActiveSection(section: i)
            }
        }
    }

    func setActiveSection(section: CurrentSection.RawValue) {
        switch section {
            
        case 0:
            setImage(storiesShowButton,
                     named: "themesStoriesIconFill")
            setImage(colorThemesShowButton,
                     named: "themesColorIconStroke")

            currentRows.removeAll()
            currentRows.append(storiesCell)
            tableView.reloadData()
            
            titleCompletion?("STORIES THEMES")
            UserDefaultsManager.shared.themesStatus = section

        case 1:
            setImage(colorThemesShowButton,
                     named: "themesColorIconFill")
            setImage(storiesShowButton,
                     named: "themesStoriesIconStroke")

            currentRows.removeAll()
            currentRows.append(colorThemesCell)
            tableView.reloadData()
            
            titleCompletion?("COLOR THEMES")
            UserDefaultsManager.shared.themesStatus = section
            
        default:
            break
        }
    }
    
    private func setImage(_ button: UIButton, named: String) {
        button.setImage(UIImage(named: named), for: .normal)
        button.setImage(UIImage(named: named), for: .highlighted)
    }
    
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            
            buttonsStack.widthAnchor.constraint(equalToConstant:
                                           (CGFloat(buttonsStack.subviews.count) *
                                            CGFloat.iconSide) +
                                           (CGFloat(buttonsStack.subviews.count) *
                                            0) -
                                            0),
            buttonsStack.heightAnchor.constraint(equalToConstant:
                                            CGFloat.iconSide),
            buttonsStack.centerXAnchor.constraint(equalTo:
                                            view.centerXAnchor),
            buttonsStack.topAnchor.constraint(equalTo:
                                            view.topAnchor,
                                            constant: 10),
            
            tableView.leadingAnchor.constraint(equalTo:
                                            view.leadingAnchor,
                                            constant: -0.5),
            tableView.topAnchor.constraint(equalTo:
                                            buttonsStack.bottomAnchor,
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
