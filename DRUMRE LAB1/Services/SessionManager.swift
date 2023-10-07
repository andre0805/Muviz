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

    func logIn() {
        getFacebookUser()
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
private extension SessionManager {
    func getFacebookUser() {
        loginManager.logIn(
            permissions: ["public_profile", "email"],
            from: nil
        ) { [unowned self] result, error in
            if let error {
                log.error("Facebook login error: \(error.localizedDescription)")
                return
            }

            guard let result, !result.isCancelled else {
                log.error("User cancelled Facebook login")
                return
            }

            let request = GraphRequest(
                graphPath: "me",
                parameters: ["fields": "id, name, email"]
            )

            request.start { _, res, error in
                if let error {
                    log.error("Facebook login error: \(error.localizedDescription)")
                    return
                }

                guard let data = res as? [String: Any], let user = User(from: data) else {
                    log.error("Failed to create user from facebook data")
                    return
                }

                self.setUser(user)
            }
        }
    }
}
