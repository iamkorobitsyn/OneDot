//
//  FactoryColorSet.swift
//  OneDot
//
//  Created by Александр Коробицын on 08.11.2023.
//

import Foundation
import UIKit

enum State {
    case sunsetSky
}

class FactoryColorSet {
    
    static let shared = FactoryColorSet()
    
    func get(_ state: State) -> ColorSetProtocol {
        switch state {
        case .sunsetSky:
            return SunsetSkyColorSet()
        }
    }
}
