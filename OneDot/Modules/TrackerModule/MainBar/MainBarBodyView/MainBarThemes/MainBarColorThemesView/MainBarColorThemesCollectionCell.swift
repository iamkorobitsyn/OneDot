//
//  MainBarColorThemesCollectionCell.swift
//  OneDot
//
//  Created by Александр Коробицын on 11.11.2023.
//

import Foundation
import UIKit

class MainBarColorThemesCollectionCell: UICollectionViewCell {
    
    let title = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setConstraints()
    }
    
    private func setViews() {
        addSubview(title)
        title.textColor = .red
        title.font = UIFont.systemFont(ofSize: 20, weight: .black)
    }
    
    private func setConstraints() {
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
