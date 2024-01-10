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
    
    private let visualEffectView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.effect = UIBlurEffect(style: .light)
        view.backgroundColor = .white.withAlphaComponent(0.5)
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        return view
    }()
    
    private let hideButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "additionalHideIcon"), for: .normal)
        return button
    }()
    
//    private let sectionTitle: UILabel = UILabel()
//    
//    enum CurrentSection {
//        case measuring, 
//             notifications,
//             connections
//    }
//    
//    var currentRows: [ToolsBarCellBase] = []

    private let tableView: UITableView = UITableView()
    
    private let sectionList: [ToolsBarCellBase] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setConstraints()
    }
    
    //MARK: - SetViews
    
    private func setViews() {
        view.addSubview(visualEffectView)
        sectionButtonList.append(contentsOf: [measuringSectionButton,
                                            notificationsSectionButton,
                                            connectionsSectionButton])
        sectionStack = UIStackView(arrangedSubviews: sectionButtonList)
        sectionStack.axis = .horizontal
        sectionStack.distribution = .fillEqually
        sectionStack.spacing = 0
        sectionStack.layer.cornerRadius = CGFloat.iconSide / 2
        visualEffectView.contentView.addSubview(sectionStack)
        
//        visualEffectView.contentView.addSubview(sectionTitle)
//        sectionTitle.textColor = .gray
//        sectionTitle.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        visualEffectView.contentView.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, 
                           forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .none
        tableView.separatorStyle = .none
        
//        measuringSectionButton.addTarget(self,
//                                         action: #selector(buttonTapt),
//                                         for: .touchUpInside)
//        notificationsSectionButton.addTarget(self,
//                                             action: #selector(buttonTapt),
//                                             for: .touchUpInside)
//        connectionsSectionButton.addTarget(self,
//                                             action: #selector(buttonTapt),
//                                             for: .touchUpInside)
        
        visualEffectView.contentView.addSubview(hideButton)
        hideButton.addTarget(self, action: #selector(skip), for: .touchUpInside)
        
        
//        setActiveSection(.measuring)
    }
    
    //MARK: - SetButtons
    
//    @objc private func buttonTapt() {
//        if measuringSectionButton.isTouchInside {
//            setActiveSection(.measuring)
//        } else if notificationsSectionButton.isTouchInside {
//            setActiveSection(.notifications)
//        } else if connectionsSectionButton.isTouchInside {
//            setActiveSection(.connections)
//        }
//    }
    
    @objc private func skip() {
        self.dismiss(animated: true)
    }
//
//    private func setActiveSection(_ section: CurrentSection) {
//        switch section {
//            
//        case .measuring:
//            setImage(measuringSectionButton, 
//                     named: "measuringIconFill")
//            setImage(notificationsSectionButton, 
//                     named: "notificationsIconStroke")
//            setImage(connectionsSectionButton,
//                     named: "connectionsIconStroke")
//            sectionTitle.text = "Measuring"
//            
//            currentRows.removeAll()
//            let cell = MeasuringViewCell()
//            currentRows.append(cell)
//            
//            tableView.reloadData()
//        case .notifications:
//            setImage(notificationsSectionButton,
//                     named: "notificationsIconFill")
//            setImage(connectionsSectionButton,
//                     named: "connectionsIconStroke")
//            setImage(measuringSectionButton,
//                     named: "measuringIconStroke")
//            sectionTitle.text = "Notifications"
//            
//            currentRows.removeAll()
//            let cell = NotificationsViewCell()
//            currentRows.append(cell)
//            
//            tableView.reloadData()
//            
//        case .connections:
//            setImage(connectionsSectionButton,
//                     named: "connectionsIconFill")
//            setImage(measuringSectionButton,
//                     named: "measuringIconStroke")
//            setImage(notificationsSectionButton,
//                     named: "notificationsIconStroke")
//            sectionTitle.text = "Conections"
//            
//            currentRows.removeAll()
//            let cell = ConnectionsViewCell()
//            currentRows.append(cell)
//            
//            tableView.reloadData()
//            
//        }
//    }
    
    private func setImage(_ button: UIButton, named: String) {
        button.setImage(UIImage(named: named), for: .normal)
        button.setImage(UIImage(named: named), for: .highlighted)
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        
        
        sectionStack.translatesAutoresizingMaskIntoConstraints = false
//        sectionTitle.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            visualEffectView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            visualEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            visualEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            sectionStack.widthAnchor.constraint(equalToConstant:
                                           (CGFloat(sectionStack.subviews.count) *
                                            CGFloat.iconSide) +
                                           (CGFloat(sectionStack.subviews.count) *
                                            0) -
                                            0),
            sectionStack.heightAnchor.constraint(equalToConstant:
                                            CGFloat.iconSide),
            sectionStack.centerXAnchor.constraint(equalTo: 
                                            visualEffectView.centerXAnchor),
            sectionStack.topAnchor.constraint(equalTo:
                                            visualEffectView.topAnchor,
                                            constant: 20),
            
//            sectionTitle.centerXAnchor.constraint(equalTo:
//                                            sectionStack.centerXAnchor),
//            sectionTitle.topAnchor.constraint(equalTo:
//                                            sectionStack.bottomAnchor,
//                                            constant: 5),
            
            tableView.leadingAnchor.constraint(equalTo: 
                                            view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo:
                                            view.topAnchor,
                                            constant: 100),
            tableView.trailingAnchor.constraint(equalTo:
                                            view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo:
                                            view.bottomAnchor),
            
            hideButton.widthAnchor.constraint(equalToConstant: 42),
            hideButton.heightAnchor.constraint(equalToConstant: 42),
            hideButton.topAnchor.constraint(equalTo: 
                                            visualEffectView.topAnchor,
                                            constant: 10),
            hideButton.trailingAnchor.constraint(equalTo:
                                            visualEffectView.trailingAnchor,
                                            constant: -10)
        ])
    }
}

     //MARK: - TableViewDataSourse&TableViewDelegate

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = MeasuringViewCell()
            return cell
        } else if indexPath.section == 1 {
            let cell = NotificationsViewCell()
            return cell
        } else if indexPath.section == 2 {
            let cell = ConnectionsViewCell()
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 490
        } else if indexPath.section == 1 {
            return 250
        } else if indexPath.section == 2 {
            return 600
        }
        
        
//        if let cell = currentRows[indexPath.row] as? MeasuringViewCell {
//            return cell.heightForRow
//        } else if let cell = currentRows[indexPath.row] as? NotificationsViewCell {
//            return cell.heightForRow
//        } else if let cell = currentRows[indexPath.row] as? ConnectionsViewCell {
//            return cell.heightForRow
//        }
        return CGFloat()
    }
}
