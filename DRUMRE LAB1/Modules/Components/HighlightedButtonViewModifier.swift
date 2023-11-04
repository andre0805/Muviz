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
