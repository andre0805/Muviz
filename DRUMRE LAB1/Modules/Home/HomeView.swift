//
//  DRUMRE LAB1
//  HomeView.swift
//
//  Andre Flego
//

import SwiftUI
import Combine

struct HomeView: View {
    @EnvironmentObject private var moviesApi: MoviesAPI
    @EnvironmentObject private var sessionManager: SessionManager

    @StateObject private var moviesRouter: MoviesRouter
    @StateObject private var searchRouter: SearchRouter

    @State private var selectedTab: Tab = .movies

    private let activeColor = Color.blackPrimary
    private let inactiveColor = Color.blackPrimary.opacity(0.3)

    init() {
        self._searchRouter = StateObject(wrappedValue: SearchRouter())
        self._moviesRouter = StateObject(wrappedValue: MoviesRouter())
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            tabViews

            tabBar
                .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .environmentObject(sessionManager)
    }
}

// MARK: Views
private extension HomeView {
    var tabViews: some View {
        TabView(selection: $selectedTab) {
            moviesTab
                .tag(Tab.movies)

            searchTab
                .tag(Tab.search)
        }
    }

    var moviesTab: some View {
        MoviesRouterView(moviesRouter: moviesRouter)
            .environmentObject(moviesApi)
            .environmentObject(sessionManager)
    }

    var searchTab: some View {
        SearchRouterView(searchRouter: searchRouter)
            .environmentObject(moviesApi)
            .environmentObject(sessionManager)
    }


    var tabBar: some View {
        HStack(alignment: .center) {
            Spacer()
            tabItem(for: .movies)
            Spacer()
            Spacer()
            tabItem(for: .search)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.backgroundColor)
    }

    func tabItem(for tab: Tab) -> some View {
        VStack {
            Rectangle()
                .fill(selectedTab == tab ? activeColor : inactiveColor)
                .frame(height: 6)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 4)
                .opacity(tab == selectedTab ? 1 : 0)

            tabItemButton(for: tab)
        }
    }

    @ViewBuilder
    func tabItemButton(for tab: Tab) -> some View {
        Button {
            if selectedTab != tab {
                withAnimation { selectedTab = tab }
            } else {
                resetRouter(at: tab)
            }
        } label: {
            VStack(spacing: 8) {
                tabItemIcon(for: tab)

                Text(tab.title)
                    .font(.system(size: 14))
                    .foregroundColor(selectedTab == tab ? activeColor : inactiveColor)
            }
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    func tabItemIcon(for tab: Tab) -> some View {
        ZStack {
            tab.icon
                .resizable()
                .scaledToFit()
                .frame(width: 24)
                .foregroundStyle(selectedTab == tab ? activeColor : inactiveColor)
        }
    }
}

// MARK: Tab
private extension HomeView {
    enum Tab {
        case movies
        case search

        var title: String {
            switch self {
            case .movies:
                return "Movies"
            case .search:
                return "Search"
            }
        }

        var icon: Image {
            switch self {
            case .movies:
                return Image(systemName: "movieclapper")
            case .search:
                return Image(systemName: "magnifyingglass")
            }
        }
    }
}

// MARK: Functions
private extension HomeView {
    func resetRouter(at tab: Tab) {
        switch tab {
        case .movies:
            moviesRouter.reset()
        case .search:
            searchRouter.reset()
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(SessionManager.shared)
        .environmentObject(MoviesAPI.shared)
}
