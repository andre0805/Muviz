//
//  DRUMRE LAB1
//  Database.swift
//
//  Andre Flego
//

import Combine
import FirebaseDatabase

class Database {
    static let shared = Database()

    private let ref: DatabaseReference!

    private init() {
        self.ref = FirebaseDatabase.Database.database(url: Constants.FirebaseDatabase.url).reference()
    }
}

// MARK: Functions
extension Database {
    func getUser(for userId: String) -> AnyPublisher<User?, Never> {
        Future { [unowned self] promise in
            let userRef = ref.child("users").child(userId)
            userRef.observeSingleEvent(of: .value) { snapshot in
                guard let data = snapshot.value as? [String: Any] else {
                    promise(.success(nil))
                    return
                }
                let user = User(from: data)
                promise(.success(user))
            }
        }
        .eraseToAnyPublisher()
    }

    func createUser(_ user: User) {
        let userRef = ref.child("users").child(user.id)
        userRef.setValue(user.toDictionary())
    }

    func updateUser(_ user: User) {
        let userRef = ref.child("users").child(user.id)
        userRef.setValue(user.toDictionary())
    }
}
