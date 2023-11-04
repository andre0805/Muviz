//
//  DRUMRE LAB1
//  HomeRouterView.swift
//
//  Andre Flego
//

import SwiftUI

struct HomeRouterView: View {
    @EnvironmentObject private var sessionManager: SessionManager
    @StateObject private var homeRouter: HomeRouter

    init(homeRouter: HomeRouter) {
        self._homeRouter = StateObject(wrappedValue: homeRouter)
    }

    var body: some View {
        NavigationStack(path: $homeRouter.navigationPath) { [unowned homeRouter] in
            HomeView {
                HomeViewModel(
                    router: homeRouter,
                    homeRepository: HomeRepository(
                        sessionManager: sessionManager,
                        database: .shared,
                        theMovieDB: TheMovieDB()
                    )
                )
            }
            .navigationDestination(for: HomePushDestination.self) { destination in
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
            .sheet(item: $homeRouter.sheet) { sheet in
                sheetView(for: sheet)
            }
            .fullScreenCover(item: $homeRouter.fullscreenSheet) { sheet in
                sheetView(for: sheet)
            }
        }
    }

    @ViewBuilder
    private func sheetView(for sheet: HomeSheetDestination) -> some View {
        switch sheet {
        case .userInfo:
            UserInfoRouterView(
                userInfoRouter: UserInfoRouter(
                    onSwitch: { destination in
                        switch destination {
                        case .home:
                            homeRouter.dismiss()
                        }
                    }
                )
            )
        }
    }
}
