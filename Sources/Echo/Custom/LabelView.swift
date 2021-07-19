//
//  File.swift
//  
//
//  Created by Adam Dahan on 2021-07-08.
//

import SwiftUI

public struct LabelView: View {
        
    public var text: String

    @State private var height: CGFloat = .zero

    public var body: some View {
        InternalLabelView(text: text, dynamicHeight: $height)
            .frame(minHeight: height)
    }

    struct InternalLabelView: UIViewRepresentable {
        var text: String
        @Binding var dynamicHeight: CGFloat

        func makeUIView(context: Context) -> UILabel {
            let label = UILabel()
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

            return label
        }

        func updateUIView(_ uiView: UILabel, context: Context) {
            uiView.text = text

            DispatchQueue.main.async {
                dynamicHeight = uiView.sizeThatFits(CGSize(width: uiView.bounds.width, height: CGFloat.greatestFiniteMagnitude)).height
            }
        }
    }
}
