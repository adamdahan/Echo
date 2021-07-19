//
//  TextWithAttributedString.swift
//  HTTP
//
//  Created by Adam Dahan on 2021-07-10.
//

import SwiftUI

struct TextWithAttributedString: UIViewRepresentable {
    @Binding var height: CGFloat
    var attributedString: NSAttributedString

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView(frame: .zero)
        textView.isEditable = false
        return textView
    }

    func updateUIView(_ textView: UITextView, context: Context) {
        textView.attributedText = self.attributedString

        // calculate height based on main screen, but this might be
        // improved for more generic cases
        DispatchQueue.main.async { // << fixed
            height = textView.sizeThatFits(UIScreen.main.bounds.size).height
        }
    }
}
