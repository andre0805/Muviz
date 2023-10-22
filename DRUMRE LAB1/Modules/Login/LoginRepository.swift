//
//  DRUMRE LAB1
//  LoginRepository.swift
//
//  Andre Flego
//

import Combine

protocol LoginRepositoryProtocol {
    var sessionManager: SessionManager { get }
    var database: Database { get }

    func loginFB() -> AnyPublisher<Bool, FacebookError>
}

class LoginRepository: LoginRepositoryProtocol {
    var sessionManager: SessionManager
    var database: Database

    init(sessionManager: SessionManager, database: Database) {
        self.sessionManager = sessionManager
        self.database = database
    }

    func loginFB() -> AnyPublisher<Bool, FacebookError> {
        sessionManager.getFacebookUser()
            .flatMap { [unowned self] fbUser -> AnyPublisher<User?, Never> in
                guard let fbUser else { return Just(nil).eraseToAnyPublisher() }
                return createNewUserIfNeeded(fbUser)
            }
            .handleEvents(receiveOutput: { [unowned self] user in
                guard let user else { return }
                sessionManager.login(user)
            })
            .map { $0 != nil }
            .eraseToAnyPublisher()
    }

    private func createNewUserIfNeeded(_ fbUser: User) -> AnyPublisher<User?, Never> {
        database.getUser(for: fbUser.id)
            .flatMap { [unowned self] user -> AnyPublisher<User?, Never> in
                if let user, user != fbUser {
                    return Just(user).eraseToAnyPublisher()
                } else {
                    database.createUser(fbUser)
                    return Just(fbUser).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}
