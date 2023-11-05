//
//  DRUMRE LAB1
//  HighlightedButtonStyle.swift
//
//  Andre Flego
//

import SwiftUI

struct HighlightedButtonStyle: ButtonStyle {
    var highlightColor: Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        let color: Color = configuration.isPressed ? highlightColor : .clear
        configuration.label
            .background(color)
            .contentShape(Rectangle())
    }
}
