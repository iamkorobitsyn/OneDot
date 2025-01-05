//
//  MapView.swift
//  OneDot
//
//  Created by Александр Коробицын on 06.01.2025.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class MapView: MKMapView {
    
    let locationManager: CLLocationManager = CLLocationManager()
    
    weak var viewController: UIViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        
        self.overrideUserInterfaceStyle = .light
        checkLocationEnabled()
    }
    
    //MARK: - CheckLocation
    
    private func checkLocationEnabled() {
        Task { locationManager.startUpdatingLocation()
            if try await MapKitManager.shared.checkLocationServicesEnabled(viewController: viewController, mapView: self) {
               self.showsUserLocation = true } }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MapView: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 500, longitudinalMeters: 500)
            self.setRegion(region, animated: true)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationEnabled()
    }
}
