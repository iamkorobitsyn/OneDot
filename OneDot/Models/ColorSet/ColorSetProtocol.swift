//
//  ColorSet.swift
//  OneDot
//
//  Created by Александр Коробицын on 08.11.2023.
//

import Foundation
import UIKit

protocol ColorSetProtocol {
    
    var mainDynamic: UIColor {get}
    var titleDynamic: UIColor {get}
    var specialDynamic: UIColor {get}
    
    var deep: UIColor {get}
    var light: UIColor {get}
    var special: UIColor {get}
}
