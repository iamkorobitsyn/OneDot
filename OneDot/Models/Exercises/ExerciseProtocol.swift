//
//  OnTheStreetProtocol.swift
//  OneDot
//
//  Created by Александр Коробицын on 26.10.2023.
//

import Foundation

protocol Exercise {
    var type: String {get}
    var name: String {get}
    var titleName: String {get}
    var pickerIcon: String {get}
}
