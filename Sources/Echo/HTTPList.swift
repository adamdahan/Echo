//
//  ContentView.swift
//  HTTP
//
//  Created by Adam Dahan on 2021-07-10.
//

import SwiftUI
import EchoHTTP

@available(iOS 14.0, *)
struct HTTPList: View {
    
    @State var selectedStatusCode: Int = -1

    // MARK: - ObservedObject
    
    @ObservedObject var delegate = Echo.main.atlantisDelegate
                
    @State private var showingSheet = false
    
    var packages: [EchoHTTP.TrafficPackage] {
        if selectedStatusCode == -1 {
            return delegate.packages.reversed()
        } else {
            let packages = delegate.packages.reversed().filter {
                guard let code = $0.response?.statusCode else {
                    return selectedStatusCode == 0 ? true : false
                }
                return code == selectedStatusCode
            }
            return packages
        }
    }

    // MARK: - Body
    
    var body: some View {
        VStack {
            StatusCodeGrid(selectedStatusCode: $selectedStatusCode, datasource: delegate)
                .frame(height: 60)
                .padding([.leading, .trailing])
            List(packages, id: \.self) { package in
                NavigationLink(destination: PackageView(index: 0, package: package)) {
                    PackageRow(index: 0, package: package)
                }
            }
        }
        .listStyle(PlainListStyle())
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    delegate.packages = []
                }) {
                    Image(systemName: "trash")
                        .imageScale(.large)
                }
            }
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

struct StatusCodeGrid: View {
    
    @Binding var selectedStatusCode: Int
    
    let datasource: EchoAtlantisDelegate
    
    var statusCodes: [Int] {
        Array(Set(datasource.packages.map { $0.response?.statusCode ?? 0 })).sorted { $0 > $1}
    }
    
    let rows = [GridItem(.fixed(30))]

    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: rows) {
                ForEach(statusCodes, id: \.self) { value in
                    Button {
                        
                        if selectedStatusCode == value {
                            selectedStatusCode = -1
                            return
                        }
                        
                        selectedStatusCode = value
                    } label: {
                        row(for: value)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(
                                        value == selectedStatusCode ? .blue : .clear,
                                        lineWidth: 2
                                    )
                            )
                    }
                }
            }
        }
    }
    
    // Can be made into new view
    @ViewBuilder
    private func row(for statusCode: Int) -> some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color(color(for: statusCode)))
            .frame(width: 40, alignment: .leading)
            .overlay(
                title(for: statusCode)
            )
    }
    
    @ViewBuilder
    private func title(for statusCode: Int) -> some View {
        Text(verbatim: "\(statusCode)")
            .font(Font.system(size: 14, weight: .bold, design: .rounded))
            .foregroundColor(.white)
    }
    
    func color(for statusCode: Int) -> UIColor {
        switch statusCode {
        case 200...299:
            return .systemGreen
        case 300...399:
            return .systemYellow
        case 400...499:
            return .systemOrange
        case 500...599:
            return .systemRed
        default:
            return .systemRed
        }
    }
}
