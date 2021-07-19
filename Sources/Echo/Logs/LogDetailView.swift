//
//  File.swift
//  
//
//  Created by Adam Dahan on 2021-07-05.
//

import SwiftUI

@available(iOS 14.0, *)
struct LogDetailView: View {
    
    private let fileProvider = File.main
    
    let log: Log
    
    var dateString: String {
        guard let d = log.date else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter.string(from: d)
    }
        
    @State private var showingSheet = false
        
    var body: some View {
        
        ScrollView {
            VStack(spacing: 0) {
                Group {
                    
                    dateRow
                        .padding([.leading], 20)
                    
                    Divider()

                    header
                        .padding([.leading], 20)
                    
                    Divider()
                }
    
                PayloadView(log: log)
                    .padding()
            }
        }
        .onAppear {
            self.sourceCode = log.data ?? ""
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Post 🐞") {
                    print("Send to instabug")
                    Proxy.delegate?.post(
                        log: log,
                        attachments: fileProvider.listContentsOf(path: fileProvider.echoLogDirPath)
                    )
                }
            }
        }
    }
    
    @State var sourceCode: String = ""
    
    var dateRow: some View {
        HStack {
            Text("⏰")
                .padding()
            Spacer()
            if let d = log.date {
                Text("\(d)")
                    .foregroundColor(Color.secondary)
                    .frame(maxWidth: .infinity, alignment: .trailing)   // << here !!
                    .multilineTextAlignment(.trailing)
                    .font(.body)
                    .padding()
            }
        }
    }
    
    var header: some View {
        HStack {
            Text("💬")
                .padding()
            Spacer()
            if let m = log.location {
                VStack(alignment: .leading, spacing: 5) {
                    Text(m)
                        .foregroundColor(Color.secondary)
                        .frame(maxWidth: .infinity, alignment: .trailing)   // << here !!
                        .multilineTextAlignment(.trailing)
                        .font(.body)
                        .padding()
                }
            }
        }
    }
}
