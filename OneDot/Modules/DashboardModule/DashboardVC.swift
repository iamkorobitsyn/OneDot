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
    
    var healthKitDataList: [HealthKitData]?
    
    let mapView: MKMapView = {
        let view = MKMapView()
        view.disableAutoresizingMask()
        view.overrideUserInterfaceStyle = .light
        view.showsUserLocation = true
        return view
    }()
    
    let dashboardHeader: DashboardHeader = {
        let view = DashboardHeader()
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
    
    let notesView: NotesView = {
        let view = NotesView()
        view.effect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        view.clipsToBounds = true
        view.disableAutoresizingMask()
        return view
    }()
    
    let calculationsView = {
        let view = CalculationsView()
        view.disableAutoresizingMask()
        return view
    }()
    
    let settingsView: SettingsView = {
        let view = SettingsView()
        view.disableAutoresizingMask()
        return view
    }()
    
    let workoutFooter: WorkoutFooter = {
        let view = WorkoutFooter()
        view.disableAutoresizingMask()
        return view
    }()
    
    let calculationsFooter: CalculationFooter = {
        let view = CalculationFooter()
        view.disableAutoresizingMask()
        return view
    }()

    let StartSplashScreen: StartSplachScreen = {
        let view = StartSplachScreen()
        view.disableAutoresizingMask()
        return view
    }()

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
        case pickerDistance
        case pickerSpeed
        case pickerPace
        case pickerTime
        case transitionToProfile
    }
    
    //MARK: - DidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
  
        getHealthKitDataList()
        activateSubviewsHandlers()

        setViews()
        setConstraints()
        activateInitialSettings()
        
    }
    
    //MARK: - SplashScreenAnimations
    
    override func viewDidAppear(_ animated: Bool) {
        AnimationManager.shared.splashScreenAnimate(StartSplashScreen.frontLayer,
                                            StartSplashScreen.gradientBackLayer,
                                            StartSplashScreen.launchLogo,
                                            delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        Task { await LocationManager.shared.requestAuthorization() }
        
        UserDefaultsManager.shared.isGeoTracking ? activateMode(mode: .geoTrackingActive) : activateMode(mode: .geoTrackingInactive)
        workoutFooter.activateMode(mode: .dashboard)
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
        LocationManager.shared.didUpdateTrackingState = { [weak self] state in
            
            self?.dashboardHeader.activateMode(mode: .trackingIndication(state))
            switch state {
            case .goodSignal:
                self?.navigationStateLabel.isHidden = true
            case .poorSignal:
                self?.navigationStateLabel.isHidden = true
            case .locationDisabled:
                self?.navigationStateLabel.isHidden = false
            }
        }
        LocationManager.shared.didUpdateRegion = { [weak self] region in self?.mapView.setRegion(region, animated: true) }
        dashboardHeader.buttonStateHandler = { [weak self] in self?.activateMode(mode: $0) }
        workoutFooter.dashboardVCButtonStateHandler = { [weak self] in self?.activateMode(mode: $0) }
        calculationsFooter.buttonStateHandler = { [weak self] in self?.activateMode(mode: $0)}
        calculationsView.buttonStateHandler = { [weak self] in self?.activateMode(mode: $0) }
        notesView.buttonStateHandler = { [weak self] in self?.activateMode(mode: $0) }
        settingsView.buttonStateHandler = { [weak self] in self?.activateMode(mode: $0) }
    }
    
    //MARK: - ActivateMode
    
    private func activateMode(mode: Mode) {
        hapticGenerator.selectionChanged()
        switch mode {
            
        case .geoTrackingActive:
            UserDefaultsManager.shared.isGeoTracking = true
            dashboardHeader.activateMode(mode: .outdoor)
            calculationsFooter.activateMode(mode: .hide)
            workoutFooter.activateMode(mode: .dashboard)
        case .geoTrackingInactive:
            UserDefaultsManager.shared.isGeoTracking = false
            dashboardHeader.activateMode(mode: .indoor)
            calculationsFooter.activateMode(mode: .hide)
            workoutFooter.activateMode(mode: .dashboard)
        case .notes:
            dashboardHeader.activateMode(mode: .notes)
            notesView.activateMode(mode: .prepare)
            calculationsView.activateMode(mode: .hide)
            settingsView.activateMode(mode: .hide)
            calculationsFooter.activateMode(mode: .hide)
            workoutFooter.activateMode(mode: .hide)
        case .notesHide:
            dashboardHeader.activateMode(mode: .toolsDefault)
            notesView.activateMode(mode: .hide)
            workoutFooter.activateMode(mode: .dashboard)
        case .calculations:
            calculationsView.activateMode(mode: .distance)
            dashboardHeader.activateMode(mode: .calculations)
            notesView.activateMode(mode: .hide)
            settingsView.activateMode(mode: .hide)
            workoutFooter.activateMode(mode: .hide)
            calculationsFooter.activateMode(mode: .pickerDistance)
        case .calculationsHide:
            dashboardHeader.activateMode(mode: .toolsDefault)
            calculationsView.activateMode(mode: .hide)
            calculationsFooter.activateMode(mode: .hide)
            workoutFooter.activateMode(mode: .dashboard)
        case .settings:
            settingsView.activateMode(mode: .active)
            dashboardHeader.activateMode(mode: .settings)
            calculationsView.activateMode(mode: .hide)
            workoutFooter.activateMode(mode: .hide)
            calculationsFooter.activateMode(mode: .hide)
        case .settingsHide:
            dashboardHeader.activateMode(mode: .toolsDefault)
            settingsView.activateMode(mode: .hide)
            workoutFooter.activateMode(mode: .dashboard)
        case .transitionToWorkoutMode:
            let workout = dashboardHeader.pickerView.updateCurrentWorkout()

            let workoutModeVC = WorkoutVC(currentWorkout: workout)
            workoutModeVC.modalPresentationStyle = .fullScreen
            present(workoutModeVC, animated: false)
        case .pickerDistance:
            calculationsFooter.activateMode(mode: .pickerDistance)
            calculationsView.activateMode(mode: .distance)
        case .pickerSpeed:
            calculationsView.activateMode(mode: .speed)
            calculationsFooter.activateMode(mode: .pickerSpeed)
        case .pickerPace:
            calculationsView.activateMode(mode: .pace)
            calculationsFooter.activateMode(mode: .pickerPace)
        case .pickerTime:
            calculationsView.activateMode(mode: .time)
            calculationsFooter.activateMode(mode: .PickerTime)
        case .transitionToProfile:
            let WorkoutsVC = WorkoutHistoryVC()
            WorkoutsVC.healthKitDataList = healthKitDataList
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
        view.addSubview(notesView)
        view.addSubview(calculationsView)
        view.addSubview(settingsView)
        view.addSubview(workoutFooter)
        view.addSubview(calculationsFooter)
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
            
            calculationsView.widthAnchor.constraint(equalToConstant: CGFloat.barWidth),
            calculationsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            calculationsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calculationsView.topAnchor.constraint(equalTo: dashboardHeader.bottomAnchor, constant: 10),
            
            settingsView.widthAnchor.constraint(equalToConstant: .barWidth),
            settingsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            settingsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            settingsView.topAnchor.constraint(equalTo: dashboardHeader.bottomAnchor, constant: 10),
            
            notesView.widthAnchor.constraint(equalToConstant: CGFloat.barWidth),
            notesView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: CGFloat.headerBarHeight + 70),
            notesView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notesView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            workoutFooter.widthAnchor.constraint(equalToConstant: .barWidth),
            workoutFooter.heightAnchor.constraint(equalToConstant: .bottomBarHeight),
            workoutFooter.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            workoutFooter.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            calculationsFooter.widthAnchor.constraint(equalToConstant: .barWidth),
            calculationsFooter.heightAnchor.constraint(equalToConstant: .bottomBarHeight),
            calculationsFooter.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calculationsFooter.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            StartSplashScreen.topAnchor.constraint(equalTo: view.topAnchor),
            StartSplashScreen.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            StartSplashScreen.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            StartSplashScreen.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
}


