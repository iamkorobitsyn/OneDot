//
//  SettingsView.swift
//  OneDot
//
//  Created by Александр Коробицын on 22.11.2024.
//

import UIKit

class SettingsView: UIVisualEffectView {
    
    var buttonStateHandler: ((MainVC.Mode) -> Void)?
    
    enum Mode {
        case hide
    }
    
    private let tableView: UITableView = UITableView()
    
    private let hideButton: UIButton = UIButton()
  
    
    //MARK: - Init
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        setViews()
        setConstraint()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonPressed() {
        buttonStateHandler?(.settingsHide)
    }


    //MARK: - SetViews
    
    private func setViews() {
        effect = UIBlurEffect(style: UIBlurEffect.Style.light)
        clipsToBounds = true
        isHidden = true
        
        layer.cornerRadius = 30
        layer.cornerCurve = .continuous
        layer.borderWidth = 0.3
        layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        
        contentView.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        contentView.addSubview(hideButton)
        hideButton.setImage(UIImage(named: "SSHide"), for: .normal)
        hideButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)

    }
    
    private func setConstraint() {
        hideButton.disableAutoresizingMask()
        tableView.disableAutoresizingMask()
        
        
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            hideButton.widthAnchor.constraint(equalToConstant: .iconSide),
            hideButton.heightAnchor.constraint(equalToConstant: .iconSide),
            hideButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            hideButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
}

extension SettingsView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = SettingsViewCell()
            return cell
        case 1:
            let cell = SettingsViewCell()
            cell.activateMode(mode: .distanceSettings)
            return cell
        case 2:
            let cell = SettingsViewCell()
            cell.activateMode(mode: .autopauseSettings)
            return cell
        case 3:
            let cell = SettingsViewCell()
            cell.activateMode(mode: .countdownSettings)
            return cell
        case 4:
            let cell = SettingsViewCell()
            cell.activateMode(mode: .appleHealthSettings)
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            return 60
        case 1:
            return 100
        case 2:
            return 100
        case 3:
            return 140
        case 4:
            return 100
        default:
            return 0
        }
    }
    
    
}

