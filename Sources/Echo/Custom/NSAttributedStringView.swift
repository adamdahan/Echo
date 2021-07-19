//
//  NSAttributedStringView.swift
//  HTTP
//
//  Created by Adam Dahan on 2021-07-10.
//

import SwiftUI

struct NSAttributedStringView: View {
    @Binding var text: NSAttributedString
    @State private var textHeight: CGFloat = .zero
    var body: some View {
        ScrollView {
            TextWithAttributedString(height: $textHeight, attributedString: text)
                .frame(height: textHeight + 20) // << specify height explicitly !
        }
    }
}
