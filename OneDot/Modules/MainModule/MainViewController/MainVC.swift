//
//  ViewController.swift
//  OneDot
//
//  Created by Александр Коробицын on 08.07.2023.
//

import UIKit
import MapKit

class MainVC: UIViewController, CAAnimationDelegate {
    
    let splashScreen: SplashScreen = SplashScreen()

    let mapView: MKMapView = MKMapView()
    let locationManager: CLLocationManager = CLLocationManager()
    
    let trackerBar: HeaderBarView = HeaderBarView()
    let tabBar: TabBar = TabBar()
    
    let notesView: NotesView = NotesView()
    let calculationsView: CalculationsView = CalculationsView()
    
    var tabBarHandler: ((Bool)->())?
    
    enum ToolsNotesStates {
        case indoor
        case outdoor
        case notes
        case calculator
        case settings
    }
    
    //MARK: - ViewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        setViews()
        
        setConstraints()
        setupLocationManager()
        checkLocationEnabled()
        
        setClosures()
        
        tabBar.showProfile = {
            let profileVC = ProfileVC()
            self.present(profileVC, animated: true)
        }
        
        notesView.completionOfHide = { [weak self] in
            guard let self else {return}
//            trackerBar.notesButton.setInactiveState(.notesIndoor)
        }
        
        getLocationState(indoorIs: UserDefaultsManager.shared.userIndoorStatus)
        
        
        
//        toolsBarView.calcuatorVC.titleCompletion = { [weak self] title in
//            guard let self else {return}
//            trackerBar.toolsTitle.text = title
//        }
        
    }
    
    //MARK: - SetClosures
    
    private func setClosures() {
        
        trackerBar.buttonStateHandler = { [weak self] state in
            guard let self else {return}
            setViewsState(state)
        }
        
        calculationsView.pickerStateHandler = { state in
            self.tabBar.calculationPickerStateHandler(state: state)
        }
        
        tabBar.updatePickerForState = { state in
            self.calculationsView.updatePickerForState(state: state)
        }
    }
    
    //MARK: - SplashScreenAnimations
    
    override func viewDidAppear(_ animated: Bool) {
        Animator.shared.splashScreenAnimate(splashScreen.frontLayer,
                                            splashScreen.gradientBackLayer,
                                            splashScreen.launchLogo,
                                            delegate: self)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            splashScreen.alpha = 0
        }
    }
    
    //MARK: - GetLocationState
    
    private func getLocationState(indoorIs: Bool) {

        if indoorIs == true {
            title = "ROOM"
            notesView.isHidden = false
            notesView.setState(state: .indoor)
        } else {
            title = "MAP"
            notesView.isHidden = true
            notesView.setState(state: .outdoor)
        }
    }
    
    //MARK: - SetViews
    
    private func setViewsState(_ state: ToolsNotesStates) {
        switch state {
            
        case .indoor:
            getLocationState(indoorIs: true)
            UserDefaultsManager.shared.userIndoorStatus = true

        case .outdoor:
            getLocationState(indoorIs: false)
            UserDefaultsManager.shared.userIndoorStatus = false

        case .notes:
            
            notesView.isHidden = false
            calculationsView.isHidden = true
            
        case .calculator:
            calculationsView.isHidden = false
            notesView.isHidden = true
          
            
        case .settings:
            let settingsVC: SettingsVC = SettingsVC()
            present(settingsVC, animated: true) 
        }
    }
    
    
    //MARK: - LocationManager&Authorization
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func checkLocationEnabled() {
        
        let queue = DispatchQueue.global(qos: .userInitiated)
        
        queue.async {
            if CLLocationManager.locationServicesEnabled() {
                
                DispatchQueue.main.async {
                    self.checkAuthorization()
                }
            } else {
                DispatchQueue.main.async {
                    self.present(Alert(title: "У вас выключена служба геолокации",
                                       message: "Включить?",
                                       style: .actionSheet,
                                       url: "App-Prefs:root=LOCATION_SEVICES"),
                                 animated: true)
                }
            }
        }
         
    }
    
    private func checkAuthorization() {
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
            self.present(Alert(title: "Вы запретили использование местоположения",
                               message: "Разрешить?",
                               style: .actionSheet,
                               url: UIApplication.openSettingsURLString),
                         animated: true)
        case .authorizedAlways:
                break
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }


}


