//
//  RootViewModel.swift
//  DRUMRE LAB1
//
//  Created by Andre Flego on 07.10.2023..
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
    }

    struct Output {
        let title: String = ""
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
