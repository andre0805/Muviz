//
//  DRUMRE LAB1
//  Router.swift
//
//  Andre Flego
//

import SwiftUI

protocol PushDestination: Hashable {
}

protocol SheetDestination: Identifiable {
}

protocol SwitchDestination {
}

class Router<T: PushDestination, U: SheetDestination, V: SwitchDestination>: ObservableObject {
    typealias PushDestination = T
    typealias SheetDestination = U
    typealias SwitchDestination = V

    @Published var navigationPath: [PushDestination]
    @Published var sheet: SheetDestination?
    @Published var fullscreenSheet: SheetDestination?

    let onSwitch: ((SwitchDestination) -> Void)?

    init(onSwitch: ((SwitchDestination) -> Void)? = nil) {
        navigationPath = .init()
        self.onSwitch = onSwitch
    }

    func push(to pushDestination: PushDestination) {
        guard pushDestination != navigationPath.last else {
            log.error("\(pushDestination) is already presented on top of the stack")
            return
        }

        navigationPath.append(pushDestination)
    }

    func present(_ sheet: SheetDestination, isFullscreen: Bool = false) {
        if isFullscreen {
            self.fullscreenSheet = sheet
        } else {
            self.sheet = sheet
        }
    }

    func dismiss() {
        sheet = nil
        fullscreenSheet = nil
    }

    func pop() {
        navigationPath.removeLast()
    }

    func popToRoot() {
        navigationPath.removeAll()
    }

    func reset() {
        dismiss()
        popToRoot()
    }

    func `switch`(to switchDestination: SwitchDestination) {
        reset()
        onSwitch?(switchDestination)
    }

    func handleDeeplinkDestination(_ destination: String, with data: [String: String]? = nil) {
        log.error("Missing implementation")
    }
}
