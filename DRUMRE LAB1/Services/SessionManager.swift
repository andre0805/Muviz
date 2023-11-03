//
//  DRUMRE LAB1
//  SessionManager.swift
//
//  Andre Flego
//

import Combine
import FacebookLogin

class SessionManager: ObservableObject {
    static let shared = SessionManager()

    private let loginManager = LoginManager()

    @Published var currentUser: User? = LocalStorage.currentUser

    var isUserLoggedIn: Bool {
        return currentUser != nil
    }

    private init() { }

    func logOut() {
        loginManager.logOut()
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

// MARK: Facebook
extension SessionManager {
    func getFacebookUser() -> AnyPublisher<User?, FacebookError> {
        Future { [unowned self] promise in
            loginManager.logIn(
                permissions: ["public_profile", "email"],
                from: nil
            ) { result, error in
                if let error {
                    promise(.failure(.unknown(error)))
                    return
                }

                guard let result, !result.isCancelled else {
                    promise(.failure(.cancelledLogin))
                    return
                }

                let request = GraphRequest(
                    graphPath: "me",
                    parameters: ["fields": "id, name, email, picture.type(large)"]
                )

                request.start { _, res, error in
                    if let error {
                        promise(.failure(.unknown(error)))
                        return
                    }

                    guard let data = res as? [String: Any], let user = self.createUser(from: data) else {
                        promise(.failure(.invalidUserData))
                        return
                    }

                    promise(.success(user))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

private extension SessionManager {
    func createUser(from fbData: [String: Any]) -> User? {
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

        return User(id: id, name: name, email: email, imageUrl: pictureUrl)
    }
}
