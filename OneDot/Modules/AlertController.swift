//
//  AlertController.swift
//  OneDot
//
//  Created by Александр Коробицын on 06.09.2023.
//

import UIKit

class Alert: UIAlertController {
    
    convenience init(title: String,
                     message: String,
                     style: UIAlertController.Style,
                     url: String) {
        self.init(title: title, message: message, preferredStyle: style)
        
        let settingsButton = UIAlertAction(title: "Настройки", style: .destructive) { action in
            if let url = URL(string: url) {
                UIApplication.shared.open(url)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        self.addAction(settingsButton)
        self.addAction(cancelAction)
        
    }
}
