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
        case back
        case hide
    }
    
    let gradientLayer: CAGradientLayer = CAGradientLayer()
    
    let resultHeader: SelectedWorkoutHeader = {
        let header = SelectedWorkoutHeader()
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
    
//    let bottomBar: WorkoutResultFooter = {
//        let view = WorkoutResultFooter()
//        view.disableAutoresizingMask()
//        return view
//    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.disableAutoresizingMask()
        button.setImage(UIImage(named: "NavigationBack"), for: .normal)
        return button
    }()
    
    private let hideButton: UIButton = {
        let button = UIButton()
        button.disableAutoresizingMask()
        button.setImage(UIImage(named: "NavigationHide"), for: .normal)
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
        mapView.viewController = self

        setViews()
        activateMode(mode: .initial)
//        activateSubviewsHandlers()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
//    private func activateSubviewsHandlers() {
//        bottomBar.buttonStateHandler = { self.activateMode(mode: $0) }
//    }
    
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
                        bottleImage.isHidden = true
                        dumbbellImage.isHidden = true
                        logoView.image = UIImage(named: "workoutScreenLogoOrangeBlue")
                        
                        setConstraints(outdoorStatus: true)
                        
                    } catch let error as HealthKitManager.HealthKitError {
                        HealthKitManager.shared.errorHandling(error: error)
                        logoView.image = UIImage(named: "workoutScreenLogoOrangeWhite")
                        if healthKitData.totalDistance > 100 {
                            resultHeader.healthKitData = healthKitData
                            resultHeader.activateMode(mode: .indoorDynamicWorkout)
                        } else {
                            resultHeader.healthKitData = healthKitData
                            resultHeader.activateMode(mode: .staticWorkout)
                        }
                        
                        setConstraints(outdoorStatus: false)
                    }
                }
            }
        case .screenshot:
            ScreenschotHelper.shared.makeScreenShot(hiddenViews: [backButton, hideButton, screenshotButton], viewController: self)
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
    
    private func setConstraints(outdoorStatus: Bool) {
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
            resultHeader.topAnchor.constraint(equalTo: view.topAnchor, constant: outdoorStatus ? 120 : 160),
            
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


