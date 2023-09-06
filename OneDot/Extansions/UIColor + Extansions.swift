//
//  UIColor + Extansions.swift
//  OneDot
//
//  Created by Александр Коробицын on 08.07.2023.
//

import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: alpha)
    }
    
    static let customBlueLight: UIColor = .init(r: 229, g: 236, b: 242, alpha: 1)
    static let customBlueMid: UIColor = .init(r: 171, g: 193, b: 211, alpha: 1)
    static let customBlueDeep: UIColor = .init(r: 114, g: 148, b: 180, alpha: 1)
    static let customRed: UIColor = .init(r: 211, g: 53, b: 68, alpha: 1)
    static let customWhite: UIColor = .init(r: 247, g: 245, b: 244, alpha: 1)
    static let customBlack: UIColor = .init(r: 23, g: 21, b: 27, alpha: 1)
}
