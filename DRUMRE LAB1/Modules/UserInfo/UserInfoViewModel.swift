//
//  DRUMRE LAB1
//  UserInfoViewModel.swift
//
//  Andre Flego
//

import Foundation
import Combine

class UserInfoViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()

    let input = Input()
    @Published private(set) var output: Output

    private let userInfoRouter: UserInfoRouter
    private let sessionManager = SessionManager.shared

    init(userInfoRouter: UserInfoRouter) {
        self.userInfoRouter = userInfoRouter
        self.output = Output(user: sessionManager.currentUser ?? .mock)
        bindInput()
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
        let user: User
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
}
