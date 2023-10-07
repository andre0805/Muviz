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

    let input = Input()
    @Published private(set) var output = Output()

    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
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
            .receive(on: DispatchQueueFactory.main)
            .sink { [unowned self] user in
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
