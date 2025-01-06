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
    
    enum Mode {
        case checkLocationClose
        case checkLocationFar
        case drawWorkoutRoute
    }
    
    var closeLocation = true
    
    let locationManager: CLLocationManager = CLLocationManager()
    
    weak var viewController: UIViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        self.overrideUserInterfaceStyle = .light
    }
    
    func activateMode(mode: Mode) {
        switch mode {
            
        case .checkLocationClose:
            checkLocationEnabled()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.delegate = self
        case .checkLocationFar:
            closeLocation.toggle()
            checkLocationEnabled()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.delegate = self
        case .drawWorkoutRoute:
            print("route")
        }
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
            if closeLocation {
                let region = MKCoordinateRegion(center: location, latitudinalMeters: 500, longitudinalMeters: 500)
                self.setRegion(region, animated: true)
            } else {
                let region = MKCoordinateRegion(center: location, latitudinalMeters: 4000, longitudinalMeters: 4000)
                self.setRegion(region, animated: true)
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationEnabled()
    }
}

extension MapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .myPaletteGold
        renderer.lineWidth = 5
        return renderer
    }
}
