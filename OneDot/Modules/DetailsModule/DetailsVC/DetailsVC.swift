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

class DetailsVC: UIViewController {
    
    var healthKitData: HealthKitData?
    
    let hapticGenerator = UISelectionFeedbackGenerator()
    
    enum Mode {
        case screenshot
        case settings
        case back
        case hide
    }
    
    let resultHeader: WorkoutResultHeader = {
        let header = WorkoutResultHeader()
        header.disableAutoresizingMask()
        return header
    }()
    
    private let separator: CAShapeLayer = CAShapeLayer()
    
    let mapView: MKMapView = {
        let view = MKMapView()
        view.disableAutoresizingMask()
        return view
    }()
    
    var coordinates: [CLLocationCoordinate2D] = [
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
    
    let blurEffectView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.disableAutoresizingMask()
        view.effect = UIBlurEffect(style: .extraLight)
        view.layer.cornerRadius = 10
        return view
    }()
    
    let screenshotBottomBar: WorkoutResultFooter = {
        let view = WorkoutResultFooter()
        view.disableAutoresizingMask()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        if let healthKitData = healthKitData {
            Task {
                let coordinates = try await HealthKitManager.shared.getCoordinate2D(data: healthKitData)
                MapKitManager.shared.drawMapPolyline(mapView: mapView, coordinates: coordinates)
                MapKitManager.shared.setMapRegion(mapView: mapView, coordinates: coordinates, scaleFactor: 1.7)
            }
            
        }
 
        setViews()
        setConstraints()
        activateSubviewsHandlers()
        
        
        
        ShapeManager.shared.drawResultSeparator(shape: separator, view: resultHeader)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    private func activateSubviewsHandlers() {
        screenshotBottomBar.buttonStateHandler = { self.activateMode(mode: $0) }
    }
    
    private func activateMode(mode: Mode) {
        hapticGenerator.selectionChanged()
        
        switch mode {
        case .screenshot:
            ScreenschotHelper.shared.makeScreenShot(hiddenViews: [backButton, hideButton, screenshotBottomBar],
                                                    viewController: self)
        case .settings:
            print("settings")
        case .back:
            navigationController?.popViewController(animated: true)
            backButton.isHidden = true
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
        default:
            break
        }
    }

    
    //MARK: - SetViews
    
    private func setViews() {
        
        view.addSubview(blurEffectView)
        view.addSubview(mapView)
        view.addSubview(resultHeader)
        resultHeader.activateMode(mode: .dynamicWorkout)
        view.addSubview(backButton)
        view.addSubview(hideButton)
        view.addSubview(screenshotBottomBar)

        [backButton, hideButton].forEach { button in
            button.addTarget(self, action: #selector(buttonTapped(_: )), for: .touchUpInside)
        }
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            screenshotBottomBar.widthAnchor.constraint(equalToConstant: .barWidth),
            screenshotBottomBar.heightAnchor.constraint(equalToConstant: .tabBarHeight),
            screenshotBottomBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            screenshotBottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            resultHeader.topAnchor.constraint(equalTo: view.topAnchor, constant: -0.5),
            resultHeader.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width + 1),
            resultHeader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultHeader.heightAnchor.constraint(equalToConstant: 300),
            
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

extension DetailsVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .myPaletteGold
        renderer.lineWidth = 5
        return renderer
    }
}
