//
//  ViewController.swift
//  OneDot
//
//  Created by Александр Коробицын on 08.07.2023.
//

import UIKit
import MapKit

class MainVC: UIViewController, CAAnimationDelegate {
    
    let hapticGenerator = UISelectionFeedbackGenerator()
    
    let locationManager: CLLocationManager = CLLocationManager()
    
    var healthKitDataList: [HealthKitData]?
    
    let mapView: MapView = {
        let view = MapView()
        view.disableAutoresizingMask()
        return view
    }()
    
    let headerBar: WorkoutHeader = {
        let view = WorkoutHeader()
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
    
    let workoutBottomBar: WorkoutFooter = {
        let view = WorkoutFooter()
        view.disableAutoresizingMask()
        return view
    }()
    
    let calculatorBottomBar: CalculationFooter = {
        let view = CalculationFooter()
        view.disableAutoresizingMask()
        return view
    }()

    let splashScreenView: SplashScreenView = {
        let view = SplashScreenView()
        view.disableAutoresizingMask()
        return view
    }()

    enum Mode {
        case outdoor
        case outdoorNotes
        case indoor
        case notesHide
        case calculations
        case calculationsHide
        case settings
        case settingsHide
        case prepare
        case prepareToStart
        case tracking
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
        
        setViews()
        setConstraints()
        activateSubviewsHandlers()
        
        Task {
            do {
                healthKitDataList = try await HealthKitManager.shared.fetchHealthKitDataList()
            } catch let error as HealthKitManager.HealthKitError{
                HealthKitManager.shared.errorHandling(error: error)
            }
        }

        UserDefaultsManager.shared.outdoorStatusValue ? activateMode(mode: .indoor) : activateMode(mode: .outdoor)
    }
    
    //MARK: - SplashScreenAnimations
    
    override func viewDidAppear(_ animated: Bool) {
        AnimationManager.shared.splashScreenAnimate(splashScreenView.frontLayer,
                                            splashScreenView.gradientBackLayer,
                                            splashScreenView.launchLogo,
                                            delegate: self)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            splashScreenView.alpha = 0
        }
    }
    
    //MARK: - SetClosures
    
    private func activateSubviewsHandlers() {
        headerBar.buttonStateHandler = { [weak self] in self?.activateMode(mode: $0) }
        workoutBottomBar.buttonStateHandler = { [weak self] in self?.activateMode(mode: $0) }
        calculatorBottomBar.buttonStateHandler = { [weak self] in self?.activateMode(mode: $0)}
        calculationsView.buttonStateHandler = { [weak self] in self?.activateMode(mode: $0) }
        notesView.buttonStateHandler = { [weak self] in self?.activateMode(mode: $0) }
        settingsView.buttonStateHandler = { [weak self] in self?.activateMode(mode: $0) }
    }
    
    //MARK: - ActivateMode
    
    private func activateMode(mode: Mode) {
        hapticGenerator.selectionChanged()
        switch mode {
            
        case .outdoor:
            UserDefaultsManager.shared.outdoorStatusValue = true
            headerBar.activateMode(mode: .outdoor)
            notesView.activateMode(mode: .hide)
            calculationsView.activateMode(mode: .hide)
            settingsView.activateMode(mode: .hide)
            workoutBottomBar.activateMode(mode: .prepare)
        case .outdoorNotes:
            headerBar.activateMode(mode: .outdoorNotes)
            notesView.activateMode(mode: .outdoor)
            calculationsView.activateMode(mode: .hide)
            settingsView.activateMode(mode: .hide)
        case .indoor:
            UserDefaultsManager.shared.outdoorStatusValue = false
            headerBar.activateMode(mode: .indoor)
            notesView.activateMode(mode: .indoor)
            calculationsView.activateMode(mode: .hide)
            settingsView.activateMode(mode: .hide)
            workoutBottomBar.activateMode(mode: .prepare)
        case .notesHide:
            notesView.activateMode(mode: .hide)
            headerBar.activateMode(mode: .outdoor)
            workoutBottomBar.activateMode(mode: .prepare)
        case .calculations:
            calculationsView.activateMode(mode: .distance)
            settingsView.activateMode(mode: .hide)
            workoutBottomBar.activateMode(mode: .hide)
            calculatorBottomBar.activateMode(mode: .pickerDistance)
        case .calculationsHide:
            calculationsView.activateMode(mode: .hide)
            calculatorBottomBar.activateMode(mode: .hide)
            workoutBottomBar.activateMode(mode: .prepare)
        case .settings:
            settingsView.activateMode(mode: .active)
            calculationsView.activateMode(mode: .hide)
            workoutBottomBar.activateMode(mode: .hide)
        case .settingsHide:
            settingsView.activateMode(mode: .hide)
            workoutBottomBar.activateMode(mode: .prepare)
        case .prepare:
            workoutBottomBar.activateMode(mode: .prepare)
        case .prepareToStart:
            workoutBottomBar.activateMode(mode: .prepareToStart)
        case .tracking:
            workoutBottomBar.activateMode(mode: .tracking)
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
            let WorkoutsVC = WorkoutsListVC()
            WorkoutsVC.healthKitDataList = healthKitDataList
            let navigationVC = UINavigationController(rootViewController: WorkoutsVC)
            present(navigationVC, animated: true)
        }
    }
}

extension MainVC {
    
    //MARK: - SetViews
    
    private func setViews() {

        view.addSubview(mapView)
        mapView.activateMode(mode: .checkLocation)
        
        view.addSubview(headerBar)
        view.addSubview(notesView)
        view.addSubview(calculationsView)
        view.addSubview(settingsView)
        view.addSubview(workoutBottomBar)
        view.addSubview(calculatorBottomBar)
        
        view.addSubview(splashScreenView)
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
            
            calculationsView.widthAnchor.constraint(equalToConstant: CGFloat.barWidth),
            calculationsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            calculationsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calculationsView.topAnchor.constraint(equalTo: headerBar.bottomAnchor, constant: 10),
            
            settingsView.widthAnchor.constraint(equalToConstant: .barWidth),
            settingsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            settingsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            settingsView.topAnchor.constraint(equalTo: headerBar.bottomAnchor, constant: 10),
            
            notesView.widthAnchor.constraint(equalToConstant: CGFloat.barWidth),
            notesView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: CGFloat.headerBarHeight + 70),
            notesView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notesView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            workoutBottomBar.widthAnchor.constraint(equalToConstant: .barWidth),
            workoutBottomBar.heightAnchor.constraint(equalToConstant: .bottomBarHeight),
            workoutBottomBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            workoutBottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            calculatorBottomBar.widthAnchor.constraint(equalToConstant: .barWidth),
            calculatorBottomBar.heightAnchor.constraint(equalToConstant: .bottomBarHeight),
            calculatorBottomBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calculatorBottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            splashScreenView.topAnchor.constraint(equalTo: view.topAnchor),
            splashScreenView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            splashScreenView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            splashScreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }
}


