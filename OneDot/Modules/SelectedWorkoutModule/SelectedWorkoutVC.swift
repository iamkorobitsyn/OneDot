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
    
    let hapticGenerator = UISelectionFeedbackGenerator()

    var healthKitData: HealthKitData?

    enum Mode {
        case initial
        case screenshot
        case settings
        case back
        case hide
    }
    
    let gradientLayer: CAGradientLayer = CAGradientLayer()
    
    let resultHeader: HeaderViewForSelectedWorkout = {
        let header = HeaderViewForSelectedWorkout()
        header.disableAutoresizingMask()
        return header
    }()
    
    let mapView: MapView = {
        let view = MapView()
        view.disableAutoresizingMask()
        return view
    }()
    
    let logoView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "screenLogo")
        view.disableAutoresizingMask()
        return view
    }()
    
    let bottomBar: WorkoutResultFooter = {
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
        
        activateMode(mode: .initial)
        setViews()
        setConstraints()
        activateSubviewsHandlers()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    private func activateSubviewsHandlers() {
        bottomBar.buttonStateHandler = { self.activateMode(mode: $0) }
    }
    
    private func activateMode(mode: Mode) {
        hapticGenerator.selectionChanged()
        
        switch mode {
        case .initial:
            if let healthKitData = healthKitData {
                
                Task {
                    do {
                        let coordinates = try await HealthKitManager.shared.getCoordinates(data: healthKitData)
                        mapView.activateMode(mode: .drawWorkoutRoute(coordinates: coordinates.coordinates2D, scaleFactor: 3.0))
                        resultHeader.healthKitData = healthKitData
                        resultHeader.healthKitData?.updateClimbing(altitube: coordinates.climbing)
                        resultHeader.activateMode(mode: .outdoorDynamicWorkout)
                        gradientLayer.isHidden = true
                        logoView.isHidden = true
                        
                    } catch let error as HealthKitManager.HealthKitError {
                        HealthKitManager.shared.errorHandling(error: error)
                        if healthKitData.totalDistance > 100 {
                            resultHeader.healthKitData = healthKitData
                            resultHeader.activateMode(mode: .indoorDynamicWorkout)
                        } else {
                            resultHeader.healthKitData = healthKitData
                            resultHeader.activateMode(mode: .staticWorkout)
                        }
                    }
                }
            }
        case .screenshot:
            ScreenschotHelper.shared.makeScreenShot(hiddenViews: [backButton, hideButton, bottomBar], viewController: self)
        case .settings:
            print("settings")
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
        default:
            break
        }
    }

    
    //MARK: - SetViews
    
    private func setViews() {

        view.addSubview(mapView)
        view.layer.addSublayer(gradientLayer)
        view.addSubview(logoView)
        view.addSubview(resultHeader)
        view.addSubview(backButton)
        view.addSubview(hideButton)
        view.addSubview(bottomBar)

        [backButton, hideButton].forEach { button in
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
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            
            bottomBar.widthAnchor.constraint(equalToConstant: .barWidth),
            bottomBar.heightAnchor.constraint(equalToConstant: .bottomBarHeight),
            bottomBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            resultHeader.heightAnchor.constraint(equalToConstant: 210),
            resultHeader.widthAnchor.constraint(equalToConstant: .barWidth),
            resultHeader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultHeader.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            
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


