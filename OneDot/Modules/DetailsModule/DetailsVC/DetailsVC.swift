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
    
    let workoutResultHeader: WorkoutResultHeader = {
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
                let coordinates = try await HealthKitManager.shared.getCoordinates(data: healthKitData)
                MapKitManager.shared.drawMapPolyline(mapView: mapView, coordinates: coordinates.coordinates2D)
                MapKitManager.shared.setMapRegion(mapView: mapView, coordinates: coordinates.coordinates2D, scaleFactor: 3.0)
                workoutResultHeader.healthKitData = healthKitData
                workoutResultHeader.healthKitData?.updateClimbing(altitube: coordinates.climbing)
                workoutResultHeader.activateMode(mode: .dynamicWorkout)
            }
            
        }
        
        setViews()
        setConstraints()
        activateSubviewsHandlers()
        
        
        
        ShapeManager.shared.drawResultSeparator(shape: separator, view: workoutResultHeader)
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
        view.addSubview(workoutResultHeader)
        workoutResultHeader.activateMode(mode: .dynamicWorkout)
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
            
            workoutResultHeader.topAnchor.constraint(equalTo: view.topAnchor, constant: -0.5),
            workoutResultHeader.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width + 1),
            workoutResultHeader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            workoutResultHeader.heightAnchor.constraint(equalToConstant: 300),
            
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
