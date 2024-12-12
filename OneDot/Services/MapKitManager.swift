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
    
    //MARK: - MainVC
    
    func checkLocationServicesEnabled(viewController: UIViewController, mapView: MKMapView) async throws -> Bool {
        
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
    
    //MARK: - DetailsVC
    
    func drawMapPolyline(mapView: MKMapView, coordinates: [CLLocationCoordinate2D]) {
        
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)
        
    }
    
    func setMapRegion(mapView: MKMapView, coordinates: [CLLocationCoordinate2D], scaleFactor: Double) {

        var minLatitude: Double = coordinates[0].latitude
        var maxLatitude: Double = coordinates[0].latitude
        
        var minLongitude: Double = coordinates[0].longitude
        var maxLongitude: Double = coordinates[0].longitude
        
        
        for i in 0..<coordinates.count {
            if coordinates[i].latitude < minLatitude {
                minLatitude = coordinates[i].latitude
            } else if coordinates[i].latitude > maxLatitude {
                maxLatitude = coordinates[i].latitude
            }
            
            if coordinates[i].longitude < minLongitude {
                minLongitude = coordinates[i].longitude
            } else if coordinates[i].longitude > maxLongitude {
                maxLongitude = coordinates[i].longitude
            }
        }

        // MARK: - SetSpan
        
        let latitudeDelta = (maxLatitude - minLatitude) * scaleFactor
        let longitudeDelta = (maxLongitude - minLongitude) * scaleFactor
        
        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta,
                                    longitudeDelta: longitudeDelta)
        
        // MARK: - SetCenter
        
        let centerLatitude = (minLatitude + maxLatitude) * 0.5
        let centerLongitude = (minLongitude + maxLongitude) * 0.5
        
        let center = CLLocationCoordinate2D(latitude: centerLatitude,
                                            longitude: centerLongitude)
        
        // MARK: - SetRegion
        
        
        let region = MKCoordinateRegion(center: center, span: span)
        
        mapView.setRegion(region, animated: true)
    }
    
}
