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
    static let myPaletteBlue: UIColor = .init(r: 82, g: 130, b: 176, alpha: 1)
    static let myPaletteRed: UIColor = .init(r: 228, g: 89, b: 96, alpha: 1)
    static let myPaletteGold: UIColor = .init(r: 248, g: 166, b: 25, alpha: 1)
    static let myPaletteGreen: UIColor = .init(r: 68, g: 179, b: 57, alpha: 1)
    
    static let myPaletteWhiteBackground: UIColor = .init(r: 241, g: 241, b: 241, alpha: 1)
    
}
