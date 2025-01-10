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
        case checkLocation
        case drawWorkoutRoute(coordinates: [CLLocationCoordinate2D], scaleFactor: Double)
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
            
        case .checkLocation:
            checkLocationEnabled()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.delegate = self
        case .drawWorkoutRoute(let coordinates, let scaleFactor):
            MapKitManager.shared.drawMapPolyline(mapView: self, coordinates: coordinates)
            MapKitManager.shared.setMapRegion(mapView: self, coordinates: coordinates, scaleFactor: scaleFactor)
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                // Убираем стандартный пин, чтобы использовать кастомный
                return nil
            }
            
            return nil
        }
        
        // Метод для кастомного отображения пина
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            // Убираем старое кастомное аннотационное представление, если оно было
            if let existingView = mapView.view(for: userLocation) {
                mapView.removeAnnotation(existingView.annotation!)
            }
            
            // Создаём кастомный аннотационный вид
            let annotationView = MKAnnotationView(annotation: userLocation, reuseIdentifier: "userLocationPin")
            
            // Устанавливаем стандартный пин (который рисует система)
            annotationView.image = UIImage(systemName: "location.fill") // Можно использовать стандартный или свой пин
            
            // Добавляем цветной круг в центр пина
            let circleView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
            circleView.layer.cornerRadius = 8
            circleView.backgroundColor = .red // Здесь можно выбрать любой цвет
            annotationView.addSubview(circleView)
            
            // Центрируем круг в пине
            circleView.center = annotationView.center
            
            // Добавляем кастомное представление на карту
            mapView.addAnnotation(userLocation)
        }
}
