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
    let mainBarHeader: MainBarHeader = MainBarHeader()
    let mainBarBody: MainBarBodyBase = MainBarBodyBase()
    let settingsViewController = SettingsVC()
    
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

        setViewsCompletion()
        
        mainBarBody.colorThemesView.mainVCDelegate = self
        
        let button = UIBarButtonItem(image: UIImage(named: "settingsButton"), style: .done, target: self, action: nil)
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = button

    }

    
    private func getUserDefaults() {
        let value = UserDefaultsManager.shared.selectorLoad()
        if value == "street" {
            title = "MAP"
            mainBarHeader.locationTitle.text = "Outdoor"
            mainBarHeader.picker.currentLocation = "street"
            mainBarHeader.picker.picker.reloadAllComponents()
            let currentRow = UserDefaultsManager.shared.onTheStreetLoad()
            mainBarHeader.picker.picker.selectRow(currentRow, inComponent: 0, animated: true)
            mainBarHeader.currentExercise = mainBarHeader.exercises.get(.street)[currentRow]
            mainBarHeader.picker.title.text = mainBarHeader.currentExercise?.titleName
            mainBarHeader.picker.titleView.image = UIImage(named: mainBarHeader.currentExercise?.titleIcon ?? "")
            
            mainBarHeader.outdoorButton.setActiveState(.onTheStreet)
            mainBarHeader.indoorButton.setInactiveState(.inRoom)
            print(value)
            
            
        } else if value == "room" {
            title = "NOTES"
            mainBarHeader.locationTitle.text = "Indoor"
            mainBarHeader.picker.currentLocation = "room"
            mainBarHeader.picker.picker.reloadAllComponents()
            let currentRow = UserDefaultsManager.shared.inRoomLoad()
            mainBarHeader.picker.picker.selectRow(currentRow, inComponent: 0, animated: true)
            mainBarHeader.currentExercise = mainBarHeader.exercises.get(.room)[currentRow]
            mainBarHeader.picker.title.text = mainBarHeader.currentExercise?.titleName
            mainBarHeader.picker.titleView.image = UIImage(named: mainBarHeader.currentExercise?.titleIcon ?? "")
            
            mainBarHeader.indoorButton.setActiveState(.inRoom)
            mainBarHeader.outdoorButton.setInactiveState(.onTheStreet)
        }
    }
    
    
    private func setViewsCompletion() {
        mainBarBody.completion = { [weak self] in
            guard let self else {return}
            mainBarHeader.toolsTitle.text = ""
            mainBarHeader.setButtonsStates(false, true)
            tabBarCompletion?(false)
        }
        
        
        
        mainBarHeader.completion = { [weak self] button in
            guard let self else {return}
            
            if button == mainBarHeader.calculatorButton {
                mainBarBody.setStatesFor(mainBarBody.calculatorStack,
                                         UserDefaultsManager.shared.calculatorViewLoad())
                
                mainBarHeader.toolsTitle.text = "Calculator"
                mainBarHeader.setButtonsStates(false, true)
                mainBarHeader.calculatorButton.setActiveState(.calculator)
                guard mainBarBody.isHidden == true else {return}
                mainBarBody.isHidden = false
                Animator.shared.MainBarBodyShow(mainBarBody)
                tabBarCompletion?(true)
                
            } else if button == mainBarHeader.soundButton {
                mainBarBody.setStatesFor(mainBarBody.soundStack,
                                         UserDefaultsManager.shared.soundViewLoad())
                
                mainBarHeader.toolsTitle.text = "Sound"
                mainBarHeader.setButtonsStates(false, true)
                mainBarHeader.soundButton.setActiveState(.sound)
                guard mainBarBody.isHidden == true else {return}
                mainBarBody.isHidden = false
                Animator.shared.MainBarBodyShow(mainBarBody)
                tabBarCompletion?(true)
                
            } else if button == mainBarHeader.themesButton {
                mainBarBody.setStatesFor(mainBarBody.themesStack,
                                         UserDefaultsManager.shared.themesViewLoad())
                
                mainBarHeader.toolsTitle.text = "Themes"
                mainBarHeader.setButtonsStates(false, true)
                mainBarHeader.themesButton.setActiveState(.themes)
                guard mainBarBody.isHidden == true else {return}
                mainBarBody.isHidden = false
                Animator.shared.MainBarBodyShow(mainBarBody)
                tabBarCompletion?(true)
                
            } else if button == mainBarHeader.indoorButton {
                title = "NOTES"
            } else if button == mainBarHeader.outdoorButton {
                title = "MAP"
            }
        }
    }
    
    @objc private func presentSettings() {
        present(settingsViewController, animated: true)
        settingsViewController.modalPresentationStyle = .overFullScreen
        
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
        
        view.addSubview(mainBarBody)
        view.addSubview(mainBarHeader)
        
        setMapGradient()
        
        
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mainBarHeader.translatesAutoresizingMaskIntoConstraints = false
        mainBarBody.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            mainBarHeader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainBarHeader.topAnchor.constraint(equalTo: 
                                            view.safeAreaLayoutGuide.topAnchor,
                                            constant: 10),
            mainBarHeader.heightAnchor.constraint(equalToConstant:
                                            mainBarHeight),
            mainBarHeader.widthAnchor.constraint(equalToConstant:
                                            mainBarWidth),
            
            mainBarBody.widthAnchor.constraint(equalToConstant: mainBarWidth),
            mainBarBody.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            mainBarBody.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainBarBody.topAnchor.constraint(equalTo: mainBarHeader.bottomAnchor,
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
        mainBarHeader.updateColors(set)
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem?.tintColor = .label
    }
}

