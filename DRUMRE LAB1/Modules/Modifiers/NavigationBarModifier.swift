//
//  DRUMRE LAB1
//  NavigationBarModifier.swift
//
//  Andre Flego
//

import SwiftUI

struct NavigationBarModifier: ViewModifier {

    var backgroundColor: UIColor?
    var titleColor: UIColor?

    init(backgroundColor: UIColor?, titleColor: UIColor?) {
        self.backgroundColor = backgroundColor
        
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = backgroundColor
        coloredAppearance.titleTextAttributes = [.foregroundColor: titleColor ?? .white]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor ?? .white]

        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    }

    func body(content: Content) -> some View {
        ZStack{
            content
            
            VStack {
                GeometryReader { geometry in
                    Color(self.backgroundColor ?? .clear)
                        .frame(height: geometry.safeAreaInsets.top)
                        .edgesIgnoringSafeArea(.top)
                    
                    Spacer()
                }
            }
        }
    }
}

extension View {
    func navigationBarColor(backgroundColor: Color? = nil, titleColor: Color? = nil) -> some View {
        let uiBackgroundColor: UIColor? = if let backgroundColor { UIColor(backgroundColor) } else { nil }
        let uiTitleColor: UIColor? = if let titleColor { UIColor(titleColor) } else { nil }
        return self.modifier(NavigationBarModifier(backgroundColor: uiBackgroundColor, titleColor: uiTitleColor))
    }
}
