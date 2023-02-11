//
//  PacketHeaders.swift
//  HTTP
//
//  Created by Adam Dahan on 2021-07-10.
//

import SwiftUI
import EchoHTTP

struct PackageHTTPMethod: View {
    
    let package: EchoHTTP.TrafficPackage
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5, content: {
                Text("🚀 [\(String(describing: package.request.method))]")
                    .font(.headline)
                Text("\(package.request.url)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            })
            Spacer()
            statusCode(for: package)
        }
    }
    
    private func statusCode(for package: EchoHTTP.TrafficPackage) -> some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color(package.statusColor))
            .frame(width: 40, alignment: .leading)
            .overlay(
                statusCodeText(for: package)
            )
    }
    
    @ViewBuilder
    private func statusCodeText(for package: EchoHTTP.TrafficPackage) -> some View {
        Text(verbatim: "\(package.response?.statusCode ?? 0)")
            .font(Font.system(size: 14, weight: .bold, design: .rounded))
            .foregroundColor(.white)
    }
}

struct PackageBody: View {
    
    let package: EchoHTTP.TrafficPackage
    
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
            with: package.responseBodyData,
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

struct PackageURL: View {
    
    let package: EchoHTTP.TrafficPackage
    
    var body: some View {
        VStack(alignment: .leading, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
            Text("URL")
            Text(package.request.url)
                .font(.caption)
                .foregroundColor(.gray)
        })
    }
}

struct PackageDates: View {
    
    let package: EchoHTTP.TrafficPackage
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5, content: {
            Text("🕙 Start")
                .font(.headline)
            Text("\(Date())")
                .font(.subheadline)
                .foregroundColor(.gray)
            Divider()
            Text("🕝 Ended")
                .font(.headline)
            Text("\(Date())")
                .font(.subheadline)
                .foregroundColor(.gray)
            Divider()
            Text("🕝 Total Time")
                .font(.headline)
            
            if let interval = Date().timeIntervalSince(Date()) {
                Text("\(interval) seconds")
                    .font(.subheadline)
                    .foregroundColor(.gray)

            }
        })
    }
}

struct PackageRequestHeaders: View {
    
    let package: EchoHTTP.TrafficPackage
    
    var body: some View {
        VStack(alignment: .leading, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
            Text("🦄 Request Header")
                .font(.headline)
            JSONView(type: .requestHeaders, package: package)
        })
    }
}

struct PackageResponseHeaders: View {
    
    let package: EchoHTTP.TrafficPackage
    
    var body: some View {
        VStack(alignment: .leading, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
            Text(" 🐤 Response Header")
            JSONView(type: .responseHeaders, package: package)
        })
    }
}



struct PackageResponse: View {
    
    let package: EchoHTTP.TrafficPackage
    
    @State var jsonString = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
            Text("🐥 Response Data")
            JSONView(type: .response, package: package)
        })
    }
}

struct PackageResponseSize: View {
    
    let package: EchoHTTP.TrafficPackage
    
    @State var jsonString = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
            Text("📲 Response Size")
            Text(package.responseBodyData.sizeString())
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
