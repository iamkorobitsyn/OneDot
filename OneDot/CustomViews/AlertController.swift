//
//  AlertController.swift
//  OneDot
//
//  Created by Александр Коробицын on 06.09.2023.
//

import Foundation
import UIKit

class AlertController: UIAlertController {
    
    
    convenience init(title: String, message: String, url: String) {
        
        self.init(title: title, message: message, preferredStyle: .alert)
        
        let settingsButton = UIAlertAction(title: "Настройки", style: .default) { action in
            if let url = URL(string: url) {
                UIApplication.shared.open(url)
            }
        }
        
        let cancelButton = UIAlertAction(title: "Отмена", style: .cancel)
        
        self.addAction(settingsButton)
        self.addAction(cancelButton)
    }

}
