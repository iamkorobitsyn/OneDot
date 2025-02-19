//
//  Shaper.swift
//  OneDot
//
//  Created by Александр Коробицын on 28.09.2023.
//

import Foundation
import UIKit

class GraphicsService {
    
    static let shared = GraphicsService()
    
    private init() {}
    
    enum ShapeType {
        case headerSingleShape
        case footerSingleShape
        case footerDoubleShape
        case bodyCrossShape
        case dynamicDescriptionShape(descriptionCount: Int)
    }
    

    //MARK: - Shapes
    
    
    func drawShape(shape: CAShapeLayer, shapeType: ShapeType, view: UIView) {
        
        let path = UIBezierPath()
        
        switch shapeType {
        case .headerSingleShape:
            path.move(to: CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2 - 15))
            path.addLine(to: CGPoint(x: view.bounds.width / 2 , y: view.bounds.height / 2 + 15))
            shape.strokeColor = UIColor.myPaletteGray.cgColor
            
        case .footerSingleShape:
            path.move(to: CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2 - 30))
            path.addLine(to: CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2 + 30))
            shape.strokeColor = UIColor.white.cgColor
            
        case .footerDoubleShape:
            path.move(to: CGPoint(x: view.bounds.width / 2 - view.bounds.width / 12 ,
                                  y: view.bounds.height / 2 - 30))
            path.addLine(to: CGPoint(x: view.bounds.width / 2 - view.bounds.width / 12 ,
                                     y: view.bounds.height / 2 + 30))
            path.move(to: CGPoint(x: view.bounds.width / 2 + view.bounds.width / 12,
                                  y: view.bounds.height / 2 - 30))
            path.addLine(to: CGPoint(x: view.bounds.width / 2 + view.bounds.width / 12 ,
                                     y: view.bounds.height / 2 + 30))
            shape.strokeColor = UIColor.white.cgColor
            
        case .bodyCrossShape:
            path.move(to: CGPoint(x: .barWidth / 2.16 - 5, y: 39))
            path.addLine(to: CGPoint(x: .barWidth - (.barWidth / 2.16) - 5, y: 69))
            path.move(to: CGPoint(x: .barWidth - (.barWidth / 2.16) - 5, y: 39))
            path.addLine(to: CGPoint(x: .barWidth / 2.16 - 5, y: 69))
            shape.strokeColor = UIColor.white.cgColor
            
        case .dynamicDescriptionShape(descriptionCount: let descriptionCount):
            path.move(to: CGPoint(x: .barWidth / 2, y:  76))
            path.addLine(to: CGPoint(x: .barWidth / 2 , y: 76 + CGFloat(descriptionCount * 30)))
            shape.strokeColor = UIColor.myPaletteGray.cgColor
        }
        
        shape.path = path.cgPath
        shape.lineWidth = 0.5
        shape.lineCap = .round
        view.layer.addSublayer(shape)
    }
    
    //MARK: - MainView
    
    func drawViewGradient(layer: CALayer) {
        let topGradient = CAGradientLayer()
        let trailingGradient = CAGradientLayer()
        let bottomGradient = CAGradientLayer()
        let leadingGradient = CAGradientLayer()
        
        let frame = CGRect(x: 0, y: 0, width: layer.frame.width, height: layer.frame.height)
        [topGradient, trailingGradient, bottomGradient, leadingGradient].forEach({$0.frame = frame})
        
        let colors = [UIColor.black.cgColor, UIColor.black.withAlphaComponent(0).cgColor]
        [topGradient, trailingGradient, bottomGradient, leadingGradient].forEach({$0.colors = colors})
        
        topGradient.startPoint = CGPoint(x: 0, y: 0)
        topGradient.endPoint = CGPoint(x: 0, y: 0.4)
        
        trailingGradient.startPoint = CGPoint(x: 0, y: 0)
        trailingGradient.endPoint = CGPoint(x: 0.4, y: 0)
        
        bottomGradient.startPoint = CGPoint(x: 0, y: 1)
        bottomGradient.endPoint = CGPoint(x: 0, y: 0.6)
        
        leadingGradient.startPoint = CGPoint(x: 1, y: 0)
        leadingGradient.endPoint = CGPoint(x: 0.6, y: 0)
        
        layer.addSublayer(topGradient)
        layer.addSublayer(trailingGradient)
        layer.addSublayer(bottomGradient)
        layer.addSublayer(leadingGradient)
    }
}
