//
//  File.swift
//  
//
//  Created by Adam Dahan on 2021-07-07.
//

import SwiftUI

@available(iOS 14.0, *)
public struct MainView: View {
    
    private let fileProvider = File.main
    
    public init() { }
    
    public var body: some View {
        TabView {
            NavigationView {
                HTTPList()
            }
            .tabItem {
                Label("🌎 Network", systemImage: "network")
            }
            NavigationView {
                LogsView()
            }
            .environment(
                \.managedObjectContext,
                StorageProvider.persistentContainer.viewContext
            )
            .tabItem {
                Label("🪵 Logs", systemImage: "list.dash")
            }
            NavigationView {
                SandboxList(urls: fileProvider.listContentsOf(path: fileProvider.appSandbox))
                    .navigationBarTitle("🏖 App Sandbox", displayMode: .inline)
                    .listStyle(PlainListStyle())
                    .offset(y: -60)
            }
            .tabItem {
                Label("🏖 App Sandbox", systemImage: "app")
            }
            NavigationView {
                UserDefaultsPayloadView()
            }
            .tabItem {
                Label("💃 Defaults", systemImage: "person")
            }
            NavigationView {
                KeychainView()
            }
            .tabItem {
                Label("🔑 Keys", systemImage: "key")
            }
        }
    }
}
