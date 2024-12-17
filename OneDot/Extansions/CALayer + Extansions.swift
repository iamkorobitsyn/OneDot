//
//  CALayer + Extansions.swift
//  OneDot
//
//  Created by Александр Коробицын on 16.12.2024.
//

import Foundation
import UIKit

extension CALayer {
    
    enum CornerMode {
        case min
        case max
    }
    
    func customBorder(bord: Bool, corner: CornerMode) {
        if bord {
            cornerRadius = .barCorner
            cornerCurve = .continuous
            borderWidth = 0.7
            borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        }
        
        switch corner {
            
        case .min:
            cornerRadius = 10
            cornerCurve = .continuous
        case .max:
            cornerRadius = .barCorner
            cornerCurve = .continuous
        }
    }
}
