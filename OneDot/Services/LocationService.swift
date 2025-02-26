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
    
    var recording: Bool = false
    
    private let locationManager: CLLocationManager = CLLocationManager()
    private var lastLocation: CLLocation?
    
    lazy var totalDistance: Double = 0.0
    lazy var locations: [CLLocation] = []
    
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
        locationManager.distanceFilter = 5.0
    }
    
    func clearValues() {
        recording = false
        totalDistance = 0.0
        locations = []
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

        if recording {
            
            self.locations.append(currentLocation)
            if let lastLocation = lastLocation {
                let distance = lastLocation.distance(from: currentLocation)
                totalDistance += distance
            }
            
            lastLocation = currentLocation
        }
        
        let region = MKCoordinateRegion(center: currentLocation.coordinate, latitudinalMeters: 4000, longitudinalMeters: 4000)
        didUpdateRegion?(region)
        
        let accuracy = currentLocation.horizontalAccuracy
        accuracy < 20 ? didUpdateHightAccuracy?(.goodSignal) : didUpdateHightAccuracy?(.poorSignal)

        
        
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
        
        let minLatitude: Double = coordinates.map { $0.latitude } .min() ?? 0
        let maxLatitude: Double = coordinates.map { $0.latitude } .max() ?? 0
        let minLongitude: Double = coordinates.map { $0.longitude } .min() ?? 0
        let maxLongitude: Double = coordinates.map { $0.longitude } .max() ?? 0
        
        let latitudeDelta = (maxLatitude - minLatitude) * scaleFactor
        let longitudeDelta = (maxLongitude - minLongitude) * scaleFactor
        
        let centerLatitude = (minLatitude + ((maxLatitude - minLatitude) / 2))
        let centerLongitude = (minLongitude + ((maxLongitude - minLongitude) / 2))
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude),
                                        span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta))
        
        mapView.setRegion(region, animated: false)
    }
    
}
