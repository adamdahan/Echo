//
//  MarketCategoryView.swift
//  Bosslife
//
//  Created by Adam Dahan on 2020-06-15.
//  Copyright © 2020 Adam. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct LogLevelItemsView: View {
    
    // MARK: - Static
    
    static var initiallySelectedItem: LogLevelItem {
        return LogLevelItemsViewModel().dataSource.first!
    }
    
    // MARK: - Constants
    
    struct Constants {
        static let diameter: CGFloat = 60.0
        static let horizontalSpacing: CGFloat = 10.0
        static let defaultRotation: Double = 90.0
    }
    
    // MARK: - Bindings
    
    @Binding var selectedLogLevelItem: LogLevelItem
    
    // MARK: - Dependencies
    
    @ObservedObject var viewModel: LogLevelItemsViewModel
    
    // MARK: - UI
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView (.horizontal, showsIndicators: false) {
                HStack(spacing: Constants.horizontalSpacing) {
                    ForEach(0..<self.viewModel.dataSource.count, id: \.self) { index in
                        LogLevelItemView(item: self.viewModel.dataSource[index])
                            .onTapGesture {
                                self.selectLogLevelItemAt(index: index)
                            }
                    }
                }
                .padding()
            }
            .background(Color.blue.opacity(0.1))
            .onAppear {
                self.selectLogLevelItemAt(index: 0)
            }
        }
    }
    
    // MARK: - Methods
    
    private func selectLogLevelItemAt(index: Int) {
        
        /// Clear all selections
        self.viewModel.clearSelections()
        
        /// Select the category in the view model
        self.viewModel.select(at: index)
        
        /// Update the parent MarketView with the chosen selected category
        self.selectedLogLevelItem = self.viewModel.selectedLogLevel
    }
}
