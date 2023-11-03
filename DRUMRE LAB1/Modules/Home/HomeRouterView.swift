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
        NavigationStack(path: $homeRouter.navigationPath) {
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
        case .userInfo(let user):
            VStack {
                Text("Logged in as: \(user.name)")
                    .bold()

                Button {
                    homeRouter.reset()
                    sessionManager.logOut()
                } label: {
                    Text("Logout")
                        .bold()
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .foregroundStyle(.white)
                        .background(Color(red: 8/255, green: 102/255, blue: 255/255))
                        .clipShape(Capsule())
                }
            }
        }
    }
}
