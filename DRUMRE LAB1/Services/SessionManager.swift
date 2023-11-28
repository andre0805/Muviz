//
//  DRUMRE LAB1
//  SessionManager.swift
//
//  Andre Flego
//

import Combine


class SessionManager: ObservableObject {
    static let shared = SessionManager()

    @Published var currentUser: User? = LocalStorage.currentUser

    var isUserLoggedIn: Bool {
        return currentUser != nil
    }

    private init() { }

    func logOut() {
        setUser(nil)
    }

    func login(_ user: User) {
        setUser(user)
    }
}

// MARK: Functions
private extension SessionManager {
     func setUser(_ user: User?) {
        currentUser = user
        LocalStorage.currentUser = user
    }
}
