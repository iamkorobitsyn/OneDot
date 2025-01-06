//
//  WorkoutDetailsVC.swift
//  OneDot
//
//  Created by Александр Коробицын on 07.12.2024.
//

import Foundation
import UIKit
import Photos

class SelectedWorkoutVC: UIViewController {
    
    var healthKitData: HealthKitData?
    
    let hapticGenerator = UISelectionFeedbackGenerator()
    
    enum Mode {
        case screenshot
        case settings
        case back
        case hide
    }
    
    let workoutResultHeader: HeaderViewForSelectedWorkout = {
        let header = HeaderViewForSelectedWorkout()
        header.disableAutoresizingMask()
        return header
    }()
    
    let mapView: MapView = {
        let view = MapView()
        view.disableAutoresizingMask()
        return view
    }()
    
    let blurEffectView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        view.disableAutoresizingMask()
        return view
    }()
    
    let backgroundView: UIImageView = {
        let view = UIImageView()
        view.disableAutoresizingMask()
        view.alpha = 0
        view.image = UIImage(named: "GymBackground")
        view.contentMode = .scaleAspectFill
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
        mapView.viewController = self
        
        if let healthKitData = healthKitData {
            
            Task {
                do {
                    let coordinates = try await HealthKitManager.shared.getCoordinates(data: healthKitData)
                    MapKitManager.shared.drawMapPolyline(mapView: mapView, coordinates: coordinates.coordinates2D)
                    MapKitManager.shared.setMapRegion(mapView: mapView, coordinates: coordinates.coordinates2D, scaleFactor: 3.0)
                    workoutResultHeader.healthKitData = healthKitData
                    workoutResultHeader.healthKitData?.updateClimbing(altitube: coordinates.climbing)
                    workoutResultHeader.activateMode(mode: .dynamicWorkout)
                    blurEffectView.isHidden = true
                    mapView.activateMode(mode: .drawWorkoutRoute)
                    
                } catch let error as HealthKitManager.HealthKitError {
                    HealthKitManager.shared.errorHandling(error: error)
                    workoutResultHeader.healthKitData = healthKitData
                    workoutResultHeader.activateMode(mode: .staticWorkout)
                    mapView.activateMode(mode: .checkLocationFar)
                    
                }
            }
            
        }
        
        setViews()
        setConstraints()
        activateSubviewsHandlers()
        
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
        
        view.addSubview(backgroundView)
        view.addSubview(mapView)
        view.addSubview(blurEffectView)
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
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            blurEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            blurEffectView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurEffectView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            screenshotBottomBar.widthAnchor.constraint(equalToConstant: .barWidth),
            screenshotBottomBar.heightAnchor.constraint(equalToConstant: .bottomBarHeight),
            screenshotBottomBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            screenshotBottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            workoutResultHeader.heightAnchor.constraint(equalToConstant: 210),
            workoutResultHeader.widthAnchor.constraint(equalToConstant: .barWidth),
            workoutResultHeader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            workoutResultHeader.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            
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


