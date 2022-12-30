//
//  PacketHeaders.swift
//  HTTP
//
//  Created by Adam Dahan on 2021-07-10.
//

import SwiftUI
import EchoHTTP

struct PacketHTTPMethod: View {
    
    let packet: BagelRequestPacket
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5, content: {
                Text("🚀 [\(packet.requestInfo.requestMethod)]")
                    .font(.headline)
                Text("\(packet.requestInfo.url)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            })
            Spacer()
            statusCode(for: packet)
        }
    }
    
    private func statusCode(for packet: BagelRequestPacket) -> some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color(packet.statusColor))
            .frame(width: 40, alignment: .leading)
            .overlay(
                statusCodeText(for: packet)
            )
    }
    
    @ViewBuilder
    private func statusCodeText(for packet: BagelRequestPacket?) -> some View {
        if let p = packet, let request = p.requestInfo, let statusCode = request.statusCode {
            Text(verbatim: statusCode)
                .font(Font.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(.white)
        } else {
            Text("No packet")
        }
    }
}

struct PacketBody: View {
    
    let packet: BagelRequestPacket
    
    var body: some View {
        VStack(alignment: .leading, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
            Text("Request Body")
            Text(requestBody)
                .font(.caption)
                .foregroundColor(.gray)
        })
    }
    
    var requestBody: String {
        
        //2. convert JSON data to JSON object
        let json = try? JSONSerialization.jsonObject(
            with: packet.requestInfo.requestBody ?? Data(),
            options: []
        )
        
        let prettyJsonData = try? JSONSerialization.data(
            withJSONObject: json ?? [:],
            options: .prettyPrinted
        )

        let jsonString = String(data: prettyJsonData ?? Data(), encoding: .utf8)!
        return jsonString
    }
}

struct PacketURL: View {
    
    let packet: BagelRequestPacket
    
    var body: some View {
        VStack(alignment: .leading, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
            Text("URL")
            Text(packet.requestInfo.url.absoluteString)
                .font(.caption)
                .foregroundColor(.gray)
        })
    }
}

struct PacketDates: View {
    
    let packet: BagelRequestPacket
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5, content: {
            Text("🕙 Start")
                .font(.headline)
            Text("\(packet.requestInfo.startDate)")
                .font(.subheadline)
                .foregroundColor(.gray)
            Divider()
            Text("🕝 Ended")
                .font(.headline)
            Text("\(packet.requestInfo.endDate)")
                .font(.subheadline)
                .foregroundColor(.gray)
            Divider()
            Text("🕝 Total Time")
                .font(.headline)
            
            if let interval = packet.requestInfo.endDate.timeIntervalSince(packet.requestInfo.startDate) {
                Text("\(interval) seconds")
                    .font(.subheadline)
                    .foregroundColor(.gray)

            }
        })
    }
}

struct PacketRequestHeaders: View {
    
    let packet: BagelRequestPacket
    
    var body: some View {
        VStack(alignment: .leading, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
            Text("🦄 Request Header")
                .font(.headline)
            JSONView(type: .requestHeaders, packet: packet)
        })
    }
}

struct PacketResponseHeaders: View {
    
    let packet: BagelRequestPacket
    
    var body: some View {
        VStack(alignment: .leading, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
            Text(" 🐤 Response Header")
            JSONView(type: .responseHeaders, packet: packet)
        })
    }
}



struct PacketResponse: View {
    
    let packet: BagelRequestPacket
    
    @State var jsonString = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
            Text("🐥 Response Data")
            JSONView(type: .response, packet: packet)
        })
    }
}

struct PacketResponseSize: View {
    
    let packet: BagelRequestPacket
    
    @State var jsonString = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
            Text("📲 Response Size")
            Text(packet.requestInfo.responseData.sizeString())
                .font(.caption)
                .foregroundColor(.gray)
        })
    }
}

extension Data {
func sizeString(units: ByteCountFormatter.Units = [.useAll], countStyle: ByteCountFormatter.CountStyle = .file) -> String {
    let bcf = ByteCountFormatter()
    bcf.allowedUnits = units
    bcf.countStyle = .file

    return bcf.string(fromByteCount: Int64(count))
 }}
