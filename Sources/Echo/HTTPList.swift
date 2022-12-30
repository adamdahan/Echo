//
//  ContentView.swift
//  HTTP
//
//  Created by Adam Dahan on 2021-07-10.
//

import SwiftUI
import EchoHTTP

@available(iOS 14.0, *)
struct HTTPList: View {

    // MARK: - ObservedObject
    
    @ObservedObject var delegate = Echo.main.atlantisDelegate
                
    @State private var showingSheet = false

    // MARK: - Body
    
    var body: some View {
        List(delegate.packages, id: \.self) { package in
            NavigationLink(destination: PackageView(index: 0, package: package)) {
                PackageRow(index: 0, package: package)
            }
        }
        .listStyle(PlainListStyle())
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    self.showingSheet = true
                }) {
                    Image(systemName: "icloud")
                        .imageScale(.large)
                }
            }
        }
        .sheet(isPresented: $showingSheet) {
            FilePickerView { _ in
                
            }
        }
        .padding([.top], 10)
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarTitle("🌎 Network Injection", displayMode: .inline)
    }
}
