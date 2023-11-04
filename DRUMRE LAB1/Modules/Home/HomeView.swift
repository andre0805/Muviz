//
//  DRUMRE LAB1
//  HomeView.swift
//
//  Andre Flego
//

import SwiftUI
import Combine

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel

    @State private var selectedTab: Tab = .movies

    enum Tab {
        case movies
        case search
    }

    init(_ viewModel: @escaping () -> HomeViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            moviesTab
                .tag(Tab.movies)
                .tabItem {
                    Label("Movies", systemImage: "movieclapper")
                }

            searchTab
                .tag(Tab.search)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }
    }
}

// MARK: Views
private extension HomeView {
    var moviesTab: some View {
        MoviesRouterView(moviesRouter: MoviesRouter())
    }

    var searchTab: some View {
        SearchRouterView(searchRouter: SearchRouter())
    }
}

#Preview {
    HomeView {
        HomeViewModel()
    }
}
