//
//  ColorSetCollection.swift
//  OneDot
//
//  Created by Александр Коробицын on 08.11.2023.
//

import Foundation
import UIKit

//MARK: - GrayMoon

class GrayMoonLight: ColorSetProtocol {
    
    var theme: Theme = .light
    
    var textTitle: String = "Gray moon (light)"
    var imageNamed: String = ""

    var mainDynamicColor: UIColor = .grayMoonMainDynamic
    var titleDynamicColor: UIColor = .grayMoonTitleDynamic
    var specialDynamicColor: UIColor = .clear
    var mainSelectorColor: UIColor = .grayMoonMainDynamic
    var additionalSelectorColor: UIColor = .grayMoonMainDynamic
    var tabBarColor: UIColor = .grayMoonMainDynamic
    
    var deepColor: UIColor = .grayMoonDeep
    var lightColor: UIColor = .grayMoonLight
    var specialColor: UIColor = .clear
    
    
}

class GrayMoonDeep: ColorSetProtocol {
    
    var theme: Theme = .dark
    
    var textTitle: String = "Gray moon (deep)"
    var imageNamed: String = ""

    var mainDynamicColor: UIColor = .grayMoonMainDynamic
    var titleDynamicColor: UIColor = .grayMoonTitleDynamic
    var specialDynamicColor: UIColor = .clear
    var mainSelectorColor: UIColor = .grayMoonMainDynamic
    var additionalSelectorColor: UIColor = .grayMoonMainDynamic
    var tabBarColor: UIColor = .grayMoonMainDynamic
    
    var deepColor: UIColor = .grayMoonDeep
    var lightColor: UIColor = .grayMoonLight
    var specialColor: UIColor = .clear
    
    
}

class GrayMoonSystem: ColorSetProtocol {
    
    var theme: Theme = .device
    
    var textTitle: String = "Gray moon (system)"
    var imageNamed: String = ""

    var mainDynamicColor: UIColor = .grayMoonMainDynamic
    var titleDynamicColor: UIColor = .grayMoonTitleDynamic
    var specialDynamicColor: UIColor = .clear
    var mainSelectorColor: UIColor = .grayMoonMainDynamic
    var additionalSelectorColor: UIColor = .grayMoonMainDynamic
    var tabBarColor: UIColor = .grayMoonMainDynamic
    
    var deepColor: UIColor = .grayMoonDeep
    var lightColor: UIColor = .grayMoonLight
    var specialColor: UIColor = .clear
    
    
}


//MARK: - SunsetSky

class SunsetSkyLight: ColorSetProtocol {
    
    var theme: Theme = .light
    
    var textTitle: String = "Sunset sky (light)"
    var imageNamed: String = ""

    var mainDynamicColor: UIColor = .sunsetSkyMainDynamic
    var titleDynamicColor: UIColor = .sunsetSkyTitleDynamic
    var specialDynamicColor: UIColor = .clear
    var mainSelectorColor: UIColor = .sunsetSkyMainDynamic
    var additionalSelectorColor: UIColor = .sunsetSkyMainDynamic
    var tabBarColor: UIColor = .sunsetSkyMainDynamic
    
    var deepColor: UIColor = .sunsetSkyDeep
    var lightColor: UIColor = .sunsetSkyLight
    var specialColor: UIColor = .clear
    
    
}


class SunsetSkyDeep: ColorSetProtocol {
    
    var theme: Theme = .dark
    
    var textTitle: String = "Sunset sky (deep)"
    var imageNamed: String = ""

    var mainDynamicColor: UIColor = .sunsetSkyMainDynamic
    var titleDynamicColor: UIColor = .sunsetSkyTitleDynamic
    var specialDynamicColor: UIColor = .clear
    var mainSelectorColor: UIColor = .sunsetSkyMainDynamic
    var additionalSelectorColor: UIColor = .sunsetSkyMainDynamic
    var tabBarColor: UIColor = .sunsetSkyMainDynamic
    
    var deepColor: UIColor = .sunsetSkyDeep
    var lightColor: UIColor = .sunsetSkyLight
    var specialColor: UIColor = .clear
    
    
}

class SunsetSkySystem: ColorSetProtocol {
    
    var theme: Theme = .device
    
    var textTitle: String = "Sunset sky (system)"
    var imageNamed: String = ""

    var mainDynamicColor: UIColor = .sunsetSkyMainDynamic
    var titleDynamicColor: UIColor = .sunsetSkyTitleDynamic
    var specialDynamicColor: UIColor = .clear
    var mainSelectorColor: UIColor = .sunsetSkyMainDynamic
    var additionalSelectorColor: UIColor = .sunsetSkyMainDynamic
    var tabBarColor: UIColor = .sunsetSkyMainDynamic
    
