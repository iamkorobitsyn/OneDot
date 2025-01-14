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
    
    let mapView: MapView = {
        let view = MapView()
        view.disableAutoresizingMask()
        return view
    }()
    
    let dashboardHeader: DashboardHeader = {
        let view = DashboardHeader()
        view.disableAutoresizingMask()
        return view
    }()

    let trackingView: TrackingView = {
        let view = TrackingView()
        view.disableAutoresizingMask()
        return view
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
    
    let calculatorBottomBar: CalculationFooter = {
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
        mapView.viewController = self
        
        activateInitialSettings()
        activateSubviewsHandlers()
        getHealthKitDataList()
        
        setViews()
        setConstraints()
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
        let uD = UserDefaultsManager.shared
        uD.isGeoTracking ? activateMode(mode: .geoTrackingActive) : activateMode(mode: .geoTrackingInactive)
        workoutFooter.activateMode(mode: .ready)
        dashboardHeader.activateMode(mode: .toolsDefault)
    }
    
    //MARK: - GetHealthKitDataList
    
    private func getHealthKitDataList() {
        Task {
            do {
                healthKitDataList = try await HealthKitManager.shared.fetchHealthKitDataList()
            } catch let error as HealthKitManager.HealthKitError{
                HealthKitManager.shared.errorHandling(error: error)
            }
        }
    }
    
    //MARK: - SetClosures
    
    private func activateSubviewsHandlers() {
        dashboardHeader.buttonStateHandler = { [weak self] in self?.activateMode(mode: $0) }
        workoutFooter.dashboardVCButtonStateHandler = { [weak self] in self?.activateMode(mode: $0) }
        calculatorBottomBar.buttonStateHandler = { [weak self] in self?.activateMode(mode: $0)}
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
            calculatorBottomBar.activateMode(mode: .hide)
            workoutFooter.activateMode(mode: .ready)
        case .geoTrackingInactive:
            UserDefaultsManager.shared.isGeoTracking = false
            dashboardHeader.activateMode(mode: .indoor)
            calculatorBottomBar.activateMode(mode: .hide)
            workoutFooter.activateMode(mode: .ready)
        case .notes:
            notesView.activateMode(mode: .active)
            dashboardHeader.activateMode(mode: .notes)
            calculationsView.activateMode(mode: .hide)
            calculatorBottomBar.activateMode(mode: .hide)
            settingsView.activateMode(mode: .hide)
        case .notesHide:
            dashboardHeader.activateMode(mode: .toolsDefault)
            notesView.activateMode(mode: .hide)
            workoutFooter.activateMode(mode: .ready)
        case .calculations:
            calculationsView.activateMode(mode: .distance)
            dashboardHeader.activateMode(mode: .calculations)
            settingsView.activateMode(mode: .hide)
            workoutFooter.activateMode(mode: .hide)
            calculatorBottomBar.activateMode(mode: .pickerDistance)
        case .calculationsHide:
            dashboardHeader.activateMode(mode: .toolsDefault)
            calculationsView.activateMode(mode: .hide)
            calculatorBottomBar.activateMode(mode: .hide)
            workoutFooter.activateMode(mode: .ready)
        case .settings:
            settingsView.activateMode(mode: .active)
            dashboardHeader.activateMode(mode: .settings)
            calculationsView.activateMode(mode: .hide)
            workoutFooter.activateMode(mode: .hide)
            calculatorBottomBar.activateMode(mode: .hide)
        case .settingsHide:
            dashboardHeader.activateMode(mode: .toolsDefault)
            settingsView.activateMode(mode: .hide)
            workoutFooter.activateMode(mode: .ready)
        case .transitionToWorkoutMode:
            let workout = dashboardHeader.pickerView.updateCurrentWorkout()

            let workoutModeVC = WorkoutModeVC(currentWorkout: workout)
            workoutModeVC.modalPresentationStyle = .fullScreen
            present(workoutModeVC, animated: false)
        case .pickerDistance:
            calculatorBottomBar.activateMode(mode: .pickerDistance)
            calculationsView.activateMode(mode: .distance)
        case .pickerSpeed:
            calculationsView.activateMode(mode: .speed)
            calculatorBottomBar.activateMode(mode: .pickerSpeed)
        case .pickerPace:
            calculationsView.activateMode(mode: .pace)
            calculatorBottomBar.activateMode(mode: .pickerPace)
        case .pickerTime:
            calculationsView.activateMode(mode: .time)
            calculatorBottomBar.activateMode(mode: .PickerTime)
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
        mapView.activateMode(mode: .checkLocation)
        
        view.addSubview(dashboardHeader)
        view.addSubview(notesView)
        view.addSubview(trackingView)
        view.addSubview(calculationsView)
        view.addSubview(settingsView)
        view.addSubview(workoutFooter)
        view.addSubview(calculatorBottomBar)
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
            
            trackingView.widthAnchor.constraint(equalToConstant: CGFloat.barWidth),
            trackingView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            trackingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackingView.topAnchor.constraint(equalTo: dashboardHeader.bottomAnchor, constant: 10),
            
            workoutFooter.widthAnchor.constraint(equalToConstant: .barWidth),
            workoutFooter.heightAnchor.constraint(equalToConstant: .bottomBarHeight),
            workoutFooter.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            workoutFooter.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            calculatorBottomBar.widthAnchor.constraint(equalToConstant: .barWidth),
            calculatorBottomBar.heightAnchor.constraint(equalToConstant: .bottomBarHeight),
            calculatorBottomBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calculatorBottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            StartSplashScreen.topAnchor.constraint(equalTo: view.topAnchor),
            StartSplashScreen.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            StartSplashScreen.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            StartSplashScreen.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
}


