//
//  PacketView.swift
//  HTTP
//
//  Created by Adam Dahan on 2021-07-10.
//

import SwiftUI
import EchoHTTP

struct PacketView: View {

    let index: Int
    let packet: BagelRequestPacket
    
    var body: some View {
        GeometryReader { geometry in
            List {
                Text("")
                    .frame(height: 20)
                PacketHTTPMethod(packet: packet)
                PacketDates(packet: packet)
                PacketRequestHeaders(packet: packet)
                PacketResponseHeaders(packet: packet)
                if packet.requestInfo.requestMethod == "POST" {
                    PacketBody(packet: packet)
                }
                PacketResponse(packet: packet)
                PacketResponseSize(packet: packet)
            }.padding([.top, .bottom], 10)
        }
        .navigationBarTitle("\(index)")
    }
}
