//
//  SettingsViewController.swift
//  OneDot
//
//  Created by Александр Коробицын on 28.09.2023.
//

import UIKit

class SettingsVC: UIViewController {
    
    enum SettingRow {
        case measuring, 
             notifications,
             integrations,
             links
    }
    
    private let settingsRows: [SettingRow] = [.measuring,
                                              .notifications,
                                              .integrations,
                                              .links]

    
    private let separator: CAShapeLayer = CAShapeLayer()
    private let tableView: UITableView = UITableView()
    private let visualView: UIVisualEffectView = UIVisualEffectView()
    private let dismissButton: UIButton = UIButton()
    
    //MARK: - Metrics
    
    let settingsModuleWidth: CGFloat = UIScreen.main.bounds.width / 1.05
    let measuringViewHeight: CGFloat = 380
    let notificationsViewHeight: CGFloat = 280
    let integrationsViewHeight: CGFloat = 300
    let colorThemesViewHeight: CGFloat = 420
    let linksViewHeight: CGFloat = 150

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setTableView()
        setConstraints()
    }
    
    //MARK: - SetTableView
    
    private func setTableView() {
        visualView.contentView.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, 
                           forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .none
        tableView.separatorStyle = .none
    }

    
    //MARK: - SetViews
    
    private func setViews() {
          
        view.backgroundColor = .none
        view.addSubview(visualView)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        visualView.effect = blurEffect
        visualView.backgroundColor = .specialBeigeColor.withAlphaComponent(0.5)
        visualView.layer.cornerRadius = 30
        visualView.layer.cornerCurve = .continuous
        visualView.clipsToBounds = true
        
        visualView.contentView.addSubview(dismissButton)
        dismissButton.setImage(UIImage(named: "hideDownShevronIconGray"),
                            for: .normal)
        dismissButton.setImage(UIImage(named: "hideDownShevronIconGray"),
                            for: .highlighted)
        dismissButton.layer.cornerRadius = .mainIconSide / 2
        dismissButton.backgroundColor = .clear
        dismissButton.layer.borderWidth = 1
        dismissButton.layer.borderColor = UIColor.gray.cgColor
        dismissButton.addTarget(self,
                             action: #selector(selfDismiss),
                             for: .touchUpInside)
        
        Shaper.shared.drawCenterXSeparator(shape: separator,
                                                     view: visualView.contentView,
                                                     xMove: -50,
                                                     xAdd: 50,
                                                     y: 62,
                                                      lineWidth: 1,
                                                      color: .gray)
    }
    
    @objc private func selfDismiss() {
        self.dismiss(animated: true)
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        
        visualView.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            visualView.topAnchor.constraint(equalTo:
                                            view.topAnchor),
            visualView.trailingAnchor.constraint(equalTo:
                                            view.trailingAnchor),
            visualView.bottomAnchor.constraint(equalTo: 
                                            view.bottomAnchor),
            visualView.leadingAnchor.constraint(equalTo:
                                            view.leadingAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: 
                                            view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo:
                                            view.topAnchor, constant: 62),
            tableView.trailingAnchor.constraint(equalTo:
                                            view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo:
                                            view.bottomAnchor),
            
            dismissButton.topAnchor.constraint(equalTo: 
                                            view.topAnchor,
                                            constant: 20),
            dismissButton.trailingAnchor.constraint(equalTo:
                                            view.trailingAnchor, constant: -20)
        ])
    }
}

     //MARK: - TableViewDataSourse&TableViewDelegate

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        settingsRows.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch settingsRows[indexPath.row] {
        case .measuring:
            return MeasuringSettingsViewCell()
        case .notifications:
            return NotificationsSettingsViewCell()
        case .integrations:
            return IntegrationsViewCell()
        case .links:
            return LinksViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch settingsRows[indexPath.row] {
            
        case .measuring:
            return measuringViewHeight
        case .notifications:
            return notificationsViewHeight
        case .integrations:
            return integrationsViewHeight
        case .links:
            return linksViewHeight
        }
    }
}