    var deepColor: UIColor = .sunsetSkyDeep
    var lightColor: UIColor = .sunsetSkyLight
    var specialColor: UIColor = .clear
    
    
}

//MARK: - Graphite

class GraphiteLight: ColorSetProtocol {
    
    var theme: Theme = .light

    var textTitle: String = "Graphite (light)"
    var imageNamed: String = ""

    var mainDynamicColor: UIColor = .graphiteMainDynamic
    var titleDynamicColor: UIColor = .graphiteTitleDynamic
    var specialDynamicColor: UIColor = .clear
    var mainSelectorColor: UIColor = .graphiteMainDynamic
    var additionalSelectorColor: UIColor = .graphiteMainDynamic
    var tabBarColor: UIColor = .graphiteMainDynamic
    
    var deepColor: UIColor = .graphiteDeep
    var lightColor: UIColor = .graphiteLight
    var specialColor: UIColor = .clear
    
}

class GraphiteDeep: ColorSetProtocol {
    
    var theme: Theme = .dark

    var textTitle: String = "Graphite (deep)"
    var imageNamed: String = ""

    var mainDynamicColor: UIColor = .graphiteMainDynamic
    var titleDynamicColor: UIColor = .graphiteTitleDynamic
    var specialDynamicColor: UIColor = .clear
    var mainSelectorColor: UIColor = .graphiteMainDynamic
    var additionalSelectorColor: UIColor = .graphiteMainDynamic
    var tabBarColor: UIColor = .graphiteMainDynamic
    
    var deepColor: UIColor = .graphiteDeep
    var lightColor: UIColor = .graphiteLight
    var specialColor: UIColor = .clear
    
}

class GraphiteSystem: ColorSetProtocol {
    
    var theme: Theme = .device

    var textTitle: String = "Graphite (system)"
    var imageNamed: String = ""

    var mainDynamicColor: UIColor = .graphiteMainDynamic
    var titleDynamicColor: UIColor = .graphiteTitleDynamic
    var specialDynamicColor: UIColor = .clear
    var mainSelectorColor: UIColor = .graphiteMainDynamic
    var additionalSelectorColor: UIColor = .graphiteMainDynamic
    var tabBarColor: UIColor = .graphiteMainDynamic
    
    var deepColor: UIColor = .graphiteDeep
    var lightColor: UIColor = .graphiteLight
    var specialColor: UIColor = .clear
    
}



//MARK: - Sand

class SandLight: ColorSetProtocol {
    
    var theme: Theme = .light
    
    var textTitle: String = "Sand (light)"
    var imageNamed: String = ""

    var mainDynamicColor: UIColor = .sandMainDynamic
    var titleDynamicColor: UIColor = .sandTitleDynamic
    var specialDynamicColor: UIColor = .clear
    var mainSelectorColor: UIColor = .sandMainDynamic
    var additionalSelectorColor: UIColor = .sandMainDynamic
    var tabBarColor: UIColor = .sandMainDynamic
    
    var deepColor: UIColor = .sandDeep
    var lightColor: UIColor = .sandLight
    var specialColor: UIColor = .clear
    
    
}


class SandDeep: ColorSetProtocol {
    
    var theme: Theme = .dark
    
    var textTitle: String = "Sand (deep)"
    var imageNamed: String = ""

    var mainDynamicColor: UIColor = .sandMainDynamic
    var titleDynamicColor: UIColor = .sandTitleDynamic
    var specialDynamicColor: UIColor = .clear
    var mainSelectorColor: UIColor = .sandMainDynamic
    var additionalSelectorColor: UIColor = .sandMainDynamic
    var tabBarColor: UIColor = .sandMainDynamic
    
    var deepColor: UIColor = .sandDeep
    var lightColor: UIColor = .sandLight
    var specialColor: UIColor = .clear
    
    
}


class SandSystem: ColorSetProtocol {
    
    var theme: Theme = .device
    
    var textTitle: String = "Sand (system)"
    var imageNamed: String = ""

    var mainDynamicColor: UIColor = .sandMainDynamic
    var titleDynamicColor: UIColor = .sandTitleDynamic
    var specialDynamicColor: UIColor = .clear
    var mainSelectorColor: UIColor = .sandMainDynamic
    var additionalSelectorColor: UIColor = .sandMainDynamic
    var tabBarColor: UIColor = .sandMainDynamic
    
    var deepColor: UIColor = .sandDeep
    var lightColor: UIColor = .sandLight
    var specialColor: UIColor = .clear
    
}


