//
//  SwiftUIView.swift
//  
//
//  Created by Adam Dahan on 2021-07-07.
//

import SwiftUI
import CoreData

@available(iOS 14.0, *)
struct FilteredList: View {
    
    @Environment(\.managedObjectContext) var moc

    // MARK: - Private
    
    private var fetchRequest: FetchRequest<Log>
        
    // MARK: - Tree
    
    var body: some View {
        List(fetchRequest.wrappedValue, id: \.self) { log in
            NavigationLink(
                destination:
                    LogDetailView(log: log)
            ) {
                LogRow(log: log)
            }
        }
        .listStyle(PlainListStyle())
        .navigationBarTitle(Text("🪵 Logs (\(self.fetchRequest.wrappedValue.count))"), displayMode: .inline)
    }
    
    // MARK: - Designated Initializer
    
    init(filter: ItemLevel) {
        if filter.rawValue == 0 {
            self.fetchRequest = FetchRequest<Log>(
                entity: Log.entity(),
                sortDescriptors: [
                    NSSortDescriptor(keyPath: \Log.date, ascending: false)
                ]
            )
        } else {
            self.fetchRequest = FetchRequest<Log>(
                entity: Log.entity(),
                sortDescriptors: [
                    NSSortDescriptor(keyPath: \Log.date, ascending: false)
                ],
                predicate: NSPredicate(format: "level == %d", filter.rawValue - 1)
            )
        }
    }
}
