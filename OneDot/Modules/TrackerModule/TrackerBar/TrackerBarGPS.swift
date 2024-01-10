//
//  gpsView.swift
//  OneDot
//
//  Created by Александр Коробицын on 26.09.2023.
//

import Foundation
import UIKit

class TrackerBarGPS: UIView {

    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.text = "GPS"
        label.font = UIFont.systemFont(ofSize: 6, weight: .medium)
        return label
    }()
    
    let satelliteIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "additionalGPSCursorIconGreen")
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setConstraints()
    }
    
    
    //MARK: - SetViews
    
    private func setViews() {
        addSubview(satelliteIcon)
        addSubview(label)
    }
    
 
    //MARK: - SetConstraints
    
    private func setConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        satelliteIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            label.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 11),
            label.centerXAnchor.constraint(equalTo: satelliteIcon.centerXAnchor),
            
            satelliteIcon.widthAnchor.constraint(equalToConstant: 12),
            satelliteIcon.heightAnchor.constraint(equalToConstant: 12),
            satelliteIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
            satelliteIcon.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
