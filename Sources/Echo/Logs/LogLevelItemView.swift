//
//  MarketCategoryView.swift
//  Bosslife
//
//  Created by Adam Dahan on 2020-06-15.
//  Copyright © 2020 Adam. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
struct LogLevelItemView: View {
    
    // MARK: - Constants 
    
    struct Constants {
        static let diameter: CGFloat = 55.0
        static let horizontalSpacing: CGFloat = 10.0
        static let defaultRotation: Double = 90.0
    }
    
    // MARK: - Dependencies
    
    var item: LogLevelItem
    
    // MARK: - UI
    
    var body: some View {
        return VStack {
            ZStack {
                LogLevelItemViewBadge(item: item)
                .frame(
                    width: Constants.diameter,
                    height: Constants.diameter,
                    alignment: .leading
                )
                .rotationEffect(Angle.degrees(Constants.defaultRotation))
                Text(item.level.description)
            }
            Text(item.level.title)
                .font(.headline)
        }
    }
}
