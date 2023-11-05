//
//  DRUMRE LAB1
//  SearchBarModifier.swift
//
//  Andre Flego
//

import SwiftUI

struct SearchBarModifier: ViewModifier {
    var tintColor: UIColor?

    init(tintColor: UIColor?) {
        self.tintColor = tintColor

        UISearchBar.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).tintColor = tintColor
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = tintColor?.withAlphaComponent(0.1)
    }

    func body(content: Content) -> some View {
        content
    }
}

extension View {
    func searchBarColor(tintColor: Color?) -> some View {
        let uiTintColor: UIColor? = if let tintColor { UIColor(tintColor) } else { nil }
        return self.modifier(SearchBarModifier(tintColor: uiTintColor))
    }
}
