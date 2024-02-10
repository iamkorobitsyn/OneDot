//
//  SoundVC.swift
//  OneDot
//
//  Created by Александр Коробицын on 27.11.2023.
//

import UIKit

class SoundVC: UIViewController {
    
    let appleMusicCell = AppleMusicViewCell()

    private var currentRows: [UITableViewCell] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .none
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let hideBorder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 0.3
        view.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        view.layer.maskedCorners = [.layerMinXMaxYCorner]
        view.layer.cornerRadius = CGFloat.barCorner
        return view
    }()
    
    private enum CurrentSection {
        case appleMusic
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setConstraints()
    }
    
    //MARK: - SetViews
    
    private func setViews() {
        
        view.addSubview(tableView)
        tableView.addSubview(hideBorder)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setActiveSection(.appleMusic)
    }
    

    
    private func setActiveSection(_ section: CurrentSection) {
        switch section {
            
        case .appleMusic:
            currentRows.removeAll()
            currentRows.append(appleMusicCell)
            tableView.reloadData()
        }
    }
    
    private func setImage(_ button: UIButton, named: String) {
        button.setImage(UIImage(named: named), for: .normal)
        button.setImage(UIImage(named: named), for: .highlighted)
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            
            tableView.leadingAnchor.constraint(equalTo:
                                            view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo:
                                            view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo:
                                            view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo:
                                            view.bottomAnchor),
            
            hideBorder.widthAnchor.constraint(equalToConstant: 62.6),
            hideBorder.heightAnchor.constraint(equalToConstant: 62.6),
            hideBorder.topAnchor.constraint(equalTo: view.topAnchor,
                                            constant: -0.3),
            hideBorder.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                 constant: 0.3)
        ])
    }
}

extension SoundVC: UITableViewDelegate, UITableViewDataSource {
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
