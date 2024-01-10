//
//  CalculatorViewController.swift
//  OneDot
//
//  Created by Александр Коробицын on 26.11.2023.
//

import UIKit

class CalculatorVC: UIViewController {
    
    let titleee: UILabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .blue.withAlphaComponent(0.2)
//        titleee.text = "CALCULATOR"
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
