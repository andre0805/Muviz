//
//  RootViewModel.swift
//  DRUMRE LAB1
//
//  Andre Flego
//

import SwiftUI
import Combine

class RootViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()

    private let moviesApi: any MoviesAPIProtocol
    private let sessionManager: SessionManager
    private let fbLoginManager: FBLoginManager

    let input = Input()
    @Published private(set) var output = Output()

    init(
        moviesApi: any MoviesAPIProtocol,
        sessionManager: SessionManager,
        fbLoginManager: FBLoginManager
    ) {
        self.moviesApi = moviesApi
        self.sessionManager = sessionManager
        self.fbLoginManager = fbLoginManager
        bindInput()
    }
}

// MARK: Input & Output
extension RootViewModel {
    struct Input {
        let viewDidAppear = PassthroughSubject<Void, Never>()
        let updateState = PassthroughSubject<RootViewState, Never>()
    }

    struct Output {
        var state: RootViewState = .loading
    }

    enum RootViewState {
        case loading
        case authRequired
        case home
    }
}

// MARK: Bind Input
private extension RootViewModel {
    func bindInput() {
        bindViewDidAppear()
        bindSessionManager()
    }

    func bindViewDidAppear() {
        input.viewDidAppear
            .prefix(1)
            .sink {
            }
            .store(in: &cancellables)
    }

    func bindSessionManager() {
        sessionManager.$currentUser
            .receive(on: DispatchQueueFactory.background)
            .flatMap { [unowned self] user -> AnyPublisher<User?, Never> in
                guard let user else { return Just(nil).eraseToAnyPublisher() }
                return getUser(id: user.id)
            }
            .receive(on: DispatchQueueFactory.main)
            .sink { [unowned self] user in
                handleUserChanged(user: user)
            }
            .store(in: &cancellables)
    }
}

// MARK: Functions
private extension RootViewModel {
    func getUser(id: String) -> AnyPublisher<User?, Never> {
        Future { [unowned self] promise in
            Task {
                do {
                    let user = try await moviesApi.getUser(id: id)
                    promise(.success(user))
                } catch {
                    log.error(error)
                    promise(.success(nil))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func handleUserChanged(user: User?) {
        if let user {
            // prevent recursion
            if user != sessionManager.currentUser {
                sessionManager.login(user)
            }
        } else {
            fbLoginManager.loginManager.logOut()
        }

        withAnimation {
            output.state = user != nil ? .home : .authRequired
        }
    }
}
