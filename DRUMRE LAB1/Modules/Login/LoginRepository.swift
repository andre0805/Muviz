//
//  DRUMRE LAB1
//  LoginRepository.swift
//
//  Andre Flego
//

import Combine
import FacebookLogin

protocol LoginRepositoryProtocol {
    var fbLoginManager: FBLoginManager { get }
    var moviesApi: any MoviesAPIProtocol { get }

    func loginFB() -> AnyPublisher<User, Error>
}

class LoginRepository: LoginRepositoryProtocol {
    let fbLoginManager: FBLoginManager
    let moviesApi: any MoviesAPIProtocol

    init(fbLoginManager: FBLoginManager, moviesApi: any MoviesAPIProtocol) {
        self.fbLoginManager = fbLoginManager
        self.moviesApi = moviesApi
    }

    func loginFB() -> AnyPublisher<User, Error> {
        getFacebookUser()
            .flatMap { [unowned self] fbUser -> AnyPublisher<User, Error> in
                createNewUserIfNeeded(fbUser)
            }
            .eraseToAnyPublisher()
    }
}

// MARK: Functions
private extension LoginRepository {
    func getFacebookUser() -> AnyPublisher<User, Error> {
        Future { [unowned self] promise in
            fbLoginManager.loginManager.logIn(
                permissions: ["public_profile", "email"],
                from: nil
            ) { result, error in
                if let error {
                    promise(.failure(error))
                    return
                }

                guard let result, !result.isCancelled else {
                    promise(.failure(FacebookError.cancelledLogin))
                    return
                }

                let request = GraphRequest(
                    graphPath: "me",
                    parameters: ["fields": "id, name, email, picture"]
                )

                request.start { _, res, error in
                    if let error {
                        promise(.failure(error))
                        return
                    }

                    guard 
                        let fbData = res as? [String: Any],
                        let user = User(from: fbData)
                    else {
                        promise(.failure(FacebookError.invalidUserData))
                        return
                    }

                    promise(.success(user))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func createNewUserIfNeeded(_ fbUser: User) -> AnyPublisher<User, Error> {
        Future { [unowned self] promise in
            Task {
                do {
                    let user = try await moviesApi.getUser(id: fbUser.id)
                    promise(.success(user))
                } catch APIError.userNotFound {
                    do {
                        let newUser = try await moviesApi.createUser(fbUser)
                        promise(.success(newUser))
                    } catch {
                        log.error(error)
                        promise(.failure(error))
                    }
                } catch {
                    log.error(error)
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

private extension User {
    init?(from fbData: [String: Any]) {
        guard
            let id = fbData["id"] as? String,
            let name = fbData["name"] as? String,
            let email = fbData["email"] as? String
        else {
            return nil
        }

        let picture = fbData["picture"] as? [String: Any]
        let pictureData = picture?["data"] as? [String: Any]
        let pictureUrl = pictureData?["url"] as? String

        self = User(id: id, name: name, email: email, imageUrl: pictureUrl)
    }
}
