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
    let packet: BagelRequestPacket
    
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
    
    private func httpMethod(for packet: BagelRequestPacket) -> some View {
        Text(verbatim: "[\(packet.requestInfo.requestMethod ?? "")]")
            .font(.headline)
            .foregroundColor(Color.blue)
    }
    
    private func date(for packet: BagelRequestPacket) -> some View {
        Text(startDateString(date: packet.requestInfo.startDate))
            .font(.headline)
            .foregroundColor(Color.primary)
    }
    
    private func url(for packet: BagelRequestPacket) -> some View {
        Text(packet.requestInfo.url.absoluteString)
            .font(.subheadline)
            .foregroundColor(Color.gray)
    }
    
    private func statusCode(for packet: BagelRequestPacket) -> some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color(packet.statusColor))
            .frame(width: 40, alignment: .leading)
            .overlay(
                statusCodeText(for: packet)
            )
    }
    
    private func statusCodeText(for packet: BagelRequestPacket) -> some View {
        Text(verbatim: packet.requestInfo.statusCode ?? "0")
            .font(Font.system(size: 14, weight: .bold, design: .rounded))
            .foregroundColor(.white)
    }
    
    private func row(index: Int, for packet: BagelRequestPacket) -> some View {
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
    }
}
