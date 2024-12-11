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

class WorkoutDetailsVC: UIViewController {
    
    let hapticGenerator = UISelectionFeedbackGenerator()
    
    let mapView: MKMapView = MKMapView()
    let zoomButton: UIButton = UIButton()
    let decreaseButton: UIButton = UIButton()
    
    var coordinates: [CLLocationCoordinate2D] = []
    var defaultSpan: Double = 1.7
    var defaultRegion: MKCoordinateRegion = MKCoordinateRegion()

    enum ZoomState {
        case zero, zoom, decrease
    }
    var state = ZoomState.zero
    
    let backView: UIView = {
        let view = UIView()
        view.disableAutoresizingMask()
        view.backgroundColor = .myPaletteWhiteBackground
        view.layer.cornerRadius = .barCorner
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.disableAutoresizingMask()
        button.setImage(UIImage(named: "DSBackGray"), for: .normal)
        return button
    }()
    
    private let hideButton: UIButton = {
        let button = UIButton()
        button.disableAutoresizingMask()
        button.setImage(UIImage(named: "DSHideGray"), for: .normal)
        return button
    }()
    
    private let screenShotButton: UIButton = {
        let button = UIButton()
        button.disableAutoresizingMask()
        button.setImage(UIImage(named: "DSScreenshotGray"), for: .normal)
        return button
    }()
    
    private let settingsButton: UIButton = {
        let button = UIButton()
        button.disableAutoresizingMask()
        button.setImage(UIImage(named: "DSSettingsGray"), for: .normal)
        return button
    }()
    
    private let appearanceButton: UIButton = {
        let button = UIButton()
        button.disableAutoresizingMask()
        button.setImage(UIImage(named: "DSAppearanceGray"), for: .normal)
        return button
    }()
    
    private let testLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.text = "TEST SCREENSHOT"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMapView()
        setConstraintsMap()
        setViews()
        setConstraints()
        
        
        
        setButtons()
        setExampleCoordinates()
        setPolyline()
        setRegion(coordinates: coordinates)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: - MapView
    
    private func setMapView() {
        mapView.delegate = self
        mapView.isScrollEnabled = false
        mapView.isZoomEnabled = false
        mapView.isRotateEnabled = false
    }
    
    func setExampleCoordinates() {
        coordinates = [
            CLLocationCoordinate2D(latitude: 55.899390,
                                   longitude: 37.278832),
            CLLocationCoordinate2D(latitude: 55.900521,
                                   longitude: 37.280463),
            CLLocationCoordinate2D(latitude: 55.901531,
                                   longitude: 37.281836),
            CLLocationCoordinate2D(latitude: 55.902662,
                                   longitude: 37.283553),
            CLLocationCoordinate2D(latitude: 55.903336,
                                   longitude: 37.285527),
            CLLocationCoordinate2D(latitude: 55.903588,
                                   longitude: 37.286975),
            CLLocationCoordinate2D(latitude: 55.903642,
                                   longitude: 37.287887),
            CLLocationCoordinate2D(latitude: 55.903738,
                                   longitude: 37.288703),
            CLLocationCoordinate2D(latitude: 55.903816,
                                   longitude: 37.289454),
            CLLocationCoordinate2D(latitude: 55.903925,
                                   longitude: 37.290055),
            CLLocationCoordinate2D(latitude: 55.904069,
                                   longitude: 37.290698),
            CLLocationCoordinate2D(latitude: 55.904273,
                                   longitude: 37.291439),
            CLLocationCoordinate2D(latitude: 55.904484,
                                   longitude: 37.292361),
            CLLocationCoordinate2D(latitude: 55.904658,
                                   longitude: 37.293145)
        ]
    }
    
