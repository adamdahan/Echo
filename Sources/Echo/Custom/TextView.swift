//
//  File.swift
//  
//
//  Created by Adam Dahan on 2021-07-09.
//

import SwiftUI

// MARK: - TextView

@available(iOS 14.0, *)
struct TextView: View {
    
    @Binding var showingSheet: Bool

    @Binding var text: String
    
    var body: some View {
        ScrollView {
            VStack {
                Text(text)
                    .edgesIgnoringSafeArea([.bottom])
                Spacer()
            }
        }
        .navigationBarTitle("Log", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Close") {
                    self.showingSheet = false
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Send") {
                    
                }
            }
        }
    }
}

