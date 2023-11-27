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
    let toolsBar: ToolsBarView = ToolsBarView()
    
    var tabBarCompletion: ((Bool)->())?
    
    //MARK: - Metrics
    
    let mainBarWidth: CGFloat = UIScreen.main.bounds.width / 1.05
    let mainBarHeight: CGFloat = 130
    let mainBarCorner: CGFloat = 30

    override func viewDidLoad() {
        super.viewDidLoad()

        setViews()
        
        setConstraints()
        setupLocationManager()
        checkLocationEnabled()

        getUserDefaults()

        showToolBar()
        
        
        for cell in toolsBar.themesVC.currentRows {
            if let themesCell = cell as? ColorThemeViewCell {
                themesCell.mainVCColorSetDelegate = self
            }
        }
    }

    
    private func getUserDefaults() {
        let value = UserDefaultsManager.shared.selectorLoad()
        if value == "street" {
            title = "MAP"
            trackerBar.locationTitle.text = "Outdoor"
            trackerBar.picker.currentLocation = "street"
            trackerBar.picker.picker.reloadAllComponents()
            let currentRow = UserDefaultsManager.shared.onTheStreetLoad()
            trackerBar.picker.picker.selectRow(currentRow, inComponent: 0, animated: true)
            trackerBar.currentExercise = trackerBar.exercises.get(.street)[currentRow]
            trackerBar.picker.title.text = trackerBar.currentExercise?.titleName
            trackerBar.picker.titleView.image = UIImage(named: trackerBar.currentExercise?.titleIcon ?? "")
            
            trackerBar.outdoorButton.setActiveState(.indoor)
            trackerBar.indoorButton.setInactiveState(.outdoor)
            print(value)
            
            
        } else if value == "room" {
            title = "NOTES"
            trackerBar.locationTitle.text = "Indoor"
            trackerBar.picker.currentLocation = "room"
            trackerBar.picker.picker.reloadAllComponents()
            let currentRow = UserDefaultsManager.shared.inRoomLoad()
            trackerBar.picker.picker.selectRow(currentRow, inComponent: 0, animated: true)
            trackerBar.currentExercise = trackerBar.exercises.get(.room)[currentRow]
            trackerBar.picker.title.text = trackerBar.currentExercise?.titleName
            trackerBar.picker.titleView.image = UIImage(named: trackerBar.currentExercise?.titleIcon ?? "")
            
            trackerBar.indoorButton.setActiveState(.outdoor)
            trackerBar.outdoorButton.setInactiveState(.indoor)
        }
    }
    
    
    private func showToolBar() {
        
 
        trackerBar.completion = { [weak self] button in
            guard let self else {return}
            
            if button == trackerBar.calculatorButton {

                toolsBar.showVC(.calculator)

                trackerBar.statesRefresh(locations: false, tools: true)
                trackerBar.calculatorButton.setActiveState(.calculator)
                trackerBar.toolsTitle.text = "Calculator"
                
                guard toolsBar.isHidden == true else {return}
                toolsBar.isHidden = false
                Animator.shared.toolsBarShow(toolsBar)
                toolsBar.showTabBarCompletion?(false)
                
            } else if button == trackerBar.soundButton {
                
                toolsBar.showVC(.sound)
                
                trackerBar.statesRefresh(locations: false, tools: true)
                trackerBar.soundButton.setActiveState(.sound)
                trackerBar.toolsTitle.text = "Sound"
                
                guard toolsBar.isHidden == true else {return}
                toolsBar.isHidden = false
                Animator.shared.toolsBarShow(toolsBar)
                toolsBar.showTabBarCompletion?(false)
                
            } else if button == trackerBar.themesButton {
                
                toolsBar.showVC(.themes)
                
                trackerBar.statesRefresh(locations: false, tools: true)
                trackerBar.themesButton.setActiveState(.themes)
                trackerBar.toolsTitle.text = "Themes"
                
                guard toolsBar.isHidden == true else {return}
                toolsBar.isHidden = false
                Animator.shared.toolsBarShow(toolsBar)
                toolsBar.showTabBarCompletion?(false)

            } else if button == trackerBar.settingsButton {
                
                toolsBar.showVC(.settings)
                
                trackerBar.statesRefresh(locations: false, tools: true)
                trackerBar.settingsButton.setActiveState(.settings)
                trackerBar.toolsTitle.text = "Settings"
                
                guard toolsBar.isHidden == true else {return}
                toolsBar.isHidden = false
                Animator.shared.toolsBarShow(toolsBar)
                toolsBar.showTabBarCompletion?(false)
                
            } else if button == trackerBar.indoorButton {
                title = "NOTES"
            } else if button == trackerBar.outdoorButton {
                title = "MAP"
            }
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
        
        view.addSubview(toolsBar)
        view.addSubview(trackerBar)
        
        setMapGradient()
        
        
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        trackerBar.translatesAutoresizingMaskIntoConstraints = false
        toolsBar.translatesAutoresizingMaskIntoConstraints = false

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
                                            mainBarHeight),
            trackerBar.widthAnchor.constraint(equalToConstant:
                                            mainBarWidth),
            
            toolsBar.widthAnchor.constraint(equalToConstant: mainBarWidth),
            toolsBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            toolsBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toolsBar.topAnchor.constraint(equalTo: trackerBar.bottomAnchor,
                                            constant: 10)
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

extension MainVC: MainVCColorSetProtocol {
    func update(_ set: ColorSetProtocol, _ barBGIsHidden: Bool) {
        trackerBar.updateColors(set)
        
        for cell in toolsBar.settingsVC.currentRows {
            if let measuring = cell as? MeasuringViewCell {
                measuring.updateColors(set)
            }
            if let notifications = cell as? NotificationsViewCell {
                notifications.updateColors(set)
            }
            if let connections = cell as? ConnectionsViewCell {
                connections.updateColors(set)
            }
        }
    }
}

