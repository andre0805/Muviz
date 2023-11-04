//
//  DRUMRE LAB1
//  UserInfoRouterView.swift
//
//  Andre Flego
//

import SwiftUI

struct UserInfoRouterView: View {
    @EnvironmentObject private var sessionManager: SessionManager
    @StateObject private var userInfoRouter: UserInfoRouter

    init(userInfoRouter: UserInfoRouter) {
        self._userInfoRouter = StateObject(wrappedValue: userInfoRouter)
    }

    var body: some View {
        NavigationStack(path: $userInfoRouter.navigationPath) { [unowned userInfoRouter] in
            UserInfoView {
                UserInfoViewModel(userInfoRouter: userInfoRouter)
            }
            .navigationDestination(for: UserInfoPushDestination.self) { destination in
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
        }
    }
}