//MARK: - CLLocationManagerDelegate

extension MainVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate {
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: 500,
                                            longitudinalMeters: 500)
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
        mapView.overrideUserInterfaceStyle = .light
        view.addSubview(notesView)
        notesView.effect = UIBlurEffect(style: UIBlurEffect.Style.light)
        notesView.clipsToBounds = true
        
        
        view.addSubview(trackerBar)
        view.addSubview(calculationsView)
        calculationsView.effect = UIBlurEffect(style: UIBlurEffect.Style.light)
        calculationsView.clipsToBounds = true
        
        view.addSubview(tabBar)
        
        view.addSubview(splashScreen)

        setMapGradient()
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        trackerBar.translatesAutoresizingMaskIntoConstraints = false
        calculationsView.translatesAutoresizingMaskIntoConstraints = false
        notesView.translatesAutoresizingMaskIntoConstraints = false
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        splashScreen.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            
            
            
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            trackerBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackerBar.topAnchor.constraint(equalTo: 
                                            view.safeAreaLayoutGuide.topAnchor,
                                            constant: 10),
            trackerBar.heightAnchor.constraint(equalToConstant:
                                            CGFloat.headerBarHeight),
            trackerBar.widthAnchor.constraint(equalToConstant:
                                            CGFloat.barWidth),
            
            calculationsView.widthAnchor.constraint(equalToConstant: CGFloat.barWidth),
            calculationsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            calculationsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calculationsView.topAnchor.constraint(equalTo: trackerBar.bottomAnchor,
                                            constant: 10),
            
            notesView.widthAnchor.constraint(equalToConstant: CGFloat.barWidth),
            notesView.topAnchor.constraint(equalTo:
                                            view.safeAreaLayoutGuide.topAnchor,
                                            constant: CGFloat.headerBarHeight + 20),
            notesView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notesView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                            constant: -20),
            
            tabBar.widthAnchor.constraint(equalToConstant: .barWidth),
            tabBar.heightAnchor.constraint(equalToConstant: .tabBarHeight),
            tabBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                            constant: -20),
            
            splashScreen.topAnchor.constraint(equalTo: view.topAnchor),
            splashScreen.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            splashScreen.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            splashScreen.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }
    
    //MARK: - SetMapGradient
    
    private func setMapGradient() {
        let topGradient = CAGradientLayer()
        let bottomGradient = CAGradientLayer()
        
        topGradient.frame = CGRect(x: 0,
                                   y: 0,
                                   width: UIScreen.main.bounds.width ,
                                   height: UIScreen.main.bounds.height)
        bottomGradient.frame = CGRect(x: 0,
                                   y: 0,
                                      width: UIScreen.main.bounds.width,
                                      height: UIScreen.main.bounds.height)
        
        
        
        topGradient.startPoint = CGPoint(x: 0, y: 0)
        topGradient.endPoint = CGPoint(x: 0, y: 0.4)
        topGradient.colors = [UIColor.white.cgColor,
                              UIColor.white.withAlphaComponent(0).cgColor]
        
        
        bottomGradient.startPoint = CGPoint(x: 0, y: 1)
        bottomGradient.endPoint = CGPoint(x: 0, y: 0.6)
        bottomGradient.colors = [UIColor.white.cgColor,
                                 UIColor.white.withAlphaComponent(0).cgColor]
        
        
        mapView.layer.addSublayer(topGradient)
        mapView.layer.addSublayer(bottomGradient)

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
