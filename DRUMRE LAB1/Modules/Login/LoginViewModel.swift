//
//  DRUMRE LAB1
//  LoginViewModel.swift
//
//  Andre Flego
//

import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()

    private let sessionManager: SessionManager

    let input = Input()
    @Published private(set) var output = Output()

    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        bindInput()
    }
}

// MARK: Input & Output
extension LoginViewModel {
    struct Input {
        let viewDidAppear = PassthroughSubject<Void, Never>()
        let loginButtonTapped = PassthroughSubject<Void, Never>()
    }

    struct Output {
        let title: String = "Login"
    }
}

// MARK: Bind Input
private extension LoginViewModel {
    func bindInput() {
        bindViewDidAppear()
        bindLoginButtonTapped()
    }

    func bindViewDidAppear() {
        input.viewDidAppear
            .prefix(1)
            .sink {
            }
            .store(in: &cancellables)
    }

    func bindLoginButtonTapped() {
        input.loginButtonTapped
            .sink { [unowned self] _ in
                sessionManager.logIn()
            }
            .store(in: &cancellables)
    }
}

// MARK: Functions
private extension LoginViewModel {
}
