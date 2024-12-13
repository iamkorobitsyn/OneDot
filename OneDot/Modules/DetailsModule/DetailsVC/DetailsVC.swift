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
        view.layer.cornerRadius = .barCorner
        view.layer.cornerCurve = .continuous
        view.layer.borderWidth = 0.3
        view.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
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
    
    let blurEffectView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.disableAutoresizingMask()
        view.effect = UIBlurEffect(style: .extraLight)
        view.layer.cornerRadius = 10
        return view
    }()
    
    let screenshotBottomBar: ScreenshotBottonBar = {
        let view = ScreenshotBottonBar()
        view.disableAutoresizingMask()
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
        default:
            break
        }
    }
    
    //MARK: - SetScreenshot
    
    private func makeScreenShot() -> UIImage {
        blurEffectView.layer.cornerRadius = 0
        [backButton, hideButton].forEach( {$0.isHidden = true} )
        
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        
        let screenshot = renderer.image { context in
            view.layer.render(in: context.cgContext)
        }
        
        blurEffectView.layer.cornerRadius = .barCorner
        [backButton, hideButton].forEach( {$0.isHidden = false} )
        
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
        
        view.addSubview(blurEffectView)
        view.addSubview(mapView)
        view.addSubview(backButton)
        view.addSubview(hideButton)
        view.addSubview(screenshotBottomBar)
        view.addSubview(testLabel)
        
        [backButton, hideButton].forEach { button in
            button.addTarget(self, action: #selector(buttonTapped(_: )), for: .touchUpInside)
        }
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            mapView.widthAnchor.constraint(equalToConstant: .barWidth),
            mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            screenshotBottomBar.widthAnchor.constraint(equalToConstant: .barWidth),
            screenshotBottomBar.heightAnchor.constraint(equalToConstant: .tabBarHeight),
            screenshotBottomBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            screenshotBottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            backButton.widthAnchor.constraint(equalToConstant: 42),
            backButton.heightAnchor.constraint(equalToConstant: 42),
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            hideButton.widthAnchor.constraint(equalToConstant: 42),
            hideButton.heightAnchor.constraint(equalToConstant: 42),
            hideButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            hideButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            testLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            
        ])
    }
}

extension DetailsVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .myPaletteGold
        renderer.lineWidth = 4
        return renderer
    }
}
