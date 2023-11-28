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
    private let loginRepository: LoginRepositoryProtocol

    let input = Input()
    @Published var output = Output()

    init(sessionManager: SessionManager, loginRepository: LoginRepositoryProtocol) {
        self.sessionManager = sessionManager
        self.loginRepository = loginRepository
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
        var isLoading = false
        var errorMessage: String?
        
        var isAlertPresented: Bool {
            get { errorMessage != nil }
            set { if !newValue { errorMessage = nil } }
        }
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
            .handleEvents(receiveOutput: { [unowned self] _ in
                withAnimation {
                    output.isLoading = true
                }
            })
            .flatMap { [unowned self] _ in
                loginUser()
            }
            .receive(on: DispatchQueueFactory.main)
            .delay(for: .seconds(1), scheduler: DispatchQueueFactory.main)
            .sink { [unowned self] _ in
                withAnimation {
                    output.isLoading = false
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: Functions
private extension LoginViewModel {
    func loginUser() -> AnyPublisher<Void, Never> {
        loginRepository.loginFB()
            .receive(on: DispatchQueueFactory.main)
            .flatMap { [unowned self] user -> AnyPublisher<Void, Never> in
                sessionManager.login(user)
                return Just(()).eraseToAnyPublisher()
            }
            .catch { [unowned self] error -> AnyPublisher<Void, Never> in
                if let fbError = error as? FacebookError {
                    output.errorMessage = (fbError != .cancelledLogin) ? fbError.message : nil
                } else {
                    output.errorMessage = error.localizedDescription
                }
                return Just(()).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
