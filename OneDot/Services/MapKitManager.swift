//
//  MapKitHelper.swift
//  OneDot
//
//  Created by Александр Коробицын on 12.12.2024.
//

import Foundation
import MapKit

class MapKitManager {
    
    static let shared = MapKitManager()
    
    let locationManager: CLLocationManager = CLLocationManager()
    
    private init() {}
    
    func checkLocationServicesEnabled(viewController: UIViewController, maoView: MKMapView) async throws -> Bool {
        
        if CLLocationManager.locationServicesEnabled() {
            
            switch locationManager.authorizationStatus {
            
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                return true
            case .denied:
                await viewController.present(Alert(title: "Вы запретили использование местоположения",
                                       message: "Разрешить?",
                                       style: .actionSheet,
                                       url: UIApplication.openSettingsURLString),
                                 animated: true)
            case .authorizedAlways:
                break
            case .authorizedWhenInUse:
                return true
            @unknown default:
                break
            }
        } else {
            await viewController.present(Alert(title: "У вас выключена служба геолокации",
                                   message: "Включить?",
                                   style: .actionSheet,
                                   url: "App-Prefs:root=LOCATION_SEVICES"),
                             animated: true)
            return false
        }
        return false
    }
    
}
