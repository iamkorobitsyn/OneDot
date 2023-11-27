//
//  SettingsViewController.swift
//  OneDot
//
//  Created by Александр Коробицын on 28.09.2023.
//

import UIKit

class SettingsVC: UIViewController {
    
    private let measuringSectionButton: UIButton = UIButton()
    private let notificationsSectionButton: UIButton = UIButton()
    private let connectionsSectionButton: UIButton = UIButton()
    private var sectionButtonList: [UIButton] = [UIButton]()
    private var sectionStack: UIStackView = UIStackView()
    
    private let sectionTitle: UILabel = UILabel()
    
    enum CurrentSection {
        case measuring, 
             notifications,
             connections
    }
    
    var currentRows: [ToolsBarCellBase] = []

    private let tableView: UITableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setConstraints()
    }
    
    //MARK: - SetViews
    
    private func setViews() {
        sectionButtonList.append(contentsOf: [measuringSectionButton,
                                            notificationsSectionButton,
                                            connectionsSectionButton])
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
        
        measuringSectionButton.addTarget(self,
                                         action: #selector(buttonTapt),
                                         for: .touchUpInside)
        notificationsSectionButton.addTarget(self,
                                             action: #selector(buttonTapt),
                                             for: .touchUpInside)
        connectionsSectionButton.addTarget(self,
                                             action: #selector(buttonTapt),
                                             for: .touchUpInside)
        
        setActiveSection(.measuring)
    }
    
    //MARK: - SetButtons
    
    @objc private func buttonTapt() {
        if measuringSectionButton.isTouchInside {
            setActiveSection(.measuring)
        } else if notificationsSectionButton.isTouchInside {
            setActiveSection(.notifications)
        } else if connectionsSectionButton.isTouchInside {
            setActiveSection(.connections)
        }
    }

    private func setActiveSection(_ section: CurrentSection) {
        switch section {
            
        case .measuring:
            setImage(measuringSectionButton, 
                     named: "measuringIconFill")
            setImage(notificationsSectionButton, 
                     named: "notificationsIconStroke")
            setImage(connectionsSectionButton,
                     named: "connectionsIconStroke")
            sectionTitle.text = "Measuring"
            
            currentRows.removeAll()
            let cell = MeasuringViewCell()
            currentRows.append(cell)
            
            tableView.reloadData()
        case .notifications:
            setImage(notificationsSectionButton,
                     named: "notificationsIconFill")
            setImage(connectionsSectionButton,
                     named: "connectionsIconStroke")
            setImage(measuringSectionButton,
                     named: "measuringIconStroke")
            sectionTitle.text = "Notifications"
            
            currentRows.removeAll()
            let cell = NotificationsViewCell()
            currentRows.append(cell)
            
            tableView.reloadData()
            
        case .connections:
            setImage(connectionsSectionButton,
                     named: "connectionsIconFill")
            setImage(measuringSectionButton,
                     named: "measuringIconStroke")
            setImage(notificationsSectionButton,
                     named: "notificationsIconStroke")
            sectionTitle.text = "Conections"
            
            currentRows.removeAll()
            let cell = ConnectionsViewCell()
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

     //MARK: - TableViewDataSourse&TableViewDelegate

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        currentRows.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return currentRows[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let cell = currentRows[indexPath.row] as? MeasuringViewCell {
            return cell.heightForRow
        } else if let cell = currentRows[indexPath.row] as? NotificationsViewCell {
            return cell.heightForRow
        } else if let cell = currentRows[indexPath.row] as? ConnectionsViewCell {
            return cell.heightForRow
        }
        return CGFloat()
    }
}
