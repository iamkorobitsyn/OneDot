//
//  MapKitHelper.swift
//  OneDot
//
//  Created by Александр Коробицын on 12.12.2024.
//

import Foundation
import MapKit
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationService()
    
    private let locationManager: CLLocationManager = CLLocationManager()
    
    private var lastLocation: CLLocation?
    private var totalDistance: Double = 0.0
    var didUpdateDistance: ((Double) -> Void)?
    var didUpdateRegion: ((MKCoordinateRegion) -> Void)?
    var didUpdateHightAccuracy: ((LocationTrackingState) -> Void)?
    
    enum LocationTrackingState {
        case goodSignal
        case poorSignal
        case locationDisabled
    }
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 7
    }
    
    func startTracking() {
        locationManager.startUpdatingLocation()
        print("start tracking")
    }
    
    func stopTracking() {
        locationManager.stopUpdatingLocation()
        print("stop tracking")
    }
    
    func requestAuthorization() async  {
        
        let globalRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 180))
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .authorizedAlways, .authorizedWhenInUse :
            startTracking()
            await MainActor.run { didUpdateHightAccuracy?(.poorSignal)}
        case .denied:
            await MainActor.run {
                didUpdateHightAccuracy?(.locationDisabled)
                didUpdateRegion?(globalRegion)
            }
        default:
            await MainActor.run {
                didUpdateHightAccuracy?(.locationDisabled)
                didUpdateRegion?(globalRegion)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else {return}
        
        let region = MKCoordinateRegion(center: currentLocation.coordinate, latitudinalMeters: 4000, longitudinalMeters: 4000)
        didUpdateRegion?(region)
        
        let accuracy = currentLocation.horizontalAccuracy
        accuracy < 20 ? didUpdateHightAccuracy?(.goodSignal) : didUpdateHightAccuracy?(.poorSignal)

        
        if let lastLocation = lastLocation {
            let distance = lastLocation.distance(from: currentLocation)
            totalDistance += distance
            didUpdateDistance?(totalDistance)
        }
        
        lastLocation = currentLocation
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager)  {
        Task { await requestAuthorization() }
    }

    
    //MARK: - WorkoutFocus
    
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
        
        let centerLatitude = (minLatitude + ((maxLatitude - minLatitude) / 2))
        let centerLongitude = (minLongitude + ((maxLongitude - minLongitude) / 2))
        
        let center = CLLocationCoordinate2D(latitude: centerLatitude + 0.003,
                                            longitude: centerLongitude)
        
        // MARK: - SetRegion
        
        
        let region = MKCoordinateRegion(center: center, span: span)
        
        mapView.setRegion(region, animated: false)
    }
    
}
