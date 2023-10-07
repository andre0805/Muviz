//
//  RootViewModel.swift
//  DRUMRE LAB1
//
//  Andre Flego
//

import Foundation
import Combine

class RootViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()

    let input = Input()
    @Published private(set) var output = Output()

    init() {
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
    }

    func bindViewDidAppear() {
        input.viewDidAppear
            .prefix(1)
            .sink { [unowned self] in
            }
            .store(in: &cancellables)
    }
}

// MARK: Functions
private extension RootViewModel {
}
