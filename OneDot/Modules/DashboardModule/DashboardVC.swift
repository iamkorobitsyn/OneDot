//
//  ViewController.swift
//  OneDot
//
//  Created by Александр Коробицын on 08.07.2023.
//

import UIKit
import MapKit

class DashboardVC: UIViewController, CAAnimationDelegate {
    
    private let hapticGenerator = UISelectionFeedbackGenerator()
    
    private let locationManager: CLLocationManager = CLLocationManager()
    
    private var healthKitDataList: [WorkoutData]?
    
    private let headerBar: HeaderBarView = HeaderBarView()
    private let footerBar: FooterBarView = FooterBarView()
    
    private let headerSeparator: CAShapeLayer = CAShapeLayer()
    private let footerSeparator: CAShapeLayer = CAShapeLayer()
    
    private let mapView: MKMapView = MKMapView()
    
    private let notesBody: NotesBodyView = NotesBodyView()
    private let calculationsBody: CalculationsBodyView = CalculationsBodyView()
    private let settingsBody: SettingsBodyView = SettingsBodyView()
    
    private let splashScreen: SplashScreenView = SplashScreenView()
    private let locationAlertLabel: UILabel = UILabel()
    
    enum Mode {
        case geoTrackingActive
        case geoTrackingInactive
        case notes
        case notesHide
        case calculations
        case calculationsHide
        case settings
        case settingsHide
        case transitionToWorkoutMode
        case transitionToProfile
    }
    
    //MARK: - DidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        activateSubviewsHandlers()

        setViews()
        setConstraints()
        activateInitialSettings()
    }
    
    //MARK: - SplashScreenAnimations
    
    override func viewDidAppear(_ animated: Bool) {
        GraphicsService.shared.splashAnimate(splashScreen.frontLayer, splashScreen.gradient, splashScreen.launchLogo, delegate: self)
        GraphicsService.shared.drawShape(shape: headerSeparator, shapeType: .headerSingleSeparator, view: headerBar)
        GraphicsService.shared.drawShape(shape: footerSeparator, shapeType: .footerSingleSeparator, view: footerBar)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getHealthKitDataList()
        headerBar.animateNavigationView()
        NotificationCenter.default.addObserver(headerBar,
                                               selector: #selector(headerBar.animateNavigationView),
                                               name: UIApplication.didBecomeActiveNotification ,
                                               object: nil)
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            splashScreen.alpha = 0
        }
    }
    
    //MARK: - ActivateInintialSettings
    
    private func activateInitialSettings() {
        Task { await LocationService.shared.requestAuthorization() }
        
        UserDefaultsManager.shared.isGeoTracking ? activateMode(mode: .geoTrackingActive) : activateMode(mode: .geoTrackingInactive)
        footerBar.activateMode(mode: .dashboard)
        headerBar.activateMode(mode: .toolsDefault)
    }
    
    //MARK: - GetHealthKitDataList
    
    private func getHealthKitDataList() {
        Task {
            do {
                healthKitDataList = try await HealthKitManager.shared.fetchHealthKitDataList()
            } catch let error as HealthKitManager.HealthKitError {
                HealthKitManager.shared.errorHandling(error: error)
            }
        }
    }
    
    //MARK: - SetClosures
    
    private func activateSubviewsHandlers() {
        LocationService.shared.didUpdateHightAccuracy = { [weak self] state in
            guard let self else { return }
            headerBar.activateMode(mode: .trackingIndication(state))
            switch state {
            case .goodSignal, .poorSignal:
                locationAlertLabel.isHidden = true
            case .locationDisabled:
                locationAlertLabel.isHidden = false
            }
        }
        LocationService.shared.didUpdateRegion = { [weak self] region in self?.mapView.setRegion(region, animated: true) }
        headerBar.buttonStateHandler = { [weak self] in self?.activateMode(mode: $0) }
        footerBar.dashboardVCButtonStateHandler = { [weak self] in self?.activateMode(mode: $0) }
        calculationsBody.hideHandler = { [weak self] in self?.activateMode(mode:.calculationsHide) }
        notesBody.buttonStateHandler = { [weak self] in self?.activateMode(mode: $0) }
        settingsBody.buttonStateHandler = { [weak self] in self?.activateMode(mode: $0) }
    }
    
    //MARK: - ActivateMode
    
    private func activateMode(mode: Mode) {
        switch mode {
            
        case .geoTrackingActive:
            UserDefaultsManager.shared.isGeoTracking = true
            headerBar.activateMode(mode: .outdoor)
            footerBar.activateMode(mode: .dashboard)
        case .geoTrackingInactive:
            UserDefaultsManager.shared.isGeoTracking = false
            headerBar.activateMode(mode: .indoor)
            footerBar.activateMode(mode: .dashboard)
        case .notes:
            headerBar.activateMode(mode: .notes)
            notesBody.activateMode(mode: .prepare)
            calculationsBody.present(false)
            settingsBody.activateMode(mode: .hide)
            footerBar.activateMode(mode: .hide)
        case .notesHide:
            headerBar.activateMode(mode: .toolsDefault)
            notesBody.activateMode(mode: .hide)
            footerBar.activateMode(mode: .dashboard)
        case .calculations:
            calculationsBody.present(true)
            headerBar.activateMode(mode: .calculations)
            notesBody.activateMode(mode: .hide)
            settingsBody.activateMode(mode: .hide)
            footerBar.activateMode(mode: .hide)
        case .calculationsHide:
            headerBar.activateMode(mode: .toolsDefault)
            calculationsBody.present(false)
            footerBar.activateMode(mode: .dashboard)
        case .settings:
            settingsBody.activateMode(mode: .active)
            headerBar.activateMode(mode: .settings)
            calculationsBody.present(false)
            footerBar.activateMode(mode: .hide)
        case .settingsHide:
            headerBar.activateMode(mode: .toolsDefault)
            settingsBody.activateMode(mode: .hide)
            footerBar.activateMode(mode: .dashboard)
        case .transitionToWorkoutMode:
            let workout = headerBar.getCurrentWorkout()
            let workoutModeVC = WorkoutVC(currentWorkout: workout)
            workoutModeVC.modalPresentationStyle = .fullScreen
            present(workoutModeVC, animated: false)
        case .transitionToProfile:
            let WorkoutsVC = WorkoutHistoryVC()
            WorkoutsVC.workoutList = healthKitDataList
            let navigationVC = UINavigationController(rootViewController: WorkoutsVC)
            present(navigationVC, animated: true)
        }
    }
}

