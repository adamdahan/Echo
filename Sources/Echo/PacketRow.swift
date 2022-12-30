//
//  PacketRow.swift
//  HTTP
//
//  Created by Adam Dahan on 2021-07-10.
//

import SwiftUI
import EchoHTTP

struct PacketRow: View {
    
    let index: Int
    let packet: BagelRequestPacket?
    
    init(index: Int, packet: BagelRequestPacket?) {
        self.index = index
        self.packet = packet
    }
    
    var body: some View {
        row(index: index, for: packet)
    }
    
    // MARK: - TODO Make date formatter
    private func startDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .long
        return dateFormatter.string(from: date)
    }
    
    private func text(index: Int, for packet: BagelRequestPacket) -> some View {
        Text("\(index)")
            .font(.headline)
            .padding(3)
    }
    
    @ViewBuilder
    private func httpMethod(for packet: BagelRequestPacket?) -> some View {
        if let packet = packet {
            Text(verbatim: "[\(packet.requestInfo.requestMethod ?? "")]")
                .font(.headline)
                .foregroundColor(Color.blue)
        } else {
            Text("no packet")
        }
    }
    
    @ViewBuilder
    private func date(for packet: BagelRequestPacket?) -> some View {
        if let packet = packet {
            Text(startDateString(date: packet.requestInfo.startDate))
                .font(.headline)
                .foregroundColor(Color.primary)
        } else {
            Text("no packet")
        }
    }
    
    @ViewBuilder
    private func url(for packet: BagelRequestPacket?) -> some View {
        if let packet = packet {
            Text(packet.requestInfo.url.absoluteString)
                .font(.subheadline)
                .foregroundColor(Color.gray)
        } else {
            Text("no packet")
        }
    }
    
    @ViewBuilder
    private func statusCode(for packet: BagelRequestPacket?) -> some View {
        if let packet = packet {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(packet.statusColor))
                .frame(width: 40, alignment: .leading)
                .overlay(
                    statusCodeText(for: packet)
                )
        } else {
            Text("no packet")
        }
    }
    
    @ViewBuilder
    private func statusCodeText(for packet: BagelRequestPacket?) -> some View {
        if let packet = packet {
            Text(verbatim: packet.requestInfo.statusCode ?? "0")
                .font(Font.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(.white)
        } else {
            Text("no packet")
        }
    }
    
    @ViewBuilder
    private func row(index: Int, for packet: BagelRequestPacket?) -> some View {
        if let packet = packet {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        httpMethod(for: packet)
                        date(for: packet)
                    }
                    .font(.caption)
                    url(for: packet)
                }
                Spacer()
                statusCode(for: packet)
            }
        } else {
            Text("no packet")
        }
    }
}
