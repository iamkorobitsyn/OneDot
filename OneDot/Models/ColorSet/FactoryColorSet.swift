//
//  FactoryColorSet.swift
//  OneDot
//
//  Created by Александр Коробицын on 08.11.2023.
//

import Foundation
import UIKit


class FactoryColorSet {
    
    static let shared = FactoryColorSet()
    
    func get() -> [ColorSetProtocol] {

        var list = [ColorSetProtocol]()
        
  
        let grayMoonLight = GrayMoonColorSet()
        list.append(grayMoonLight)
        

        let sunsetSkyLight = SunsetSkyColorSet()
        list.append(sunsetSkyLight)
        
        
        let graphiteLight = GraphiteColorSet()
        list.append(graphiteLight)
        
        
        let sandLight = SandColorSet()
        list.append(sandLight)

        
        let firstSpecialLight = FirstSpecialColorSet()
        list.append(firstSpecialLight)
        
        
        let secondSpecialLight = SecondSpecialColorSet()
        list.append(secondSpecialLight)
        
        
        let thirdSpecialLight = ThirdSpecialColorSet()
        list.append(thirdSpecialLight)
        
        
        return list
    }
}
