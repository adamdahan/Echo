//
//  SwiftUIView.swift
//  
//
//  Created by Adam Dahan on 2021-07-05.
//

import SwiftUI
import CoreData

@available(iOS 14.0, *)
struct LogRow: View {
    
    let log: Log
    
    var dateString: String {
        guard let d = log.date else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .long
        return formatter.string(from: d)
    }
    
    // Make log row and packet row generic
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                date(for: log)
            }
            HStack {
                location(for: log)
            }
            HStack {
                data(for: log)
            }
        }
    }
    
    private func date(for log: Log) -> some View {
        Text(startDateString(date: log.date ?? Date()))
            .font(.headline)
            .foregroundColor(Color.primary)
    }
    
    private func location(for log: Log) -> some View {
        Text(log.location ?? "")
            .font(.subheadline)
            .foregroundColor(Color.gray)
    }
    
    private func data(for log: Log) -> some View {
        Text(log.data ?? "")
            .font(.subheadline)
            .foregroundColor(Color.gray)
    }
    
    // MARK: - TODO Make date formatter
    private func startDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .long
        return dateFormatter.string(from: date)
    }
    
    var chevron: some View {
        Image(systemName: "chevron.right")
            .resizable()
            .foregroundColor(.black)
            .frame(width: 5, height: 10)
    }
}
