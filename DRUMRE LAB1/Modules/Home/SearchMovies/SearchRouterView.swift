//
//  DRUMRE LAB1
//  SearchRouterView.swift
//
//  Andre Flego
//

import SwiftUI

struct SearchRouterView: View {
    @EnvironmentObject private var moviesApi: MoviesAPI
    @EnvironmentObject private var sessionManager: SessionManager

    @StateObject private var searchRouter: SearchRouter

    init(searchRouter: SearchRouter) {
        self._searchRouter = StateObject(wrappedValue: searchRouter)
    }

    var body: some View {
        NavigationStack(path: $searchRouter.navigationPath) { [unowned searchRouter] in
            SearchMoviesView {
                SearchMoviesViewModel(
                    searchRouter: searchRouter,
                    searchMoviesRepository: SearchMoviesRepository(moviesApi: moviesApi),
                    sessionManager: sessionManager
                )
            }
            .navigationDestination(for: SearchPushDestination.self) { destination in
                switch destination {
                case .movieDetails(let movie):
                    MovieDetailsView {
                        MovieDetailsViewModel(
                            movie: movie,
                            movieDetailsRepository: MovieDetailsRepository(
                                sessionManager: sessionManager,
                                moviesApi: moviesApi
                            )
                        )
                    }
                }
            }
            .sheet(item: $searchRouter.sheet) { sheet in
                sheetView(for: sheet)
            }
            .fullScreenCover(item: $searchRouter.fullscreenSheet) { sheet in
                sheetView(for: sheet)
            }
        }
    }

    @ViewBuilder
    private func sheetView(for sheet: SearchSheetDestination) -> some View {
        switch sheet {
        case .userInfo:
            UserInfoRouterView(
                userInfoRouter: UserInfoRouter(
                    onSwitch: { destination in
                        switch destination {
                        case .home:
                            searchRouter.dismiss()
                        }
                    }
                )
            )
            .environmentObject(moviesApi)
            .environmentObject(sessionManager)
        }
    }
}

