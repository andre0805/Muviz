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

    private let sessionManager: SessionManager
    private let database: Database

    let input = Input()
    @Published private(set) var output = Output()

    init(sessionManager: SessionManager, database: Database) {
        self.sessionManager = sessionManager
        self.database = database
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
            .flatMap { [unowned self] user in
                guard let user else { return Just(user).eraseToAnyPublisher() }
                return database.getUser(for: user.id)
            }
            .receive(on: DispatchQueueFactory.main)
            .sink { [unowned self] user in
                if let user, user != sessionManager.currentUser {
                    sessionManager.login(user)
                }

                withAnimation {
                    output.state = user != nil ? .home : .authRequired
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: Functions
private extension RootViewModel {
}
