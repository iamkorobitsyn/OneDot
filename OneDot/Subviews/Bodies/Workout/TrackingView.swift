//
//  WorkoutView.swift
//  OneDot
//
//  Created by Александр Коробицын on 11.01.2025.
//

import Foundation
import UIKit

class TrackingView: UIVisualEffectView {
    
    let distanceTrackingView: DescriptionModule = {
        let module = DescriptionModule()
        module.disableAutoresizingMask()
        return module
    }()
    
    let paceTrackingView: DescriptionModule = {
        let module = DescriptionModule()
        module.disableAutoresizingMask()
        return module
    }()
    
    let caloriesTrackingView: DescriptionModule = {
        let view = DescriptionModule()
        view.disableAutoresizingMask()
        return view
    }()
    
    let heartrateTrackingView: DescriptionModule = {
        let view = DescriptionModule()
        view.disableAutoresizingMask()
        return view
    }()
    
    let crossSeparator: UIImageView = {
        let view = UIImageView()
        view.disableAutoresizingMask()
        view.image = UIImage(named: "crossSeparator")
        return view
    }()
    
    
    enum Mode {
        case prepare
        case hide
    }
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        setViews()
        setConstraints()
    }
    
    func activateMode(mode: Mode) {
        switch mode {
            
        case .prepare:
            isHidden = false
        case .hide:
            isHidden = true
        }
    }
    
    private func setViews() {
        effect = UIBlurEffect(style: .extraLight)
        clipsToBounds = true
        isHidden = true
        layer.instance(border: true, corner: .max)
        
        contentView.addSubview(distanceTrackingView)
        contentView.addSubview(paceTrackingView)
        contentView.addSubview(caloriesTrackingView)
        contentView.addSubview(heartrateTrackingView)
        contentView.addSubview(crossSeparator)
        
        distanceTrackingView.activateMode(axis: .vertical, mode: .distanceTracking, text: "122.95")
        paceTrackingView.activateMode(axis: .vertical, mode: .paceTracking, text: "12:45")
        caloriesTrackingView.activateMode(axis: .vertical, mode: .caloriesTracking, text: "123")
        heartrateTrackingView.activateMode(axis: .vertical, mode: .heartRateTracking, text: "147")
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            distanceTrackingView.widthAnchor.constraint(equalToConstant: 160),
            distanceTrackingView.heightAnchor.constraint(equalToConstant: 100),
            distanceTrackingView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 100),
            distanceTrackingView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -80),
            
            paceTrackingView.widthAnchor.constraint(equalToConstant: 160),
            paceTrackingView.heightAnchor.constraint(equalToConstant: 100),
            paceTrackingView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 100),
            paceTrackingView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 80),
            
            crossSeparator.widthAnchor.constraint(equalToConstant: 42),
            crossSeparator.heightAnchor.constraint(equalToConstant: 42),
            crossSeparator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            crossSeparator.topAnchor.constraint(equalTo: distanceTrackingView.bottomAnchor, constant: 22),
            
            caloriesTrackingView.widthAnchor.constraint(equalToConstant: 160),
            caloriesTrackingView.heightAnchor.constraint(equalToConstant: 100),
            caloriesTrackingView.topAnchor.constraint(equalTo: distanceTrackingView.bottomAnchor, constant: 80),
            caloriesTrackingView.centerXAnchor.constraint(equalTo: distanceTrackingView.centerXAnchor),
            
            heartrateTrackingView.widthAnchor.constraint(equalToConstant: 160),
            heartrateTrackingView.heightAnchor.constraint(equalToConstant: 100),
            heartrateTrackingView.topAnchor.constraint(equalTo: paceTrackingView.bottomAnchor, constant: 80),
            heartrateTrackingView.centerXAnchor.constraint(equalTo: paceTrackingView.centerXAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
