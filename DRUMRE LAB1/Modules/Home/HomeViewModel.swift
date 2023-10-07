//
//  DRUMRE LAB1
//  HomeViewModel.swift
//
//  Andre Flego
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()

    private let sessionManager: SessionManager

    let input = Input()
    @Published private(set) var output: Output

    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        self.output = Output(user: sessionManager.currentUser ?? User(id: "1", name: "Andre", email: "ade.flego@gmail.com"))
        bindInput()
    }
}

// MARK: Input & Output
extension HomeViewModel {
    struct Input {
        let viewDidAppear = PassthroughSubject<Void, Never>()
        let logoutButtonTapped = PassthroughSubject<Void, Never>()
    }

    struct Output {
        let title: String = "Home"
        let user: User
    }
}

// MARK: Bind Input
private extension HomeViewModel {
    func bindInput() {
        bindViewDidAppear()
        bindLogoutButtonTapped()
    }

    func bindViewDidAppear() {
        input.viewDidAppear
            .prefix(1)
            .sink {
            }
            .store(in: &cancellables)
    }

    func bindLogoutButtonTapped() {
        input.logoutButtonTapped
            .sink { [unowned self] _ in
                sessionManager.logOut()
            }
            .store(in: &cancellables)
    }
}

// MARK: Functions
private extension HomeViewModel {
}
