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
        case standartMin
        case standartMid
        case standartMax
        case standartExtra
        case timerWatch
    }
    
    func instance(color: UIColor, alignment: NSTextAlignment, font: Font) {
        
        textColor = color
        textAlignment = alignment
        
        switch font {
        case .condensedMin:
            self.font = UIFont.systemFont(ofSize: 15, weight: .light, width: .condensed)
        case .condensedMid:
            self.font = UIFont.systemFont(ofSize: 17, weight: .light, width: .condensed)
        case .standartMin:
            self.font = UIFont.systemFont(ofSize: 13, weight: .medium, width: .standard)
        case .standartMid:
            self.font = UIFont.systemFont(ofSize: 17, weight: .medium, width: .standard)
        case .standartMax:
            self.font = UIFont.systemFont(ofSize: 19, weight: .medium, width: .standard)
        case .standartExtra:
            self.font = UIFont.systemFont(ofSize: 25, weight: .medium, width: .standard)
        case .timerWatch:
            self.font = UIFont.monospacedDigitSystemFont(ofSize: 80, weight: .light)
        }
    }
}
