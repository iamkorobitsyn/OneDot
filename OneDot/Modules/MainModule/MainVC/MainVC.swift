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
    
    let mapView: MKMapView = {
        let view = MKMapView()
        view.overrideUserInterfaceStyle = .light
        view.disableAutoresizingMask()
        return view
    }()
    
    let headerBar: HeaderBarView = {
        let view = HeaderBarView()
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
    
    let workoutBottomBar: WorkoutBottomBar = {
        let view = WorkoutBottomBar()
        view.disableAutoresizingMask()
        return view
    }()
    
    let calculatorBottomBar: CalculatorBottomBar = {
        let view = CalculatorBottomBar()
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
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        
        checkLocationEnabled()
        setViews()
        setConstraints()
        activateSubviewsHandlers()
 
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
    
    //MARK: - CheckLocation
    
    private func checkLocationEnabled() {
        Task { locationManager.startUpdatingLocation()
               if try await MapKitManager.shared.checkLocationServicesEnabled(viewController: self, mapView: mapView) {
               mapView.showsUserLocation = true } }
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
            let WorkoutsVC = WorkoutsVC()
            let navigationVC = UINavigationController(rootViewController: WorkoutsVC)
            navigationVC.view.layer.cornerRadius = .barCorner
            present(navigationVC, animated: true)
        }
    }
}


//MARK: - CLLocationManagerDelegate

extension MainVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationEnabled()
    }
}

extension MainVC {
    
    //MARK: - SetViews
    
    private func setViews() {
        
        view.addSubview(mapView)
        
        view.addSubview(headerBar)
        view.addSubview(notesView)
        view.addSubview(calculationsView)
        view.addSubview(settingsView)
        view.addSubview(workoutBottomBar)
        view.addSubview(calculatorBottomBar)
        
        view.addSubview(splashScreenView)
        
        ShapeManager.shared.drawViewGradient(layer: mapView.layer)
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
            headerBar.heightAnchor.constraint(equalToConstant: CGFloat.headerBarHeight),
            headerBar.widthAnchor.constraint(equalToConstant: CGFloat.barWidth),
            
            calculationsView.widthAnchor.constraint(equalToConstant: CGFloat.barWidth),
            calculationsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            calculationsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calculationsView.topAnchor.constraint(equalTo: headerBar.bottomAnchor, constant: 10),
            
            settingsView.widthAnchor.constraint(equalToConstant: CGFloat.barWidth),
            settingsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            settingsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            settingsView.topAnchor.constraint(equalTo: headerBar.bottomAnchor, constant: 10),
            
            notesView.widthAnchor.constraint(equalToConstant: CGFloat.barWidth),
            notesView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: CGFloat.headerBarHeight + 70),
            notesView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notesView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            workoutBottomBar.widthAnchor.constraint(equalToConstant: .barWidth),
            workoutBottomBar.heightAnchor.constraint(equalToConstant: .tabBarHeight),
            workoutBottomBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            workoutBottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            calculatorBottomBar.widthAnchor.constraint(equalToConstant: .barWidth),
            calculatorBottomBar.heightAnchor.constraint(equalToConstant: .tabBarHeight),
            calculatorBottomBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calculatorBottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            splashScreenView.topAnchor.constraint(equalTo: view.topAnchor),
            splashScreenView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            splashScreenView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            splashScreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }
    
}


extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
