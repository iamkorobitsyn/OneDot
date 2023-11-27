//
//  BaseSettingsViewCell.swift
//  OneDot
//
//  Created by Александр Коробицын on 26.10.2023.
//

import Foundation
import UIKit

class ToolsBarCellBase: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        backgroundColor = .white.withAlphaComponent(0)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
