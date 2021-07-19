//
//  MarketCategoriesView.ViewModel.swift
//  Bosslife
//
//  Created by Adam Dahan on 2020-06-19.
//  Copyright © 2020 Adam. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
class LogLevelItemsViewModel: ObservableObject {
    
    // MARK: - Computed
    
    var selectedLogLevel: LogLevelItem {
        return dataSource.filter { $0.isSelected == true }.first!
    }
    
    // MARK: - Model
    
    @Published var dataSource: [LogLevelItem] = [
        LogLevelItem(level: ItemLevel.all, imageString: ItemLevel.all.description, color: .green),
        LogLevelItem(level: ItemLevel.debug, imageString: LogLevel.debug.description, color: .purple),
        LogLevelItem(level: ItemLevel.fixme, imageString: "🛠", color: .gray),
        LogLevelItem(level: ItemLevel.info, imageString: "💁‍♀️", color: .blue),
        LogLevelItem(level: ItemLevel.warning, imageString: "⚠️", color: .yellow),
        LogLevelItem(level: ItemLevel.error, imageString: "🚨", color: .red),
        LogLevelItem(level: ItemLevel.todo, imageString: "✏️", color: .orange)
    ]
    
    // MARK: - Methods
    
    func clearSelections() {
        for i in 0..<self.dataSource.count {
            dataSource[i].isSelected = false
        }
    }
    
    func select(at index: Int) {
        dataSource[index].isSelected = !dataSource[index].isSelected
    }
    
    func deinitData() {
        self.dataSource.removeAll()
    }

    // MARK: - Deinit
    
    deinit {
        self.deinitData()
    }
}

public enum ItemLevel: Int, CaseIterable {
    case all, info, warning, error, todo, fixme, debug
    
    public var description: String {
        switch self {
        case .all: return "🪵"
        case .info: return "💁‍♀️"
        case .warning: return "⚠️"
        case .error: return "🚨"
        case .todo: return "📝"
        case .fixme: return "🛠"
        case .debug: return "👾"
        }
    }
    
    public var title: String {
        switch self {
        case .all: return "all"
        case .info: return "info"
        case .warning: return "warning"
        case .error: return "error"
        case .todo: return "todo"
        case .fixme: return "fixme"
        case .debug: return "debug"
        }
    }
}
