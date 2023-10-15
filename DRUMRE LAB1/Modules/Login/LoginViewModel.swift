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

    private let loginRepository: LoginRepositoryProtocol

    let input = Input()
    @Published var output = Output()

    init(loginRepository: LoginRepositoryProtocol) {
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
            .sink { [unowned self] success in
                withAnimation {
                    output.isLoading = success
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: Functions
private extension LoginViewModel {
    func loginUser() -> AnyPublisher<Bool, Never> {
        loginRepository.loginFB()
            .catch { [unowned self] error in
                DispatchQueueFactory.main.async {
                    self.output.errorMessage = (error != .cancelledLogin) ? error.message : nil
                }
                return Just(false)
            }
            .eraseToAnyPublisher()
    }
}