    private func setPolyline() {
        
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)
        
    }
    
    private func setRegion(coordinates: [CLLocationCoordinate2D]) {
        
        
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
        
        let latitudeDelta = (maxLatitude - minLatitude) * defaultSpan
        let longitudeDelta = (maxLongitude - minLongitude) * defaultSpan
        
        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta,
                                    longitudeDelta: longitudeDelta)
        
        // MARK: - SetCenter
        
        let centerLatitude = (minLatitude + maxLatitude) * 0.5
        let centerLongitude = (minLongitude + maxLongitude) * 0.5
        
        let center = CLLocationCoordinate2D(latitude: centerLatitude,
                                            longitude: centerLongitude)
        
        // MARK: - SetRegion
        
        
        defaultRegion = MKCoordinateRegion(center: center, span: span)
        
        self.mapView.setRegion(defaultRegion, animated: true)
    }
    
    
    
    //MARK: - ButtonTapped
    
    @objc private func buttonTapped(_ button: UIButton) {
        hapticGenerator.selectionChanged()
        
        switch button {
        case backButton:
            print("work")
            navigationController?.popViewController(animated: true)
            backButton.isHidden = true
            
        case hideButton:
            self.dismiss(animated: true)
            
        case screenShotButton:
            let screensot = makeScreenShot()
            saveScreenshotToGallery(image: screensot)
            addScreenshotEffect()
        default:
            break
        }
    }
    
    //MARK: - SetScreenshot
    
    private func makeScreenShot() -> UIImage {
        backView.layer.cornerRadius = 0
        [backButton, hideButton, screenShotButton, settingsButton, appearanceButton].forEach( {$0.isHidden = true} )
        
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        
        let screenshot = renderer.image { context in
            view.layer.render(in: context.cgContext)
        }
        
        backView.layer.cornerRadius = .barCorner
        [backButton, hideButton, screenShotButton, settingsButton, appearanceButton].forEach( {$0.isHidden = false} )
        
        return screenshot
    }
    
    private func saveScreenshotToGallery(image: UIImage) {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }) { success, error in
                    if success {
                        print("Скриншот сохранен в галерее.")
                    } else if let error = error {
                        print("Ошибка при сохранении скриншота: \(error.localizedDescription)")
                    }
                }
            } else {
                print("Нет доступа к фотогалерее.")
        }
        }
    }
    
    private func addScreenshotEffect() {
        
        let flashView = UIView()
        flashView.frame = view.bounds
        flashView.backgroundColor = .white
        view.addSubview(flashView)
        
        let alert = UIAlertController(title: nil,
                                      message: "\nSaved to gallery\n\n",
                                      preferredStyle: .actionSheet)
        
        UIView.animate(withDuration: 0.2) {
            flashView.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 1) {
                self.present(alert, animated: true)
                flashView.alpha = 0
            } completion: { _ in
                flashView.removeFromSuperview()
                alert.dismiss(animated: true)
            }
        }
    }
    
    //MARK: - SetViews
    
    private func setViews() {
        view.addSubview(backView)
        view.addSubview(testLabel)
        
        backView.alpha = 0
        
        [backButton, hideButton, screenShotButton, settingsButton, appearanceButton].forEach { button in
            mapView.addSubview(button)
            button.addTarget(self, action: #selector(buttonTapped(_: )), for: .touchUpInside)
        }
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: view.topAnchor),
            backView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            backButton.widthAnchor.constraint(equalToConstant: 42),
            backButton.heightAnchor.constraint(equalToConstant: 42),
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            hideButton.widthAnchor.constraint(equalToConstant: 42),
            hideButton.heightAnchor.constraint(equalToConstant: 42),
            hideButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            hideButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            screenShotButton.widthAnchor.constraint(equalToConstant: 42),
            screenShotButton.heightAnchor.constraint(equalToConstant: 42),
            screenShotButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            screenShotButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            
            settingsButton.widthAnchor.constraint(equalToConstant: 42),
            settingsButton.heightAnchor.constraint(equalToConstant: 42),
            settingsButton.centerYAnchor.constraint(equalTo: screenShotButton.centerYAnchor),
            settingsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -view.frame.width / 4),
            
            appearanceButton.widthAnchor.constraint(equalToConstant: 42),
            appearanceButton.heightAnchor.constraint(equalToConstant: 42),
            appearanceButton.centerYAnchor.constraint(equalTo: screenShotButton.centerYAnchor),
            appearanceButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.frame.width / 4),
            
            testLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            
        ])
    }
}

extension WorkoutDetailsVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .systemBlue
        renderer.lineWidth = 5
        return renderer
    }
}

extension WorkoutDetailsVC {
    
    private func setConstraintsMap() {
        view.addSubview(mapView)
        mapView.addSubview(zoomButton)
        mapView.addSubview(decreaseButton)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        zoomButton.translatesAutoresizingMaskIntoConstraints = false
        decreaseButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            zoomButton.widthAnchor.constraint(equalToConstant: 60),
            zoomButton.heightAnchor.constraint(equalToConstant: 60),
            zoomButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            zoomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            
            decreaseButton.widthAnchor.constraint(equalToConstant: 60),
            decreaseButton.heightAnchor.constraint(equalToConstant: 60),
            decreaseButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            decreaseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60)
            
        ])
    }
    
    // MARK: - SetButtons
    
    private func setButtons() {
        zoomButton.setBackgroundImage(UIImage(systemName: "plus.circle"), for: .normal)
        zoomButton.addTarget(self, action: #selector(zoom), for: .touchUpInside)
        decreaseButton.setBackgroundImage(UIImage(systemName: "minus.circle"), for: .normal)
        decreaseButton.addTarget(self, action: #selector(decrease), for: .touchUpInside)
    }
    
    @objc func zoom() {
        
        switch state {
        case.zero :
            var region: MKCoordinateRegion = mapView.region
            region.span.latitudeDelta *= 0.7
            region.span.longitudeDelta *= 0.7
            mapView.setRegion(region, animated: true)
            state = .zoom
        case .zoom:
            break
        case .decrease:
            mapView.setRegion(defaultRegion, animated: true)
            state = .zero
        }
    }
    
    @objc func decrease() {

        switch state {
        case.zero :
            var region: MKCoordinateRegion = mapView.region
            region.span.latitudeDelta /= 0.7
            region.span.longitudeDelta /= 0.7
            mapView.setRegion(region, animated: true)
            state = .decrease
        case .zoom:
            mapView.setRegion(defaultRegion, animated: true)
            state = .zero
        case .decrease:
            break
        }
    }
}
