//
//  SwiftUIView.swift
//  
//
//  Created by Adam Dahan on 2021-07-04.
//

import SwiftUI
import Combine

public class LogsViewModel: NSObject, ObservableObject, FileMonitorDelegate {
    
    private lazy var monitor: FileMonitor? = {
        do {
            guard let url = File.main.echoLogURL else { return nil }
            let monitor = try FileMonitor(url: url)
            return monitor
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }()
    
    override init() {
        super.init()
        monitor?.delegate = self
        logs = File.main.readFromEchoFile().components(separatedBy: "\n")
    }
    
    @Published var logs: [String] = []
    
    func didReceive(changes: String) {
        logs.append(changes)
    }
    
    var cancellables = Set<AnyCancellable>()
}

@available(iOS 14.0, *)
public struct LogsView: View {
        
    @ObservedObject var logsViewModel = LogsViewModel()
            
    @available(macOS 10.15, *)
    public var body: some View {
        List(logsViewModel.logs.reversed(), id: \.self) { row in
            Text(row)
        }
    }
}
