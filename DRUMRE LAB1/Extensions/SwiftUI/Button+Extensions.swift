//
//  DRUMRE LAB1
//  Button+Extensions.swift
//
//  Andre Flego
//

import SwiftUI

extension Button {
    func highlightColor(highlightColor: Color) -> some View {
        modifier(
            HighlightedButtonViewModifier(highlightColor: highlightColor)
        )
    }
}
