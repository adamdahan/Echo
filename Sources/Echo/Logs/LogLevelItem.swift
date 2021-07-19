//
//  MarketCategory.swift
//  Bosslife
//
//  Created by Adam Dahan on 2020-06-19.
//  Copyright © 2020 Adam. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
struct LogLevelItem: Identifiable, Hashable {
    
    // MARK: - Properties
    
    /// Immutable
    let id = UUID().uuidString
    let level: ItemLevel
    let imageString: String
    let color: Color

    /// Mutable
    var isSelected: Bool = false
    
    // MARK: - Initialization
    
    init(level: ItemLevel, imageString: String, color: Color, _ selected: Bool = false) {
        self.level = level
        self.imageString = imageString
        self.color = color
        self.isSelected = selected
    }
}
