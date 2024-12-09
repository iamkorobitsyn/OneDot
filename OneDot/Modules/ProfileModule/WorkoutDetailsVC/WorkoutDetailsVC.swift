//
//  WorkoutDetailsVC.swift
//  OneDot
//
//  Created by Александр Коробицын on 07.12.2024.
//

import Foundation
import UIKit
import Photos

class WorkoutDetailsVC: UIViewController {
    
    let hapticGenerator = UISelectionFeedbackGenerator()
    
    let backView: UIView = {
        let view = UIView()
        view.disableAutoresizingMask()
        view.backgroundColor = .myPaletteWhiteBackground
        view.layer.cornerRadius = .barCorner
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
        setViews()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    @objc private func buttonTapped(_ button: UIButton) {
        hapticGenerator.selectionChanged()
        
        switch button {
        case backButton:
            print("work")
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
    
    private func setViews() {
        view.addSubview(backView)
        view.addSubview(testLabel)
        
        [backButton, hideButton, screenShotButton, settingsButton, appearanceButton].forEach { button in
            view.addSubview(button)
            button.addTarget(self, action: #selector(buttonTapped(_: )), for: .touchUpInside)
        }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: view.topAnchor),
            backView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            backButton.widthAnchor.constraint(equalToConstant: 42),
            backButton.heightAnchor.constraint(equalToConstant: 42),
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            hideButton.widthAnchor.constraint(equalToConstant: 42),
            hideButton.heightAnchor.constraint(equalToConstant: 42),
            hideButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            hideButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            screenShotButton.widthAnchor.constraint(equalToConstant: 42),
            screenShotButton.heightAnchor.constraint(equalToConstant: 42),
            screenShotButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            screenShotButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            
            settingsButton.widthAnchor.constraint(equalToConstant: 42),
            settingsButton.heightAnchor.constraint(equalToConstant: 42),
            settingsButton.centerYAnchor.constraint(equalTo: screenShotButton.centerYAnchor),
            settingsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -view.frame.width / 4),
            
            appearanceButton.widthAnchor.constraint(equalToConstant: 42),
            appearanceButton.heightAnchor.constraint(equalToConstant: 42),
            appearanceButton.centerYAnchor.constraint(equalTo: screenShotButton.centerYAnchor),
            appearanceButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.frame.width / 4),
            
            testLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            
        ])
    }
}
