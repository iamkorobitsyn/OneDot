//
//  ViewController.swift
//  OneDot
//
//  Created by Александр Коробицын on 08.07.2023.
//

import UIKit
import MapKit

class MainVC: UIViewController {
    
    let mapView: MKMapView = MKMapView()
    let locationManager: CLLocationManager = CLLocationManager()
    
    let trackerBar: TrackerBarView = TrackerBarView()
    let notesBarView: NotesBarView = NotesBarView()
    let toolsBarView: ToolsBarView = ToolsBarView()
    
    var tabBarCompletion: ((Bool)->())?
    
    enum ToolsNotesStates {
        case indoor
        case outdoor
        case notes
        case calculator
        case sound
        case themes
        case settings
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        
        setConstraints()
        setupLocationManager()
        checkLocationEnabled()
        
        


        trackerBar.completionForActiveButton = { [weak self] button in
            guard let self else {return}
            
            if button == trackerBar.calculatorButton {
                setViewsState(.calculator)
            } else if button == trackerBar.soundButton {
                setViewsState(.sound)
            } else if button == trackerBar.themesButton {
                setViewsState(.themes)
            } else if button == trackerBar.settingsButton {
                setViewsState(.settings)
            } else if button == trackerBar.indoorButton {
                setViewsState(.indoor)
            } else if button == trackerBar.outdoorButton {
                setViewsState(.outdoor)
            } else if button == trackerBar.notesButton {
                setViewsState(.notes)
            }
        }
        
        notesBarView.completionOfHide = { [weak self] in
            guard let self else {return}
            trackerBar.notesButton.setInactiveState(.notesIndoor)
        }
        
        getLocationState(indoorIs: UserDefaultsManager.shared.userIndoorStatus)
        
        toolsBarView.calcuatorVC.titleCompletion = { [weak self] title in
            guard let self else {return}
            trackerBar.toolsTitle.text = title
        }
        
        toolsBarView.calcuatorVC.metronomeCell.mainVCBPMCompletion = { [weak self] isActive in
            guard let self else {return}
            if toolsBarView.isHidden == false{
                trackerBar.bpmLight.isHidden = false
                Animator.shared.pillingBPM(trackerBar.bpmLight)
            } else if toolsBarView.isHidden == false, toolsBarView.calcuatorVC.view.isHidden == false {
                trackerBar.bpmLight.isHidden = true
            } else if toolsBarView.isHidden == true {
                trackerBar.bpmLight.isHidden = false
                Animator.shared.pillingBPM(trackerBar.bpmLight)
            }
        }
    }
    
    private func getLocationState(indoorIs: Bool) {

        if indoorIs == true {
            title = "ROOM"
            notesBarView.isHidden = false
            notesBarView.setState(state: .indoor)
        } else {
            title = "MAP"
            notesBarView.isHidden = true
            notesBarView.setState(state: .outdoor)
        }
    }
    
    private func setViewsState(_ state: ToolsNotesStates) {
        switch state {
            
        case .indoor:
            getLocationState(indoorIs: true)
            UserDefaultsManager.shared.userIndoorStatus = true

        case .outdoor:
            getLocationState(indoorIs: false)
            UserDefaultsManager.shared.userIndoorStatus = false

        case .notes:
            
            notesBarView.isHidden = false
            
        case .calculator:
            toolsBarView.showVC(.calculator)

            toolsBarView.skipButton.isHidden = false
            guard toolsBarView.isHidden == true else {return}
            toolsBarView.isHidden = false
//            Animator.shared.toolsBarShow(toolsBar)
            toolsBarView.showTabBarCompletion?(false)
            
        case .sound:
            
            toolsBarView.showVC(.sound)
            toolsBarView.skipButton.isHidden = false
            guard toolsBarView.isHidden == true else {return}
            toolsBarView.isHidden = false
//            Animator.shared.toolsBarShow(toolsBar)
            toolsBarView.showTabBarCompletion?(false)
            
        case .themes:
            
            toolsBarView.showVC(.themes)
            toolsBarView.skipButton.isHidden = false
            guard toolsBarView.isHidden == true else {return}
            toolsBarView.isHidden = false
//            Animator.shared.toolsBarShow(toolsBar)
            toolsBarView.showTabBarCompletion?(false)
            
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
        title = "MAP"
        
        view.addSubview(mapView)
        mapView.overrideUserInterfaceStyle = .light
        view.addSubview(notesBarView)
        notesBarView.effect = UIBlurEffect(style: UIBlurEffect.Style.light)
        notesBarView.clipsToBounds = true
        
        
        view.addSubview(trackerBar)
        view.addSubview(toolsBarView)

        setMapGradient()
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        trackerBar.translatesAutoresizingMaskIntoConstraints = false
        toolsBarView.translatesAutoresizingMaskIntoConstraints = false
        notesBarView.translatesAutoresizingMaskIntoConstraints = false

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
            
            toolsBarView.widthAnchor.constraint(equalToConstant: CGFloat.barWidth),
            toolsBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            toolsBarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toolsBarView.topAnchor.constraint(equalTo: trackerBar.bottomAnchor,
                                            constant: 10),
            
            notesBarView.widthAnchor.constraint(equalToConstant: CGFloat.barWidth),
            notesBarView.topAnchor.constraint(equalTo:
                                            view.safeAreaLayoutGuide.topAnchor,
                                            constant: CGFloat.headerBarHeight + 20),
            notesBarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notesBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, 
                                            constant: -20)
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
