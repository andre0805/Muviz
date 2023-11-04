//
//  DRUMRE LAB1
//  HomeViewModel.swift
//
//  Andre Flego
//

import Foundation
import Combine
import UIKit
import SwiftUI

class HomeViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()

    let input = Input()
    @Published private(set) var output = Output()

    init() {
        bindInput()
    }
}

// MARK: Input & Output
extension HomeViewModel {
    struct Input {
    }

    struct Output {
    }
}

// MARK: Bind Input
private extension HomeViewModel {
    func bindInput() {
    }
}
