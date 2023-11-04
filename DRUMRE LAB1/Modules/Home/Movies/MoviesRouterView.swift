//
//  DRUMRE LAB1
//  MoviesRouterView.swift
//
//  Andre Flego
//

import SwiftUI

struct MoviesRouterView: View {
    @EnvironmentObject private var sessionManager: SessionManager
    @StateObject private var moviesRouter: MoviesRouter

    init(moviesRouter: MoviesRouter) {
        self._moviesRouter = StateObject(wrappedValue: moviesRouter)
    }

    var body: some View {
        NavigationStack(path: $moviesRouter.navigationPath) { [unowned moviesRouter] in
            MoviesView {
                MoviesViewModel(
                    moviesRouter: moviesRouter,
                    moviesRepository: MoviesRepository(theMovieDB: TheMovieDB()),
                    sessionManager: sessionManager
                )
            }
            .navigationDestination(for: MoviesPushDestination.self) { destination in
                switch destination {
                case .movieDetails(let movie):
                    MovieDetailsView {
                        MovieDetailsViewModel(
                            movie: movie,
                            movieDetailsRepository: MovieDetailsRepository(
                                sessionManager: .shared,
                                database: .shared
                            )
                        )
                    }
                }
            }
            .sheet(item: $moviesRouter.sheet) { sheet in
                sheetView(for: sheet)
            }
            .fullScreenCover(item: $moviesRouter.fullscreenSheet) { sheet in
                sheetView(for: sheet)
            }
        }
    }

    @ViewBuilder
    private func sheetView(for sheet: MoviesSheetDestination) -> some View {
        switch sheet {
        case .userInfo:
            UserInfoRouterView(
                userInfoRouter: UserInfoRouter(
                    onSwitch: { destination in
                        switch destination {
                        case .home:
                            moviesRouter.dismiss()
                        }
                    }
                )
            )
        }
    }
}