//MARK: - Ultraviolet

class UltravioletLight: ColorSetProtocol {
    
    var theme: Theme = .light
    
    var textTitle: String = "Ultraviolet (light)"
    var imageNamed: String = ""

    var mainDynamicColor: UIColor = .ultravioletMainDynamic
    var titleDynamicColor: UIColor = .ultravioletTitleDynamic
    var specialDynamicColor: UIColor = .clear
    var mainSelectorColor: UIColor = .ultravioletMainDynamic
    var additionalSelectorColor: UIColor = .ultravioletMainDynamic
    var tabBarColor: UIColor = .ultravioletMainDynamic
    
    var deepColor: UIColor = .ultravioletDeep
    var lightColor: UIColor = .ultravioletLight
    var specialColor: UIColor = .clear
   
}

class UltravioletDeep: ColorSetProtocol {
    
    var theme: Theme = .dark
    
    var textTitle: String = "Ultraviolet (dark)"
    var imageNamed: String = ""

    var mainDynamicColor: UIColor = .ultravioletMainDynamic
    var titleDynamicColor: UIColor = .ultravioletTitleDynamic
    var specialDynamicColor: UIColor = .clear
    var mainSelectorColor: UIColor = .ultravioletMainDynamic
    var additionalSelectorColor: UIColor = .ultravioletMainDynamic
    var tabBarColor: UIColor = .ultravioletMainDynamic
    
    var deepColor: UIColor = .ultravioletDeep
    var lightColor: UIColor = .ultravioletLight
    var specialColor: UIColor = .clear
   
}

class UltravioletSystem: ColorSetProtocol {
    
    var theme: Theme = .device
    
    var textTitle: String = "Ultraviolet (system)"
    var imageNamed: String = ""

    var mainDynamicColor: UIColor = .ultravioletMainDynamic
    var titleDynamicColor: UIColor = .ultravioletTitleDynamic
    var specialDynamicColor: UIColor = .clear
    var mainSelectorColor: UIColor = .ultravioletMainDynamic
    var additionalSelectorColor: UIColor = .ultravioletMainDynamic
    var tabBarColor: UIColor = .ultravioletMainDynamic
    
    var deepColor: UIColor = .ultravioletDeep
    var lightColor: UIColor = .ultravioletLight
    var specialColor: UIColor = .clear
   
}



//MARK: - FirstSpecial

class FirstSpecialLight: ColorSetProtocol {
    
    var theme: Theme = .light
    
    var textTitle: String = "First special (light)"
    var imageNamed: String = ""

    var mainDynamicColor: UIColor = .firstSpecialDeep
    var titleDynamicColor: UIColor = .firstSpecialTitleDynamic
    var specialDynamicColor: UIColor = .clear
    var mainSelectorColor: UIColor = .firstSpecialMainSelector
    var additionalSelectorColor: UIColor = .firstSpecialAdditionalSelector
    var tabBarColor: UIColor = .firstSpecialTabBar
    
    var deepColor: UIColor = .firstSpecialDeep
    var lightColor: UIColor = .clear
    var specialColor: UIColor = .clear
   
}

class FirstSpecialDeep: ColorSetProtocol {
    
    var theme: Theme = .dark
    
    var textTitle: String = "First special (deep)"
    var imageNamed: String = ""

    var mainDynamicColor: UIColor = .firstSpecialDeep
    var titleDynamicColor: UIColor = .firstSpecialTitleDynamic
    var specialDynamicColor: UIColor = .clear
    var mainSelectorColor: UIColor = .firstSpecialMainSelector
    var additionalSelectorColor: UIColor = .firstSpecialAdditionalSelector
    var tabBarColor: UIColor = .firstSpecialTabBar
    
    var deepColor: UIColor = .firstSpecialDeep
    var lightColor: UIColor = .clear
    var specialColor: UIColor = .clear
   
}

class FirstSpecialSystem: ColorSetProtocol {
    
    var theme: Theme = .device
    
    var textTitle: String = "First special (system)"
    var imageNamed: String = ""

    var mainDynamicColor: UIColor = .firstSpecialDeep
    var titleDynamicColor: UIColor = .firstSpecialTitleDynamic
    var specialDynamicColor: UIColor = .clear
    var mainSelectorColor: UIColor = .firstSpecialMainSelector
    var additionalSelectorColor: UIColor = .firstSpecialAdditionalSelector
    var tabBarColor: UIColor = .firstSpecialTabBar
    
    var deepColor: UIColor = .firstSpecialDeep
    var lightColor: UIColor = .clear
    var specialColor: UIColor = .clear
   
}



