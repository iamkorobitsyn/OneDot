//
//  TraitCollectionManager.swift
//  OneDot
//
//  Created by Александр Коробицын on 10.11.2023.
//

import Foundation
import UIKit

enum Theme: Int {
    case device,
         light,
         dark
    
    func getUserInterfaceStyle() -> UIUserInterfaceStyle {
        switch self {
            
        case .device:
            return .unspecified
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

class TraitCollectionManager {
    static let shared = TraitCollectionManager()
    
    var theme: Theme {
        get {
            Theme(rawValue: UserDefaults.standard.integer(forKey: "selectedTheme")) ?? .device
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "selectedTheme")
        }
    }
}
