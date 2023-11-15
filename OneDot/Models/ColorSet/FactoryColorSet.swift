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
        
        
        //MARK: - GrayMoon
  
        let grayMoonLight = GrayMoonLight()
        list.append(grayMoonLight)
        
        let grayMoonDeep = GrayMoonDeep()
        list.append(grayMoonDeep)
        
        let grayMoonSystem = GrayMoonSystem()
        list.append(grayMoonSystem)
        
        
        //MARK: - SunsetSky
        
        
        let sunsetSkyLight = SunsetSkyLight()
        list.append(sunsetSkyLight)
        
        let sunsetSkyDeep = SunsetSkyDeep()
        list.append(sunsetSkyDeep)
        
        let sunsetSkySystem = SunsetSkySystem()
        list.append(sunsetSkySystem)
        

        //MARK: - Graphite
        
        
        let graphiteLight = GraphiteLight()
        list.append(graphiteLight)
        
        let graphiteDeep = GraphiteDeep()
        list.append(graphiteDeep)
        
        let graphiteSystem = GraphiteSystem()
        list.append(graphiteSystem)
        
        
        //MARK: - Sand
        
        
        let sandLight = SandLight()
        list.append(sandLight)
        
        let sandDeep = SandDeep()
        list.append(sandDeep)
        
        let sandSystem = SandSystem()
        list.append(sandSystem)
        
        

        //MARK: - Ultraviolet
        
        
        let ultravioletLight = UltravioletLight()
        list.append(ultravioletLight)
        
        let ultravioletDeep = UltravioletDeep()
        list.append(ultravioletDeep)
        
        let ultravioletSystem = UltravioletSystem()
        list.append(ultravioletSystem)
        
        
        //MARK: - FirstSpecial
        
        
        let firstSpecialLight = FirstSpecialLight()
        list.append(firstSpecialLight)
        
        let firstSpecialDeep = FirstSpecialDeep()
        list.append(firstSpecialDeep)
        
        let firstSpecialSystem = FirstSpecialSystem()
        list.append(firstSpecialSystem)
        
        
        //MARK: - SecondSpecial
        
        
        let secondSpecialLight = SecondSpecialLight()
        list.append(secondSpecialLight)
        
        let secondSpecialDeep = SecondSpecialDeep()
        list.append(secondSpecialDeep)
        
        let secondSpecialSystem = SecondSpecialSystem()
        list.append(secondSpecialSystem)
        
        
        //MARK: - ThirdSpecial
        
        
        let thirdSpecialLight = ThirdSpecialLight()
        list.append(thirdSpecialLight)
        
        let thirdSpecialDeep = ThirdSpecialDeep()
        list.append(thirdSpecialDeep)
        
        let thirdSpecialSystem = ThirdSpecialSystem()
        list.append(thirdSpecialSystem)
        
        
        return list
    }
}
