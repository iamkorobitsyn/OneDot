//
//  ProfileViewController.swift
//  OneDot
//
//  Created by Александр Коробицын on 08.07.2023.
//

import UIKit

class ProfileVC: UIViewController {
    

    private let blurEffectView: UIVisualEffectView = {
        let effect = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        effect.disableAutoresizingMask()
        effect.layer.masksToBounds = true
        effect.layer.cornerRadius = .barCorner
        return effect
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.disableAutoresizingMask()
        button.setImage(UIImage(named: "additionalHideIcon"), for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        setConstraints()
    }
    
    @objc private func dismissProfile() {
        dismiss(animated: true)
    }
    
    //MARK: - SetViews
    
    private func setViews() {
        view.addSubview(blurEffectView)
        
        view.addSubview(dismissButton)
        
        dismissButton.addTarget(self, action: #selector(dismissProfile), for: .touchUpInside)
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            dismissButton.widthAnchor.constraint(equalToConstant: .iconSide),
            dismissButton.heightAnchor.constraint(equalToConstant: .iconSide),
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }
}
