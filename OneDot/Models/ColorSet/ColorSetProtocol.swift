//
//  ColorSet.swift
//  OneDot
//
//  Created by Александр Коробицын on 08.11.2023.
//

import Foundation
import UIKit

protocol ColorSetProtocol {
    
    var textTitle: String {get}
    
    var imageLight: String {get}
    var imageDeep: String {get}
    var imageSystem: String {get}
    
    var mainDynamicColor: UIColor {get}
    var titleDynamicColor: UIColor {get}
    var specialDynamicColor: UIColor {get}
    
    var mainSelectorColor: UIColor {get}
    var additionalSelectorColor: UIColor {get}
    
    var tabBarColor: UIColor {get}
    
    var deepColor: UIColor {get}
    var lightColor: UIColor {get}
    var specialColor: UIColor {get}
 
}
