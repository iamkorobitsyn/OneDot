//
//  UIColor + Extansions.swift
//  OneDot
//
//  Created by Александр Коробицын on 08.07.2023.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: alpha)
    }
    
    static let myPaletteGray: UIColor = .init(r: 86, g: 86, b: 86, alpha: 1)
    static let myPaletteBlue: UIColor = .init(r: 105, g: 144, b: 181, alpha: 1)
    static let myPaletteRed: UIColor = .init(r: 193, g: 73, b: 79, alpha: 1)
    static let myPaletteGold: UIColor = .init(r: 230, g: 166, b: 55, alpha: 1)
    
    static let myPaletteWhiteBackground: UIColor = .init(r: 241, g: 241, b: 241, alpha: 1)
    
}
