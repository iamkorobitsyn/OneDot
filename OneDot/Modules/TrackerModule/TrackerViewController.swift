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
    let activitySelectionView: UIView = ActivitiesMenu()

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setConstraints()
        setupLocationManager()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkLocationEnabled()
    }
    
 
    
    //MARK: - LocationManager&Authorization
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func checkLocationEnabled() {
        
        let queue = DispatchQueue.global(qos: .userInitiated)
        
        queue.async {
            if CLLocationManager.locationServicesEnabled() {
                
                DispatchQueue.main.async {
                    self.checkAuthorization()
                }
            } else {
                DispatchQueue.main.async {
                    self.present(Alert(title: "У вас выключена служба геолокации",
                                       message: "Включить?",
                                       style: .actionSheet,
                                       url: "App-Prefs:root=LOCATION_SEVICES"),
                                 animated: true)
                }
            }
        }
         
    }
    
    private func checkAuthorization() {
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
            self.present(Alert(title: "Вы запретили использование местоположения",
                               message: "Разрешить?",
                               style: .actionSheet,
                               url: UIApplication.openSettingsURLString),
                         animated: true)
        case .authorizedAlways:
                break
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }


}


//MARK: - CLLocationManagerDelegate

extension TrackerViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate {
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: 500,
                                            longitudinalMeters: 500)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationEnabled()
    }
    
}

extension TrackerViewController {
    
    //MARK: - SetViews
    
    private func setViews() {
        view.addSubview(mapView)
        setMapGradient()
        view.layer.insertSublayer(activitySelectionView.layer, at: .max)
       
        mapView.translatesAutoresizingMaskIntoConstraints = false
        activitySelectionView.translatesAutoresizingMaskIntoConstraints = false
        
        mapView.overrideUserInterfaceStyle = .light
        view.backgroundColor = UIColor.customBlueMid
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            activitySelectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activitySelectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activitySelectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            activitySelectionView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    //MARK: - SetMapGradient
    
    private func setMapGradient() {
        let topGradient = CAGradientLayer()
        let bottomGradient = CAGradientLayer()
        
        topGradient.frame = CGRect(x: 0,
                                   y: 0,
                                   width: view.frame.width,
                                   height: view.frame.height)
        bottomGradient.frame = CGRect(x: 0,
                                   y: 0,
                                   width: view.frame.width,
                                   height: view.frame.height)
        
        
        
        topGradient.startPoint = CGPoint(x: 0, y: 0.2)
        topGradient.endPoint = CGPoint(x: 0, y: 0.5)
        topGradient.colors = [UIColor.customBlueMid.cgColor,
                              UIColor.customBlueMid.withAlphaComponent(0).cgColor]
        
        
        bottomGradient.startPoint = CGPoint(x: 0, y: 0.8)
        bottomGradient.endPoint = CGPoint(x: 0, y: 0.55)
        bottomGradient.colors = [UIColor.customBlueMid.cgColor,
                                 UIColor.customBlueMid.withAlphaComponent(0).cgColor]
        
        
        view.layer.insertSublayer(topGradient, at: .max)
        view.layer.insertSublayer(bottomGradient, at: .max)

    }
}

