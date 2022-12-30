//
//  packageRow.swift
//  HTTP
//
//  Created by Adam Dahan on 2021-07-10.
//

import SwiftUI
import EchoHTTP

struct PackageRow: View {
    
    let index: Int
    let package: EchoHTTP.TrafficPackage
    
    init(index: Int, package: EchoHTTP.TrafficPackage) {
        self.index = index
        self.package = package
        print("package JSON: \(String(describing: package.response?.headers))")
    }
    
    var body: some View {
        row(index: index, for: package)
    }
    
    // MARK: - TODO Make date formatter
    private func startDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .long
        return dateFormatter.string(from: date)
    }
    
    private func text(index: Int, for package: EchoHTTP.TrafficPackage) -> some View {
        Text("\(index)")
            .font(.headline)
            .padding(3)
    }
    
    @ViewBuilder
    private func httpMethod(for package: EchoHTTP.TrafficPackage) -> some View {
        Text(verbatim: "[\(package.request.method)]")
            .font(.headline)
            .foregroundColor(Color.blue)
    }
    
    @ViewBuilder
    private func date(for package: EchoHTTP.TrafficPackage) -> some View {
        Text(startDateString(date: Date()))
            .font(.headline)
            .foregroundColor(Color.primary)
    }
    
    @ViewBuilder
    private func url(for package: EchoHTTP.TrafficPackage) -> some View {
        Text(package.request.url)
            .font(.subheadline)
            .foregroundColor(Color.gray)
    }
    
    @ViewBuilder
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
    
    @ViewBuilder
    private func row(index: Int, for package: EchoHTTP.TrafficPackage) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    httpMethod(for: package)
                    date(for: package)
                }
                .font(.caption)
                url(for: package)
            }
            Spacer()
            statusCode(for: package)
        }
    }
}

