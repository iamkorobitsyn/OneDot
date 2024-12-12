//
//  WorkoutDetailsVC.swift
//  OneDot
//
//  Created by Александр Коробицын on 07.12.2024.
//

import Foundation
import UIKit
import Photos
import MapKit

class DetailsVC: UIViewController {
    
    let hapticGenerator = UISelectionFeedbackGenerator()
    
    let mapView: MKMapView = {
        let view = MKMapView()
        view.disableAutoresizingMask()
        return view
    }()
    
    var coordinates: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 55.899390,
                               longitude: 37.278832),
        CLLocationCoordinate2D(latitude: 55.900521,
                               longitude: 37.280463),
        CLLocationCoordinate2D(latitude: 55.901531,
                               longitude: 37.281836),
        CLLocationCoordinate2D(latitude: 55.902662,
                               longitude: 37.283553),
        CLLocationCoordinate2D(latitude: 55.903336,
                               longitude: 37.285527),
        CLLocationCoordinate2D(latitude: 55.903588,
                               longitude: 37.286975),
        CLLocationCoordinate2D(latitude: 55.903642,
                               longitude: 37.287887),
        CLLocationCoordinate2D(latitude: 55.903738,
                               longitude: 37.288703),
        CLLocationCoordinate2D(latitude: 55.903816,
                               longitude: 37.289454),
        CLLocationCoordinate2D(latitude: 55.903925,
                               longitude: 37.290055),
        CLLocationCoordinate2D(latitude: 55.904069,
                               longitude: 37.290698),
        CLLocationCoordinate2D(latitude: 55.904273,
                               longitude: 37.291439),
        CLLocationCoordinate2D(latitude: 55.904484,
                               longitude: 37.292361),
        CLLocationCoordinate2D(latitude: 55.904658,
                               longitude: 37.293145)
    ]
    
    let backView: UIView = {
        let view = UIView()
        view.disableAutoresizingMask()
        view.backgroundColor = .myPaletteWhiteBackground
        view.layer.cornerRadius = .barCorner
        return view
    }()
    
    let topBlurView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.disableAutoresizingMask()
        view.clipsToBounds = true
        view.effect = UIBlurEffect(style: .light)
        view.layer.cornerRadius = 10
        view.layer.cornerCurve = .continuous
        view.layer.borderWidth = 0.3
        view.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        return view
    }()
    
    let bottomBlurView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.disableAutoresizingMask()
        view.clipsToBounds = true
        view.effect = UIBlurEffect(style: .light)
        view.layer.cornerRadius = .barCorner
        view.layer.cornerCurve = .continuous
        view.layer.borderWidth = 0.3
        view.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.disableAutoresizingMask()
        button.setImage(UIImage(named: "DSBackGray"), for: .normal)
        return button
    }()
    
    private let hideButton: UIButton = {
        let button = UIButton()
        button.disableAutoresizingMask()
        button.setImage(UIImage(named: "DSHideGray"), for: .normal)
        return button
    }()
    
    private let screenShotButton: UIButton = {
        let button = UIButton()
        button.disableAutoresizingMask()
        button.setImage(UIImage(named: "DSScreenshotGray"), for: .normal)
        return button
    }()
    
    private let settingsButton: UIButton = {
        let button = UIButton()
        button.disableAutoresizingMask()
        button.setImage(UIImage(named: "DSSettingsGray"), for: .normal)
        return button
    }()
    
    private let appearanceButton: UIButton = {
        let button = UIButton()
        button.disableAutoresizingMask()
        button.setImage(UIImage(named: "DSAppearanceGray"), for: .normal)
        return button
    }()
    
    private let testLabel: UILabel = {
        let label = UILabel()
        label.disableAutoresizingMask()
        label.text = "TEST SCREENSHOT"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
 
        setViews()
        setConstraints()

        MapKitManager.shared.drawMapPolyline(mapView: mapView, coordinates: coordinates)
        MapKitManager.shared.setMapRegion(mapView: mapView, coordinates: coordinates, scaleFactor: 1.7)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    

    
    //MARK: - ButtonTapped
    
    @objc private func buttonTapped(_ button: UIButton) {
        hapticGenerator.selectionChanged()
        
        switch button {
        case backButton:
            navigationController?.popViewController(animated: true)
            backButton.isHidden = true
            
        case hideButton:
            self.dismiss(animated: true)
            
        case screenShotButton:
            let screensot = makeScreenShot()
            saveScreenshotToGallery(image: screensot)
            addScreenshotEffect()
        default:
            break
        }
    }
    
    //MARK: - SetScreenshot
    
    private func makeScreenShot() -> UIImage {
        backView.layer.cornerRadius = 0
        [backButton, hideButton, screenShotButton, settingsButton, appearanceButton].forEach( {$0.isHidden = true} )
        
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        
        let screenshot = renderer.image { context in
            view.layer.render(in: context.cgContext)
        }
        
        backView.layer.cornerRadius = .barCorner
        [backButton, hideButton, screenShotButton, settingsButton, appearanceButton].forEach( {$0.isHidden = false} )
        
        return screenshot
    }
    
    private func saveScreenshotToGallery(image: UIImage) {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }) { success, error in
                    if success {
                        print("Скриншот сохранен в галерее.")
                    } else if let error = error {
                        print("Ошибка при сохранении скриншота: \(error.localizedDescription)")
                    }
                }
            } else {
                print("Нет доступа к фотогалерее.")
        }
        }
    }
    
    private func addScreenshotEffect() {
        
        let flashView = UIView()
        flashView.frame = view.bounds
        flashView.backgroundColor = .white
        view.addSubview(flashView)
        
        let alert = UIAlertController(title: nil,
                                      message: "\nSaved to gallery\n\n",
                                      preferredStyle: .actionSheet)
        
        UIView.animate(withDuration: 0.2) {
            flashView.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 1) {
                self.present(alert, animated: true)
                flashView.alpha = 0
            } completion: { _ in
                flashView.removeFromSuperview()
                alert.dismiss(animated: true)
            }
        }
    }
    
    //MARK: - SetViews
    
    private func setViews() {
        
        view.addSubview(backView)
        view.addSubview(mapView)
        view.addSubview(topBlurView)
        topBlurView.contentView.addSubview(backButton)
        topBlurView.contentView.addSubview(hideButton)
        view.addSubview(bottomBlurView)
        bottomBlurView.contentView.addSubview(screenShotButton)
        bottomBlurView.contentView.addSubview(settingsButton)
        bottomBlurView.contentView.addSubview(appearanceButton)
        view.addSubview(testLabel)
        
        [backButton, hideButton, screenShotButton, settingsButton, appearanceButton].forEach { button in
            button.addTarget(self, action: #selector(buttonTapped(_: )), for: .touchUpInside)
        }
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: view.topAnchor),
            backView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            topBlurView.widthAnchor.constraint(equalToConstant: 250),
            topBlurView.heightAnchor.constraint(equalToConstant: 42),
            topBlurView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topBlurView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            
            bottomBlurView.widthAnchor.constraint(equalToConstant: .barWidth),
            bottomBlurView.heightAnchor.constraint(equalToConstant: .tabBarHeight),
            bottomBlurView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomBlurView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            backButton.widthAnchor.constraint(equalToConstant: 42),
            backButton.heightAnchor.constraint(equalToConstant: 42),
            backButton.centerYAnchor.constraint(equalTo: topBlurView.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: topBlurView.leadingAnchor, constant: 10),
            
            hideButton.widthAnchor.constraint(equalToConstant: 42),
            hideButton.heightAnchor.constraint(equalToConstant: 42),
            hideButton.centerYAnchor.constraint(equalTo: topBlurView.centerYAnchor),
            hideButton.trailingAnchor.constraint(equalTo: topBlurView.trailingAnchor, constant: -10),
            
            screenShotButton.widthAnchor.constraint(equalToConstant: 42),
            screenShotButton.heightAnchor.constraint(equalToConstant: 42),
            screenShotButton.centerXAnchor.constraint(equalTo: bottomBlurView.centerXAnchor),
            screenShotButton.centerYAnchor.constraint(equalTo: bottomBlurView.centerYAnchor),
            
            settingsButton.widthAnchor.constraint(equalToConstant: 42),
            settingsButton.heightAnchor.constraint(equalToConstant: 42),
            settingsButton.centerYAnchor.constraint(equalTo: bottomBlurView.centerYAnchor),
            settingsButton.leadingAnchor.constraint(equalTo: bottomBlurView.leadingAnchor, constant: 40),
            
            appearanceButton.widthAnchor.constraint(equalToConstant: 42),
            appearanceButton.heightAnchor.constraint(equalToConstant: 42),
            appearanceButton.centerYAnchor.constraint(equalTo: bottomBlurView.centerYAnchor),
            appearanceButton.trailingAnchor.constraint(equalTo: bottomBlurView.trailingAnchor, constant: -40),
            
            testLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            
        ])
    }
}

extension DetailsVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .systemBlue
        renderer.lineWidth = 5
        return renderer
    }
}
