//
//  DRUMRE LAB1
//  HomeRepository.swift
//
//  Andre Flego
//

import Combine

protocol HomeRepositoryProtocol {
    var sessionManager: SessionManager { get }
    var database: Database { get }

    func logout()
    func updateUser()
}

class HomeRepository: HomeRepositoryProtocol {
    var sessionManager: SessionManager
    var database: Database

    init(sessionManager: SessionManager, database: Database) {
        self.sessionManager = sessionManager
        self.database = database
    }

    func logout() {
        sessionManager.logOut()
    }

    func updateUser() {
        guard let currentUser = sessionManager.currentUser else { return }
        let updatedUser = User(id: currentUser.id, name: "John Doe", email: "john.doe@google.com")
        database.updateUser(updatedUser)
    }
}
