//
//  WorkoutView.swift
//  OneDot
//
//  Created by Александр Коробицын on 04.01.2025.
//

import Foundation
import UIKit
import MapKit

class BottomViewForSelectedWorkout: UIView {
    
    let mapView: MKMapView = {
        let view = MKMapView()
        view.disableAutoresizingMask()
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        mapView.delegate = self
        
        setViews()
        setConstraints()
    }
    
    private func setViews() {
        clipsToBounds = true
        
        addSubview(mapView)
        backgroundColor = .none
        
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension BottomViewForSelectedWorkout: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .myPaletteGold
        renderer.lineWidth = 5
        return renderer
    }
}
