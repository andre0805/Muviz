//
//  DRUMRE LAB1
//  LoadingModifier.swift
//
//  Andre Flego
//

import SwiftUI

struct LoadingModifier: ViewModifier {
    let isLoading: Bool

    func body(content: Content) -> some View {
        content
            .disabled(isLoading)
            .overlay {
                if isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                }
            }
    }
}

public extension View {
    @ViewBuilder
    func isLoading(_ isLoading: Bool) -> some View {
        modifier(LoadingModifier(isLoading: isLoading))
    }
}
