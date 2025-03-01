//
//  WorkoutDetailsVC.swift
//  OneDot
//
//  Created by Александр Коробицын on 07.12.2024.
//

import Foundation
import UIKit
import Photos
import MapKit

class SnapshotVC: UIViewController {
    
    private let hapticGenerator = UISelectionFeedbackGenerator()

    var workoutData: WorkoutData?

    private enum Mode {
        case initial
        case screenshot
        case back
        case hide
    }
    
    private let gradientLayer: CAGradientLayer = CAGradientLayer()
    
    private let mapView: MKMapView = MKMapView()
    private let valueBar: ValueBarView = ValueBarView()
    
    private let bottleImage: UIImageView = UIImageView()
    private let dumbbellImage: UIImageView = UIImageView()
    private let logoView: UIImageView = UIImageView()
    
    private let backButton: UIButton = UIButton()
    private let hideButton: UIButton = UIButton()
    private let screenshotButton: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setViews()
        setConstraints()
        activateMode(mode: .initial)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    private func activateMode(mode: Mode) {
        
        switch mode {
        case .initial:
            if let workoutData = workoutData {
                
                valueBar.workoutData = workoutData
                Task {
                    do {
                        let locations = try await HealthKitManager.shared.getRoute(workout: workoutData)
                        
                        var coordinates: [CLLocationCoordinate2D] = []
                        locations.forEach { location in
                            coordinates.append(location.coordinate)
                        }
                        
                        LocationService.shared.drawMapPolyline(mapView: mapView, coordinates: coordinates)
                        LocationService.shared.setMapRegion(mapView: mapView, coordinates: coordinates, scaleFactor: 2.5)

                        let currentPoint = mapView.convert(mapView.centerCoordinate, toPointTo: mapView)
                        let newPoint = CGPoint(x: currentPoint.x, y: currentPoint.y - 100)
                        let newCenter = mapView.convert(newPoint, toCoordinateFrom: mapView)
                        mapView.setCenter(newCenter, animated: false)
                        
                        let climbing = try await HealthKitManager.shared.getClimbing(locations: locations)
                        valueBar.climbValue = climbing
                        valueBar.locationIconName = "AMOutdoorLocGold25x25"
                        
                        bottleImage.isHidden = true
                        dumbbellImage.isHidden = true
                        logoView.image = UIImage(named: "workoutScreenLogoOrangeGray")
                        valueBar.activate(locationOutdoor: true)
                    } catch {
                        
                        mapView.isHidden = true
                        valueBar.locationIconName = "AMIndoorLocGold25x25"
                        logoView.image = UIImage(named: "workoutScreenLogoOrangeWhite")
                        valueBar.activate(locationOutdoor: false)
                    }
                    
                }
            }
             
        case .screenshot:
            hapticGenerator.selectionChanged()
            SnapshotService.shared.makeScreenShot(hiddenViews: [backButton, hideButton, screenshotButton], viewController: self)
        case .back:
            navigationController?.popViewController(animated: true)
        case .hide:
            self.dismiss(animated: true)
        }
    }
    
    
    //MARK: - ButtonTapped
    
    @objc private func buttonTapped(_ button: UIButton) {
        
        switch button {
        case backButton:
            activateMode(mode: .back)
        case hideButton:
            activateMode(mode: .hide)
        case screenshotButton:
            activateMode(mode: .screenshot)
        default:
            break
        }
    }

    
    //MARK: - SetViews
    
    private func setViews() {
        view.layer.addSublayer(gradientLayer)
        gradientLayer.locations = [0.0, 0.4]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.myPaletteBlue.cgColor]
        
        [mapView, valueBar, bottleImage, dumbbellImage, logoView, backButton, hideButton, screenshotButton].forEach { view in
            self.view.addSubview(view)
            view.disableAutoresizingMask()
        }
        
        bottleImage.image = UIImage(named: "bottleImage")
        dumbbellImage.image = UIImage(named: "dumbbellImage")
        
        backButton.setImage(UIImage(named: "BodyBack"), for: .normal)
        hideButton.setImage(UIImage(named: "BodyHide"), for: .normal)
        screenshotButton.setImage(UIImage(named: "FooterScreenshot"), for: .normal)
        
        [backButton, hideButton, screenshotButton].forEach { button in
            button.addTarget(self, action: #selector(buttonTapped(_: )), for: .touchUpInside)
        }
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 100),
            mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            logoView.widthAnchor.constraint(equalToConstant: 80),
            logoView.heightAnchor.constraint(equalToConstant: 40),
            logoView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70),
            logoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
          
            screenshotButton.widthAnchor.constraint(equalToConstant: 42),
            screenshotButton.heightAnchor.constraint(equalToConstant: 42),
            screenshotButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            screenshotButton.centerYAnchor.constraint(equalTo: logoView.centerYAnchor),
            
            valueBar.heightAnchor.constraint(equalToConstant: 210),
            valueBar.widthAnchor.constraint(equalToConstant: .barWidth),
            valueBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            valueBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            
            bottleImage.widthAnchor.constraint(equalToConstant: 60),
            bottleImage.heightAnchor.constraint(equalToConstant: 60),
            bottleImage.bottomAnchor.constraint(equalTo: valueBar.topAnchor),
            bottleImage.leadingAnchor.constraint(equalTo: valueBar.leadingAnchor, constant: 70),
            
            dumbbellImage.widthAnchor.constraint(equalToConstant: 60),
            dumbbellImage.heightAnchor.constraint(equalToConstant: 60),
            dumbbellImage.bottomAnchor.constraint(equalTo: valueBar.topAnchor, constant: 15.5),
            dumbbellImage.trailingAnchor.constraint(equalTo: valueBar.trailingAnchor, constant: -40),
            
            backButton.widthAnchor.constraint(equalToConstant: 42),
            backButton.heightAnchor.constraint(equalToConstant: 42),
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            hideButton.widthAnchor.constraint(equalToConstant: 42),
            hideButton.heightAnchor.constraint(equalToConstant: 42),
            hideButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            hideButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }
    
  
}

extension SnapshotVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .myPaletteGold
        renderer.lineWidth = 5
        return renderer
    }
}


