//
//  UILabel + Extansions.swift
//  OneDot
//
//  Created by Александр Коробицын on 18.12.2024.
//

import Foundation
import UIKit

extension UILabel {
    
    enum Font {
        case thinCompSmall
        case thinCompMedium
        case thinCompLarge
        case boldCompSmall
        case boldCompMedium
        case boldCompLarge
        case boldCompExtraLarge
    }
    
    func instance(color: UIColor, alignment: NSTextAlignment, font: Font) {
        
        textColor = color
        textAlignment = alignment
        
        switch font {
        case .thinCompSmall:
            self.font = UIFont.systemFont(ofSize: 14, weight: .light, width: .compressed)
        case .thinCompMedium:
            self.font = UIFont.systemFont(ofSize: 18, weight: .light, width: .compressed)
        case .thinCompLarge:
            self.font = UIFont.systemFont(ofSize: 22, weight: .light, width: .compressed)
        case .boldCompSmall:
            self.font = UIFont.systemFont(ofSize: 18, weight: .medium, width: .compressed)
        case .boldCompMedium:
            self.font = UIFont.systemFont(ofSize: 20, weight: .medium, width: .compressed)
        case .boldCompLarge:
            self.font = UIFont.systemFont(ofSize: 22, weight: .medium, width: .compressed)
        case .boldCompExtraLarge:
            self.font = UIFont.systemFont(ofSize: 24, weight: .medium, width: .compressed)
        }
    }
}
