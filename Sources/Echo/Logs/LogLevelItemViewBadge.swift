//
//  Badge.swift
//  Bosslife
//
//  Created by Adam Dahan on 2020-06-14.
//  Copyright © 2020 Adam Dahan. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
struct LogLevelItemViewBadge: View {
    
    var item: LogLevelItem
        
    @ViewBuilder
    var body: some View {
        GeometryReader { geometry in
            if self.item.isSelected {
                self.path(geometry)
                    .fill(self.item.color)
                    .aspectRatio(1, contentMode: .fit)
            } else {
                self.path(geometry)
                    .stroke(self.item.color, lineWidth: 3)
                    .aspectRatio(1, contentMode: .fit)
            }
        }
    }
    
    func path(_ geometry: GeometryProxy) -> Path {
        return Path { path in
            var width: CGFloat = min(geometry.size.width, geometry.size.height)
            let height = width
            let xScale: CGFloat = 0.832
            let xOffset = (width * (1.0 - xScale)) / 2.0
            width *= xScale
            path.move(
                to: CGPoint(
                    x: xOffset + width * 0.95,
                    y: height * (0.20 + HexagonParameters.adjustment)
                )
            )
            
            HexagonParameters.points.forEach {
                path.addLine(
                    to: .init(
                        x: xOffset + width * $0.useWidth.0 * $0.xFactors.0,
                        y: height * $0.useHeight.0 * $0.yFactors.0
                    )
                )
                
                path.addQuadCurve(
                    to: .init(
                        x: xOffset + width * $0.useWidth.1 * $0.xFactors.1,
                        y: height * $0.useHeight.1 * $0.yFactors.1
                    ),
                    control: .init(
                        x: xOffset + width * $0.useWidth.2 * $0.xFactors.2,
                        y: height * $0.useHeight.2 * $0.yFactors.2
                    )
                )
            }
        }
    }
}
