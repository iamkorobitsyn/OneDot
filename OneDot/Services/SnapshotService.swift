//
//  ScreenshotHelper.swift
//  OneDot
//
//  Created by Александр Коробицын on 14.12.2024.
//

import Foundation
import UIKit
import Photos

class SnapshotService {
    
    static let shared = SnapshotService()
    
    var shotStateHandler: ((Bool) -> Void)?
    
    private init() {}
    
    
    //MARK: - SetScreenshot
    
    func makeScreenShot(hiddenViews: [UIView], viewController: UIViewController) {

        hiddenViews.forEach { $0.isHidden = true }

        defer { hiddenViews.forEach { $0.isHidden = false } }

        let renderer = UIGraphicsImageRenderer(size: viewController.view.bounds.size)

        let screenshot = renderer.image { context in
            viewController.view.drawHierarchy(in: viewController.view.bounds, afterScreenUpdates: true)
        }

        saveScreenshotToGallery(image: screenshot)
        addScreenshotEffect(viewController: viewController)
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
    
    private func addScreenshotEffect(viewController: UIViewController) {
        
        let flashView = UIView()
        flashView.frame = viewController.view.bounds
        flashView.backgroundColor = .white
        viewController.view.addSubview(flashView)
        
        UIView.animate(withDuration: 0.2) {
            flashView.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 1.5) {
                
                self.shotStateHandler?(true)
                flashView.alpha = 0
            } completion: { _ in
                flashView.removeFromSuperview()
                self.shotStateHandler?(false)
            }
        }
    }
}
