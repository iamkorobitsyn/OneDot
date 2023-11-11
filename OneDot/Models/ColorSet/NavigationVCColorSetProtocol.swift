//
//  ColorSetProtocol.swift
//  OneDot
//
//  Created by Александр Коробицын on 08.11.2023.
//

import Foundation
import UIKit

protocol NavigationVCColorSetProtocol {
    func update(_ set: ColorSetProtocol, _ barBGIsHidden: Bool)
}

protocol MainVCColorSetProtocol {
    func update(_ set: ColorSetProtocol, _ barBGIsHidden: Bool)
}
