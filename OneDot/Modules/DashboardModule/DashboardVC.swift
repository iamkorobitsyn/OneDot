//
//  ViewController.swift
//  OneDot
//
//  Created by Александр Коробицын on 08.07.2023.
//

import UIKit
import MapKit

class DashboardVC: UIViewController, CAAnimationDelegate {
    
    let hapticGenerator = UISelectionFeedbackGenerator()
    
    let locationManager: CLLocationManager = CLLocationManager()
    
    var healthKitDataList: [WorkoutData]?
    
    let mapView: MKMapView = {
        let view = MKMapView()
        view.disableAutoresizingMask()
        view.overrideUserInterfaceStyle = .light
        view.showsUserLocation = true
        return view
    }()
    
    let dashboardHeader: headerBarView = {
        let view = headerBarView()
        view.disableAutoresizingMask()
        return view
    }()
    
    private let navigationStateLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.backgroundColor = .darkGray.withAlphaComponent(0.5)
        label.layer.instance(border: false, corner: .min)
        label.clipsToBounds = true
        label.numberOfLines = 3
        label.instance(color: .white, alignment: .center, font: .standartMin)
        label.text = "You have disabled location tracking. Go to the device settings and change the status."
        return label
    }()
    
    let notesBody: NotesBodyView = {
        let view = NotesBodyView()
        view.effect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        view.clipsToBounds = true
        view.disableAutoresizingMask()
        return view
    }()
    
    let calculationsBody = {
        let view = CalculationsBodyView()
        view.disableAutoresizingMask()
        return view
    }()
    
    let settingsBody: SettingsBodyView = {
        let view = SettingsBodyView()
        view.disableAutoresizingMask()
        return view
    }()
    
    let dashboardFooter: footerBarView = {
        let view = footerBarView()
        view.disableAutoresizingMask()
        return view
    }()

    let StartSplashScreen: StartSplachScreenView = {
        let view = StartSplachScreenView()
        view.disableAutoresizingMask()
        return view
    }()
    
    private let headerSeparator: CAShapeLayer = CAShapeLayer()
    private let footerSeparator: CAShapeLayer = CAShapeLayer()
    

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
        GraphicsService.shared.splashScreenAnimate(StartSplashScreen.frontLayer,
                                            StartSplashScreen.gradientBackLayer,
                                            StartSplashScreen.launchLogo,
                                            delegate: self)
        
        GraphicsService.shared.drawShape(shape: headerSeparator, shapeType: .headerSingleShape, view: dashboardHeader)
        GraphicsService.shared.drawShape(shape: footerSeparator, shapeType: .footerSingleShape, view: dashboardFooter)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getHealthKitDataList()
        dashboardHeader.animateNavigationView()
        NotificationCenter.default.addObserver(dashboardHeader,
                                               selector: #selector(dashboardHeader.animateNavigationView),
                                               name: UIApplication.didBecomeActiveNotification ,
                                               object: nil)
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            StartSplashScreen.alpha = 0
        }
    }
    
    //MARK: - ActivateInintialSettings
    
    private func activateInitialSettings() {
        Task { await LocationService.shared.requestAuthorization() }
        
        UserDefaultsManager.shared.isGeoTracking ? activateMode(mode: .geoTrackingActive) : activateMode(mode: .geoTrackingInactive)
        dashboardFooter.activateMode(mode: .dashboard)
        dashboardHeader.activateMode(mode: .toolsDefault)
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
            dashboardHeader.activateMode(mode: .trackingIndication(state))
            switch state {
            case .goodSignal, .poorSignal:
                navigationStateLabel.isHidden = true
            case .locationDisabled:
                navigationStateLabel.isHidden = false
            }
        }
        LocationService.shared.didUpdateRegion = { [weak self] region in self?.mapView.setRegion(region, animated: true) }
        dashboardHeader.buttonStateHandler = { [weak self] in self?.activateMode(mode: $0) }
        dashboardFooter.dashboardVCButtonStateHandler = { [weak self] in self?.activateMode(mode: $0) }
        calculationsBody.buttonStateHandler = { [weak self] in self?.activateMode(mode: $0) }
        notesBody.buttonStateHandler = { [weak self] in self?.activateMode(mode: $0) }
        settingsBody.buttonStateHandler = { [weak self] in self?.activateMode(mode: $0) }
    }
    
    //MARK: - ActivateMode
    
    private func activateMode(mode: Mode) {
        switch mode {
            
        case .geoTrackingActive:
            UserDefaultsManager.shared.isGeoTracking = true
            dashboardHeader.activateMode(mode: .outdoor)
            dashboardFooter.activateMode(mode: .dashboard)
        case .geoTrackingInactive:
            UserDefaultsManager.shared.isGeoTracking = false
            dashboardHeader.activateMode(mode: .indoor)
            dashboardFooter.activateMode(mode: .dashboard)
        case .notes:
            dashboardHeader.activateMode(mode: .notes)
            notesBody.activateMode(mode: .prepare)
            calculationsBody.activateMode(mode: .hide)
            settingsBody.activateMode(mode: .hide)
            dashboardFooter.activateMode(mode: .hide)
        case .notesHide:
            dashboardHeader.activateMode(mode: .toolsDefault)
            notesBody.activateMode(mode: .hide)
            dashboardFooter.activateMode(mode: .dashboard)
        case .calculations:
            calculationsBody.activateMode(mode: .distance)
            dashboardHeader.activateMode(mode: .calculations)
            notesBody.activateMode(mode: .hide)
            settingsBody.activateMode(mode: .hide)
            dashboardFooter.activateMode(mode: .hide)
        case .calculationsHide:
            dashboardHeader.activateMode(mode: .toolsDefault)
            calculationsBody.activateMode(mode: .hide)
            dashboardFooter.activateMode(mode: .dashboard)
        case .settings:
            settingsBody.activateMode(mode: .active)
            dashboardHeader.activateMode(mode: .settings)
            calculationsBody.activateMode(mode: .hide)
            dashboardFooter.activateMode(mode: .hide)
        case .settingsHide:
            dashboardHeader.activateMode(mode: .toolsDefault)
            settingsBody.activateMode(mode: .hide)
            dashboardFooter.activateMode(mode: .dashboard)
        case .transitionToWorkoutMode:
            let workout = dashboardHeader.getCurrentWorkout()

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

        view.addSubview(mapView)
        view.addSubview(dashboardHeader)
        view.addSubview(navigationStateLabel)
        view.addSubview(notesBody)
        view.addSubview(calculationsBody)
        view.addSubview(settingsBody)
        view.addSubview(dashboardFooter)
        view.addSubview(StartSplashScreen)
        
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            dashboardHeader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dashboardHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            dashboardHeader.heightAnchor.constraint(equalToConstant: .headerBarHeight),
            dashboardHeader.widthAnchor.constraint(equalToConstant: .barWidth),
            
            navigationStateLabel.widthAnchor.constraint(equalToConstant: .barWidth - 50),
            navigationStateLabel.heightAnchor.constraint(equalToConstant: 60),
            navigationStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            navigationStateLabel.topAnchor.constraint(equalTo: dashboardHeader.bottomAnchor, constant: 20),
            
            calculationsBody.widthAnchor.constraint(equalToConstant: CGFloat.barWidth),
            calculationsBody.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            calculationsBody.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calculationsBody.topAnchor.constraint(equalTo: dashboardHeader.bottomAnchor, constant: 10),
            
            settingsBody.widthAnchor.constraint(equalToConstant: .barWidth),
            settingsBody.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            settingsBody.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            settingsBody.topAnchor.constraint(equalTo: dashboardHeader.bottomAnchor, constant: 10),
            
            notesBody.widthAnchor.constraint(equalToConstant: CGFloat.barWidth),
            notesBody.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: CGFloat.headerBarHeight + 70),
            notesBody.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notesBody.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            dashboardFooter.widthAnchor.constraint(equalToConstant: .barWidth),
            dashboardFooter.heightAnchor.constraint(equalToConstant: .bottomBarHeight),
            dashboardFooter.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dashboardFooter.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            StartSplashScreen.topAnchor.constraint(equalTo: view.topAnchor),
            StartSplashScreen.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            StartSplashScreen.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            StartSplashScreen.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
}


