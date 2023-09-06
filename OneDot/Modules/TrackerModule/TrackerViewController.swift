//
//  ViewController.swift
//  OneDot
//
//  Created by Александр Коробицын on 08.07.2023.
//

import UIKit
import MapKit

class TrackerViewController: UIViewController {
    
    
    let mapView: MKMapView = MKMapView()
    let locationManager: CLLocationManager = CLLocationManager()
    
    let alert: UIAlertController = AlertController(title: "1", message: "1", url: "1")

    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
        present(alert, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkLocationEnabled()
    }
    
    private func checkLocationEnabled() {
        
        let queue = DispatchQueue.global(qos: .userInitiated)
        
        queue.async {
            if CLLocationManager.locationServicesEnabled() {
                
                DispatchQueue.main.async {
                    self.setupLocationManager()
                    self.checkAuthorization()
                }
            } else {
                print("test")
            }
        }
         
    }
    
    private func setupLocationManager() {
        
    }
    
    private func checkAuthorization() {
        
    }


}

extension TrackerViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
}

extension TrackerViewController {
    private func setConstraints() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
}

