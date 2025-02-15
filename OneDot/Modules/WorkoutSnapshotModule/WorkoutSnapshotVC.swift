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

class WorkoutSnapshotVC: UIViewController {
    
    let hapticGenerator = UISelectionFeedbackGenerator()

    var workoutData: WorkoutData?

    enum Mode {
        case initial
        case screenshot
        case back
        case hide
    }
    
    let gradientLayer: CAGradientLayer = CAGradientLayer()
    
    let resultHeader: SnapshotHeaderView = {
        let header = SnapshotHeaderView()
        header.disableAutoresizingMask()
        return header
    }()
    
    let mapView: MKMapView = {
        let view = MKMapView()
        view.disableAutoresizingMask()
        return view
    }()
    
    let logoView: UIImageView = {
        let view = UIImageView()
        view.disableAutoresizingMask()
        return view
    }()
    
    let bottleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.disableAutoresizingMask()
        imageView.image = UIImage(named: "bottleImage")
        return imageView
    }()
    
    let dumbbellImage: UIImageView = {
        let imageView = UIImageView()
        imageView.disableAutoresizingMask()
        imageView.image = UIImage(named: "dumbbellImage")
        return imageView
    }()

    
    private let backButton: UIButton = {
        let button = UIButton()
        button.disableAutoresizingMask()
        button.setImage(UIImage(named: "BodyBack"), for: .normal)
        return button
    }()
    
    private let hideButton: UIButton = {
        let button = UIButton()
        button.disableAutoresizingMask()
        button.setImage(UIImage(named: "BodyHide"), for: .normal)
        return button
    }()
    
    private let screenshotButton: UIButton = {
        let button = UIButton()
        button.disableAutoresizingMask()
        button.setImage(UIImage(named: "FooterScreenshot"), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setViews()
        activateMode(mode: .initial)
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }

    
    private func activateMode(mode: Mode) {
        
        switch mode {
        case .initial:
            if let workoutData = workoutData {
                
                resultHeader.workoutData = workoutData
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
                        resultHeader.climbValue = climbing
                        resultHeader.locationIconName = "AMOutdoorLocGold25x25"
                        
                        
                        gradientLayer.isHidden = true
                        bottleImage.isHidden = true
                        dumbbellImage.isHidden = true
                        logoView.image = UIImage(named: "workoutScreenLogoOrangeGray")
                        resultHeader.activate(locationOutdoor: true)
                    } catch {
                        
                        resultHeader.locationIconName = "AMIndoorLocGold25x25"
                        logoView.image = UIImage(named: "workoutScreenLogoOrangeWhite")
                        resultHeader.activate(locationOutdoor: false)
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

        view.addSubview(mapView)
        view.layer.addSublayer(gradientLayer)
        view.addSubview(logoView)
        view.addSubview(bottleImage)
        view.addSubview(dumbbellImage)
        view.addSubview(resultHeader)
        view.addSubview(backButton)
        view.addSubview(hideButton)
        view.addSubview(screenshotButton)

        [backButton, hideButton, screenshotButton].forEach { button in
            button.addTarget(self, action: #selector(buttonTapped(_: )), for: .touchUpInside)
        }
        
        gradientLayer.locations = [0.0, 0.4]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.myPaletteBlue.cgColor]

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
            
            resultHeader.heightAnchor.constraint(equalToConstant: 210),
            resultHeader.widthAnchor.constraint(equalToConstant: .barWidth),
            resultHeader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultHeader.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            
            bottleImage.widthAnchor.constraint(equalToConstant: 60),
            bottleImage.heightAnchor.constraint(equalToConstant: 60),
            bottleImage.bottomAnchor.constraint(equalTo: resultHeader.topAnchor),
            bottleImage.leadingAnchor.constraint(equalTo: resultHeader.leadingAnchor, constant: 50),
            
            dumbbellImage.widthAnchor.constraint(equalToConstant: 60),
            dumbbellImage.heightAnchor.constraint(equalToConstant: 60),
            dumbbellImage.bottomAnchor.constraint(equalTo: resultHeader.topAnchor, constant: 17.5),
            dumbbellImage.trailingAnchor.constraint(equalTo: resultHeader.trailingAnchor),
            
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

extension WorkoutSnapshotVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .myPaletteGold
        renderer.lineWidth = 5
        return renderer
    }
}


