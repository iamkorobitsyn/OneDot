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
    
    static var custom = FactoryColorSet.shared.get(.sunsetSky)
    
    //MARK: - SunsetSky
    
    static let sunsetSkyMainDynamic = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
            
        case .dark:
            return .init(r: 95, g: 134, b: 171, alpha: 1)
        default:
            return .init(r: 114, g: 148, b: 180, alpha: 1)
        }
    }
    
    static let sunsetSkyTitleDynamic = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
            
        case .dark:
            return .init(r: 255, g: 255, b: 255, alpha: 1)
        default:
            return .black
        }
    }
    
    static let sunsetSkySpecialDynamic = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
            
        case .dark:
                .clear
        default:
                .clear
        }
    }
    
    static let sunsetSkyDeep: UIColor = .init(r: 114, g: 148, b: 180, alpha: 1)
    static let sunsetSkyLight: UIColor = .init(r: 135, g: 164, b: 192, alpha: 1)
    
    static let sunsetSkySpecial: UIColor = .clear
    
    
    
    
    
    static let whiteGraphiteColor: UIColor = .init(r: 247, g: 245, b: 244, alpha: 1)
    static let blackGraphiteColor: UIColor = .init(r: 23, g: 21, b: 27, alpha: 1)
    
    static let sunriseColor: UIColor = .init(r: 242, g: 245, b: 248, alpha: 1)
    static let sunriseDeepColor: UIColor = .init(r: 161, g: 184, b: 206, alpha: 1)
    static let sunsetSkyColor: UIColor = .init(r: 114, g: 148, b: 180, alpha: 1)
    
    static let lightPurpleColor: UIColor = .init(r: 244, g: 240, b: 245, alpha: 1)
    static let deepPurpleColor: UIColor = .init(r: 187, g: 143, b: 208, alpha: 1)
    
    static let drySandColor: UIColor = .init(r: 253, g: 244, b: 234, alpha: 1)
    static let wetSandColor: UIColor = .init(r: 219, g: 161, b: 94, alpha: 1)
    
    static let lightForestColor: UIColor = .init(r: 237, g: 253, b: 243, alpha: 1)
    static let deepForestColor: UIColor = .init(r: 65, g: 191, b: 116, alpha: 1)
    
    static let morningSeaColor: UIColor = .init(r: 231, g: 246, b: 246, alpha: 1)
    static let eveningSeaColor: UIColor = .init(r: 97, g: 199, b: 197, alpha: 1)
    
    static let customRed: UIColor = .init(r: 211, g: 53, b: 68, alpha: 1)
    static let customWhite: UIColor = .init(r: 247, g: 245, b: 244, alpha: 1)
    static let customBlack: UIColor = .init(r: 23, g: 21, b: 27, alpha: 1)
    
    static let specialBeigeColor: UIColor = .init(r: 248, g: 244, b: 233, alpha: 1)
    static let specialGrayColor: UIColor = .init(r: 128, g: 128, b: 128, alpha: 1)

}
