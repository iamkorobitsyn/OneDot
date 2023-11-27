//
//  SoundVC.swift
//  OneDot
//
//  Created by Александр Коробицын on 27.11.2023.
//

import UIKit

class SoundVC: UIViewController {
    
    let titleee: UILabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        titleee.text = "SOUND"
        view.addSubview(titleee)
        titleee.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleee.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            titleee.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func updateColors(_ set: ColorSetProtocol) {
        
    }
    
}
