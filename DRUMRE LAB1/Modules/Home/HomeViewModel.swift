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

    private let homeRepository: HomeRepositoryProtocol

    let input = Input()
    @Published private(set) var output: Output

    init(homeRepository: HomeRepositoryProtocol) {
        self.homeRepository = homeRepository
        self.output = Output(user: homeRepository.sessionManager.currentUser)
        bindInput()
    }
}

// MARK: Input & Output
extension HomeViewModel {
    struct Input {
        let viewDidAppear = PassthroughSubject<Void, Never>()
        let logoutButtonTapped = PassthroughSubject<Void, Never>()
        let updateUserButtonTapped = PassthroughSubject<Void, Never>()
    }

    struct Output {
        let title: String = "Home"
        let user: User!
    }
}

// MARK: Bind Input
private extension HomeViewModel {
    func bindInput() {
        bindViewDidAppear()
        bindLogoutButtonTapped()
        bindUpdateUserButtonTapped()
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
                homeRepository.logout()
            }
            .store(in: &cancellables)
    }

    func bindUpdateUserButtonTapped() {
        input.updateUserButtonTapped
            .sink { [unowned self] _ in
                homeRepository.updateUser()
            }
            .store(in: &cancellables)
    }
}

// MARK: Functions
private extension HomeViewModel {
}
