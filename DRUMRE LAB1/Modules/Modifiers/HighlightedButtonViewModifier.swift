//
//  DRUMRE LAB1
//  HighlightedButtonViewModifier.swift
//
//  Andre Flego
//

import SwiftUI

struct HighlightedButtonViewModifier: ViewModifier {
    var highlightColor: Color
    
    func body(content: Content) -> some View {
        content
            .buttonStyle(HighlightedButtonStyle(highlightColor: highlightColor))
    }
}

extension View {
    func highlightColor(highlightColor: Color) -> some View {
        modifier(
            HighlightedButtonViewModifier(highlightColor: highlightColor)
        )
    }
}
