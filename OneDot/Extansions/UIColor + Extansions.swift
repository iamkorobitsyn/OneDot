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

    
    static let colorList = FactoryColorSet.shared.get()
    static var currentColorSet = colorList[ColorIndexManager.shared.colorIndex ?? 0]
    
    //MARK: - GrayMoon
    
    static let grayMoonMainDynamic = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
            
        case .dark:
            return .init(r: 41, g: 45, b: 48, alpha: 1)
        default:
            return .init(r: 84, g: 92, b: 99, alpha: 1)
        }
    }
    
    static let grayMoonTitleDynamic = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
            
        case .dark:
            return .init(r: 255, g: 255, b: 255, alpha: 1)
        default:
            return .init(r: 84, g: 92, b: 99, alpha: 1)
        }
    }
    
    static let grayMoonDeep: UIColor = .init(r: 41, g: 45, b: 48, alpha: 1)
    static let grayMoonLight: UIColor = .init(r: 84, g: 92, b: 99, alpha: 1)
    
    
    
    
    
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
            return .init(r: 114, g: 148, b: 180, alpha: 1)
        }
    }
    
    static let sunsetSkyDeep: UIColor = .init(r: 114, g: 148, b: 180, alpha: 1)
    static let sunsetSkyLight: UIColor = .init(r: 135, g: 164, b: 192, alpha: 1)
    
    
    
    
    
    //MARK: - Graphite
    
    static let graphiteMainDynamic = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
            
        case .dark:
            return .init(r: 49, g: 44, b: 58, alpha: 1)
        default:
            return .init(r: 88, g: 79, b: 105, alpha: 1)
        }
    }
    
    static let graphiteTitleDynamic = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
            
        case .dark:
            return .init(r: 255, g: 255, b: 255, alpha: 1)
        default:
            return .init(r: 88, g: 79, b: 105, alpha: 1)
        }
    }
    
    static let graphiteDeep: UIColor = .init(r: 49, g: 44, b: 58, alpha: 1)
    static let graphiteLight: UIColor = .init(r: 88, g: 79, b: 105, alpha: 1)
    
    
    
    
    
    //MARK: - Sand
    
    static let sandMainDynamic = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
            
        case .dark:
            return .init(r: 184, g: 117, b: 40, alpha: 1)
        default:
            return .init(r: 211, g: 138, b: 54, alpha: 1)
        }
    }
    
    static let sandTitleDynamic = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
            
        case .dark:
            return .init(r: 255, g: 255, b: 255, alpha: 1)
        default:
            return .init(r: 211, g: 138, b: 54, alpha: 1)
        }
    }
    
    static let sandDeep: UIColor = .init(r: 184, g: 117, b: 40, alpha: 1)
    static let sandLight: UIColor = .init(r: 211, g: 138, b: 54, alpha: 1)
    
    
    
    
    
    //MARK: - Ultraviolet
    
    static let ultravioletMainDynamic = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
            
        case .dark:
            return .init(r: 85, g: 70, b: 142, alpha: 1)
        default:
            return .init(r: 108, g: 91, b: 174, alpha: 1)
        }
    }
    
    static let ultravioletTitleDynamic = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
            
        case .dark:
            return .init(r: 255, g: 255, b: 255, alpha: 1)
        default:
            return .init(r: 108, g: 91, b: 174, alpha: 1)
        }
    }
    
    static let ultravioletDeep: UIColor = .init(r: 85, g: 70, b: 142, alpha: 1)
    static let ultravioletLight: UIColor = .init(r: 108, g: 91, b: 174, alpha: 1)
    
    
    
    
    
    //MARK: - FirstSpecialColor
    
    static let firstSpecialTitleDynamic = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
            
        case .dark:
            return .init(r: 255, g: 255, b: 255, alpha: 1)
        default:
            return .init(r: 125, g: 185, b: 182, alpha: 1)
        }
    }
    
    static let firstSpecialDeep: UIColor = .init(r: 125, g: 185, b: 182, alpha: 1)
    static let firstSpecialMainSelector: UIColor = .init(r: 77, g: 69, b: 93, alpha: 1)
    static let firstSpecialAdditionalSelector: UIColor = .init(r: 98, g: 146, b: 186, alpha: 1)
    static let firstSpecialTabBar: UIColor = .init(r: 233, g: 100, b: 121, alpha: 1)
    
    
    //MARK: - SecondSpecialColor
    
    static let secondSpecialTitleDynamic = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
            
        case .dark:
            return .init(r: 255, g: 255, b: 255, alpha: 1)
        default:
            return .init(r: 255, g: 143, b: 69, alpha: 1)
        }
    }
    
    static let secondSpecialDeep: UIColor = .init(r: 140, g: 192, b: 222, alpha: 1)
    static let secondSpecialMainSelector: UIColor = .init(r: 154, g: 174, b: 187, alpha: 1)
    static let secondSpecialTabBar: UIColor = .init(r: 68, g: 192, b: 138, alpha: 1)
    
    
    
    //MARK: - ThirdSpecialColor
    
    static let thirdSpecialTitleDynamic = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
            
        case .dark:
            return .init(r: 255, g: 255, b: 255, alpha: 1)
        default:
            return .init(r: 235, g: 88, b: 111, alpha: 1)
        }
    }
    
    static let thirdSpecialDeep: UIColor = .init(r: 235, g: 88, b: 111, alpha: 1)
    static let thirdSpecialMainSelector: UIColor = .init(r: 69, g: 69, b: 83, alpha: 1)
    static let thirdSpecialTabBar: UIColor = .init(r: 74, g: 160, b: 213, alpha: 1)
    
    
    
    
    
    
    
    
    
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
