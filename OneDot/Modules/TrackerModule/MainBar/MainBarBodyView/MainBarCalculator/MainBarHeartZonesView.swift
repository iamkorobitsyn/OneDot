//
//  MainBarHeartZonesView.swift
//  OneDot
//
//  Created by Александр Коробицын on 06.11.2023.
//

import Foundation
import UIKit

class MainBarHeartZonesView: UIView {
    
    let title: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(title)
        title.font = UIFont.systemFont(ofSize: 30, weight: .black)
        title.text = "Heart Zones"
        title.textColor = .lightGray
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            title.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
