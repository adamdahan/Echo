//
//  PacketHeaders.swift
//  HTTP
//
//  Created by Adam Dahan on 2021-07-10.
//

import SwiftUI
import Highlightr
import EchoHTTP

enum DataType {
    case requestHeaders, responseHeaders, response
}

struct JSONView: View {
    
    let type: DataType
    let package: EchoHTTP.TrafficPackage

    private let highlightr = Highlightr()
    
    @State var text: NSAttributedString = NSAttributedString(string: "")
    
    var body: some View {
        NSAttributedStringView(text: $text)
            .font(.title)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                setupTheme()
                
                var jsonString: String = ""
                
                switch type {
                case .requestHeaders:
                    
                    guard let p = packet, let requestInfo = p.requestInfo else  {
                        return
                    }
                    
                    let prettyJsonData = try? JSONSerialization.data(
                        withJSONObject: package.request.headers,
                        options: .prettyPrinted
                    )
                    
                    
                    jsonString = String(data: prettyJsonData ?? Data(), encoding: .utf8)!
                    
                    // You can omit the second parameter to use automatic language detection.
                    let highlightedCode = highlightr?.highlight(jsonString, as: "json") ?? NSAttributedString(string: "")
                    self.text = highlightedCode
                    
                case .responseHeaders:

                    guard let responseHeaders = package.response?.headers else  {
                        return
                    }
                    
                    do {
                        var data = try JSONEncoder().encode(responseHeaders)
                        var dataString: String { return String(data: data, encoding: .utf8)! }
                        print(dataString)
                        jsonString = dataString
                        
                        // You can omit the second parameter to use automatic language detection.
                        let highlightedCode = highlightr?.highlight(jsonString, as: "json") ?? NSAttributedString(string: "")
                        self.text = highlightedCode
                    } catch {
                        print(error.localizedDescription)
                    }

                case .response:
                    
                    let json = try? JSONSerialization.jsonObject(with: package.responseBodyData, options: [])
                    
                    guard let j = json else { return }
                    
                    let prettyJsonData = try? JSONSerialization.data(withJSONObject: j, options: .prettyPrinted)
                    
                    //4. convert NSData back to NSString (use NSString init for convenience), later you can convert to String.
                    jsonString = String(data: prettyJsonData ?? Data(), encoding: .utf8)!
                    
                    // You can omit the second parameter to use automatic language detection.
                    let highlightedCode = highlightr?.highlight(jsonString, as: "json") ?? NSAttributedString(string: "")
                    self.text = highlightedCode

                }
            }
    }
    
    // MARK: - Setup
    
    private func setupTheme() {
        highlightr?.setTheme(to: "paraiso-dark")
    }
}

struct PayloadView: View {
    
    let log: Log
    
    private let highlightr = Highlightr()
    
    @State var text: NSAttributedString = NSAttributedString(string: "")
    
    var body: some View {
        NSAttributedStringView(text: $text)
            .font(.title)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                setupTheme()
                self.text = NSAttributedString(string: log.data ?? "")
//                var jsonString: String = ""
//
//                do{
//                    let json = try JSONSerialization.jsonObject(with: log. ?? Data(), options: [])
//
//                    let prettyJsonData = try? JSONSerialization.data(
//                        withJSONObject: json,
//                        options: .prettyPrinted
//                    )
//
//                    jsonString = String(data: prettyJsonData ?? Data(), encoding: .utf8)!
//
//                    // You can omit the second parameter to use automatic language detection.
//                    let highlightedCode = highlightr?.highlight(jsonString, as: "json") ?? NSAttributedString(string: "")
//                    self.text = highlightedCode
//                }
//                catch {
//                    print("erroMsg")
//                }
            }
    }
    
    // MARK: - Setup
    
    private func setupTheme() {
        highlightr?.setTheme(to: "paraiso-dark")
    }
}


struct UserDefaultsPayloadView: View {
    
   @State var keysAndValues: [String: String] = {
        var info = [String: String]()
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            info[key] = "\(UserDefaults.standard.value(forKey: key) ?? "")"
        }
        return info
    }()
    
    var keys: [String] {
        keysAndValues.keys.map { String(describing: $0) }
    }
    
    var values: [String] {
        keysAndValues.values.map { String(describing: $0) }
    }
    
    @State var searchText: String = ""
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText)
                .padding([.top])
            List {
                
                ForEach(0..<filtered().count, id: \.self) { index in
                    HStack {
                        Text(filtered()[index])
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                        Text(keysAndValues[filtered()[index]] ?? "")
                            .font(.caption)
                            .foregroundColor(.purple)
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationBarTitle("💃 User Defaults", displayMode: .inline)
    }
    
    private func filtered() -> [String] {
        keys.filter({ searchText.isEmpty ? true : $0.contains(searchText) })
    }
}

class KeychainViewModel {
    
    public lazy var keysAndValues: [String: String] = {
        do {
            let items = try getAllKeychainItems()
            return items
        } catch {
            return ["":""]
        }
    }()
    
    func getAllKeychainItems() throws -> [String: String] {
        
        let classes = [kSecClassGenericPassword as String,  // Generic password items
                       kSecClassInternetPassword as String, // Internet password items
                       kSecClassCertificate as String,      // Certificate items
                       kSecClassKey as String,              // Cryptographic key items
                       kSecClassIdentity as String]         // Identity items
        
        
        var info: [String: String] = [:]
        classes.forEach { secClass in
            let items = getAllKeyChainItemsOfClass( secClass )
            for (key, value) in items {
                info[key] = value.description
            }
        }
        return info
    }
    
    
    func getAllKeyChainItemsOfClass(_ secClass: String) -> [String: AnyObject] {
        
        let query: [String: Any] = [
            kSecClass as String : secClass,
            kSecReturnData as String  : true,
            kSecReturnAttributes as String : true,
            kSecReturnRef as String : true,
            kSecMatchLimit as String: kSecMatchLimitAll
        ]
        
        var result: AnyObject?
        
        let lastResultCode = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        var values = [String: AnyObject]()
        if lastResultCode == noErr {
            let array = result as? Array<Dictionary<String, Any>>
            
            for item in array! {
                if let key = item[kSecAttrAccount as String] as? String,
                   let value = item[kSecValueData as String] as? Data {
                    values[key] = String(data: value, encoding:.utf8) as AnyObject?
                }
                else if let key = item[kSecAttrLabel as String] as? String,
                        let value = item[kSecValueRef as String] {
                    values[key] = value as AnyObject
                }
            }
        }
        return values
    }
}

struct KeychainView: View {
    
    @State var viewModel = KeychainViewModel()
    
    var keys: [String] {
        Array(viewModel.keysAndValues.keys)
    }
    
    var values: [String] {
        Array(viewModel.keysAndValues.values)
    }
    
    @State var searchText: String = ""
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText)
                .padding([.top])
            List {
                
                ForEach(0..<filtered().count, id: \.self) { index in
                    HStack {
                        Text(filtered()[index].components(separatedBy: "_").last ?? "_")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                        Text(viewModel.keysAndValues[filtered()[index]] ?? "")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationBarTitle("🔑 Keychain", displayMode: .inline)
    }
    
    private func filtered() -> [String] {
        keys.filter({ searchText.isEmpty ? true : $0.contains(searchText) })
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            
            TextField("Search ...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }
            
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                    
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
        .overlay(
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
            }
        )
    }
    
}


