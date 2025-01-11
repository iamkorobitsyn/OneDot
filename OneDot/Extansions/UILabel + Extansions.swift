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
        case condensedMin
        case condensedMid
        case condensedMax
        case standartMid
        case boldMid
        case boldMax
        case boldExtra
    }
    
    func instance(color: UIColor, alignment: NSTextAlignment, font: Font) {
        
        textColor = color
        textAlignment = alignment
        
        switch font {
        case .condensedMin:
            self.font = UIFont.systemFont(ofSize: 13, weight: .light, width: .condensed)
        case .condensedMid:
            self.font = UIFont.systemFont(ofSize: 17, weight: .light, width: .condensed)
        case .condensedMax:
            self.font = UIFont.systemFont(ofSize: 21, weight: .light, width: .condensed)
        case .standartMid:
            self.font = UIFont.systemFont(ofSize: 17, weight: .medium, width: .standard)
        case .boldMid:
            self.font = UIFont.systemFont(ofSize: 17, weight: .bold, width: .standard)
        case .boldMax:
            self.font = UIFont.systemFont(ofSize: 19, weight: .bold, width: .standard)
        case .boldExtra:
            self.font = UIFont.systemFont(ofSize: 29, weight: .bold, width: .standard)
        }
    }
}