//MARK: - SecondSpecial

class SecondSpecialLight: ColorSetProtocol {
    
    var theme: Theme = .light
    
    var textTitle: String = "Second special (light)"
    var imageNamed: String = ""

    var mainDynamicColor: UIColor = .secondSpecialDeep
    var titleDynamicColor: UIColor = .secondSpecialTitleDynamic
    var specialDynamicColor: UIColor = .clear
    var mainSelectorColor: UIColor = .secondSpecialMainSelector
    var additionalSelectorColor: UIColor = .secondSpecialMainSelector
    var tabBarColor: UIColor = .secondSpecialTabBar
    
    var deepColor: UIColor = .secondSpecialDeep
    var lightColor: UIColor = .clear
    var specialColor: UIColor = .clear
   
}

class SecondSpecialDeep: ColorSetProtocol {
    
    var theme: Theme = .dark
    
    var textTitle: String = "Second special (deep)"
    var imageNamed: String = ""

    var mainDynamicColor: UIColor = .secondSpecialDeep
    var titleDynamicColor: UIColor = .secondSpecialTitleDynamic
    var specialDynamicColor: UIColor = .clear
    var mainSelectorColor: UIColor = .secondSpecialMainSelector
    var additionalSelectorColor: UIColor = .secondSpecialMainSelector
    var tabBarColor: UIColor = .secondSpecialTabBar
    
    var deepColor: UIColor = .secondSpecialDeep
    var lightColor: UIColor = .clear
    var specialColor: UIColor = .clear
   
}

class SecondSpecialSystem: ColorSetProtocol {
    
    var theme: Theme = .device
    
    var textTitle: String = "Second special (system)"
    var imageNamed: String = ""

    var mainDynamicColor: UIColor = .secondSpecialDeep
    var titleDynamicColor: UIColor = .secondSpecialTitleDynamic
    var specialDynamicColor: UIColor = .clear
    var mainSelectorColor: UIColor = .secondSpecialMainSelector
    var additionalSelectorColor: UIColor = .secondSpecialMainSelector
    var tabBarColor: UIColor = .secondSpecialTabBar
    
    var deepColor: UIColor = .secondSpecialDeep
    var lightColor: UIColor = .clear
    var specialColor: UIColor = .clear
   
}



//MARK: - ThirdSpecial

class ThirdSpecialLight: ColorSetProtocol {
    
    var theme: Theme = .light
    
    var textTitle: String = "Third special (light)"
    var imageNamed: String = ""

    var mainDynamicColor: UIColor = .thirdSpecialDeep
    var titleDynamicColor: UIColor = .thirdSpecialTitleDynamic
    var specialDynamicColor: UIColor = .clear
    var mainSelectorColor: UIColor = .thirdSpecialMainSelector
    var additionalSelectorColor: UIColor = .thirdSpecialMainSelector
    var tabBarColor: UIColor = .thirdSpecialTabBar
    
    var deepColor: UIColor = .thirdSpecialDeep
    var lightColor: UIColor = .clear
    var specialColor: UIColor = .clear
   
}

class ThirdSpecialDeep: ColorSetProtocol {
    
    var theme: Theme = .dark
    
    var textTitle: String = "Third special (deep)"
    var imageNamed: String = ""

    var mainDynamicColor: UIColor = .thirdSpecialDeep
    var titleDynamicColor: UIColor = .thirdSpecialTitleDynamic
    var specialDynamicColor: UIColor = .clear
    var mainSelectorColor: UIColor = .thirdSpecialMainSelector
    var additionalSelectorColor: UIColor = .thirdSpecialMainSelector
    var tabBarColor: UIColor = .thirdSpecialTabBar
    
    var deepColor: UIColor = .thirdSpecialDeep
    var lightColor: UIColor = .clear
    var specialColor: UIColor = .clear
   
}
class ThirdSpecialSystem: ColorSetProtocol {
    
    var theme: Theme = .device
    
    var textTitle: String = "Third special (system)"
    var imageNamed: String = ""

    var mainDynamicColor: UIColor = .thirdSpecialDeep
    var titleDynamicColor: UIColor = .thirdSpecialTitleDynamic
    var specialDynamicColor: UIColor = .clear
    var mainSelectorColor: UIColor = .thirdSpecialMainSelector
    var additionalSelectorColor: UIColor = .thirdSpecialMainSelector
    var tabBarColor: UIColor = .thirdSpecialTabBar
    
    var deepColor: UIColor = .thirdSpecialDeep
    var lightColor: UIColor = .clear
    var specialColor: UIColor = .clear
   
}
