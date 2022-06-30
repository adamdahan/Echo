//
//  ContentView.swift
//  HTTP
//
//  Created by Adam Dahan on 2021-07-10.
//

import SwiftUI
import EchoHTTP

public class Delegate: NSObject, BagelCarrierDelegate, ObservableObject {
    
    @Published var packets: [BagelRequestPacket] = []
    
    public func bagelCarrierWillSendRequest(_ request: BagelRequestPacket) -> BagelRequestPacket? {
        if request.requestInfo.responseData != nil {
            DispatchQueue.main.async {
                self.packets.append(request)
            }
        }
        return request
    }
}

// Testing


@available(iOS 14.0, *)
struct HTTPList: View {

    // MARK: - ObservedObject
    
    @ObservedObject var delegate = Echo.main.carrierDelegate;
                
    @State private var showingSheet = false

    // MARK: - Body
    
    var body: some View {
        List(delegate.packets, id: \.self) { packet in
            NavigationLink(destination: PacketView(index: 0, packet: packet)) {
                PacketRow(index: 0, packet: packet)
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
