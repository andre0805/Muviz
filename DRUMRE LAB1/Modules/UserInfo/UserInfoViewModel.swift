//
//  DRUMRE LAB1
//  UserInfoViewModel.swift
//
//  Andre Flego
//

import SwiftUI
import Combine

class UserInfoViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()

    let input = Input()
    @Published private(set) var output: Output

    private let userInfoRouter: UserInfoRouter
    private let sessionManager: SessionManager

    init(
        userInfoRouter: UserInfoRouter,
        sessionManager: SessionManager
    ) {
        self.userInfoRouter = userInfoRouter
        self.sessionManager = sessionManager

        self.output = Output(user: sessionManager.currentUser ?? .mock)
        
        bindInput()
        bindUser()
    }
}

// MARK: Input & Output
extension UserInfoViewModel {
    struct Input {
        let logoutButtonTapped = PassthroughSubject<Void, Never>()
        let movieTapped = PassthroughSubject<Movie, Never>()
    }

    struct Output {
        let title: String = "User info"
        var user: User
    }
}

// MARK: Bind Input
private extension UserInfoViewModel {
    func bindInput() {
        bindLogoutButtonTapped()
        bindMovieTapped()
    }

    func bindLogoutButtonTapped() {
        input.logoutButtonTapped
            .sink { [unowned self] _ in
                userInfoRouter.reset()
                userInfoRouter.switch(to: .home)
                sessionManager.logOut()
            }
            .store(in: &cancellables)
    }

    func bindMovieTapped() {
        input.movieTapped
            .sink { [unowned self] movie in
                userInfoRouter.push(to: .movieDetails(movie))
            }
            .store(in: &cancellables)
    }
}

// MARK: Functions
private extension UserInfoViewModel {
    func bindUser() {
        sessionManager.$currentUser
            .sink { [unowned self] user in
                guard let user else { return }
                
                withAnimation {
                    output.user = user
                }
            }
            .store(in: &cancellables)
    }
}