extension DashboardVC {
    
    //MARK: - SetViews
    
    private func setViews() {
        
        [splashScreen, mapView, headerBar, footerBar, notesBody,
         calculationsBody, settingsBody, locationAlertLabel].forEach( {$0.disableAutoresizingMask()} )
        
        view.addSubview(splashScreen)
        
        view.addSubview(mapView)
        mapView.overrideUserInterfaceStyle = .light
        mapView.showsUserLocation = true
        
        view.addSubview(headerBar)
        view.addSubview(footerBar)
        view.addSubview(notesBody)
        view.addSubview(calculationsBody)
        view.addSubview(settingsBody)
        
        view.addSubview(locationAlertLabel)
        locationAlertLabel.backgroundColor = .darkGray.withAlphaComponent(0.5)
        locationAlertLabel.layer.instance(border: false, corner: .min)
        locationAlertLabel.clipsToBounds = true
        locationAlertLabel.numberOfLines = 3
        locationAlertLabel.instance(color: .white, alignment: .center, font: .standartMin)
        locationAlertLabel.text = "You have disabled location tracking. Go to the device settings and change the status."
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            headerBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            headerBar.heightAnchor.constraint(equalToConstant: .headerBarHeight),
            headerBar.widthAnchor.constraint(equalToConstant: .barWidth),
            
            locationAlertLabel.widthAnchor.constraint(equalToConstant: .barWidth - 50),
            locationAlertLabel.heightAnchor.constraint(equalToConstant: 60),
            locationAlertLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            locationAlertLabel.topAnchor.constraint(equalTo: headerBar.bottomAnchor, constant: 20),
            
            calculationsBody.widthAnchor.constraint(equalToConstant: CGFloat.barWidth),
            calculationsBody.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            calculationsBody.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calculationsBody.topAnchor.constraint(equalTo: headerBar.bottomAnchor, constant: 10),
            
            settingsBody.widthAnchor.constraint(equalToConstant: .barWidth),
            settingsBody.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            settingsBody.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            settingsBody.topAnchor.constraint(equalTo: headerBar.bottomAnchor, constant: 10),
            
            notesBody.widthAnchor.constraint(equalToConstant: CGFloat.barWidth),
            notesBody.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: CGFloat.headerBarHeight + 70),
            notesBody.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notesBody.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            footerBar.widthAnchor.constraint(equalToConstant: .barWidth),
            footerBar.heightAnchor.constraint(equalToConstant: .bottomBarHeight),
            footerBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            footerBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            splashScreen.topAnchor.constraint(equalTo: view.topAnchor),
            splashScreen.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            splashScreen.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            splashScreen.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
}


