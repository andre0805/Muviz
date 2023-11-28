//
//  DRUMRE LAB1
//  MoviesAPI.swift
//
//  Andre Flego
//

import Foundation

protocol MoviesAPIProtocol: ObservableObject {
    func getGenres() async throws -> [Genre]
    
    func getMovies(lastTitle: String?) async throws -> [Movie]
    func searchMovies(_ searchQuery: String, lastTitle: String?) async throws -> [Movie]

    func getUser(id: String) async throws -> User
    func createUser(_ user: User) async throws -> User
    func updateUser(_ user: User) async throws -> User
}

class MoviesAPI: MoviesAPIProtocol {
    let baseURL = "drumre-lab1-backend.onrender.com"

    static let shared = MoviesAPI()

    private init() { }

    func getGenres() async throws -> [Genre] {
        let urlRequest = try RequestBuilder(baseURL: baseURL, path: "/genres")
            .build()

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard
            let response = response as? HTTPURLResponse,
            response.statusCode == 200
        else {
            throw APIError.invalidResponse
        }

        do {
            return try JSONDecoder().decode([Genre].self, from: data)
        } catch {
            log.error(error)
            throw APIError.decoderFailed
        }
    }

    func getMovies(lastTitle: String? = nil) async throws -> [Movie] {
        let urlRequest = try RequestBuilder(baseURL: baseURL, path: "/movies")
            .addQueryItem(lastTitle, forKey: "lastTitle")
            .addQueryItem("20", forKey: "pageSize")
            .build()

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard
            let response = response as? HTTPURLResponse,
            response.statusCode == 200
        else {
            throw APIError.invalidResponse
        }

        do {
            return try JSONDecoder().decode([Movie].self, from: data)
        } catch {
            log.error(error)
            throw APIError.decoderFailed
        }
    }

    func searchMovies(_ searchQuery: String, lastTitle: String? = nil) async throws -> [Movie] {
        let urlRequest = try RequestBuilder(baseURL: baseURL, path: "/movies/search")
            .addQueryItem(searchQuery, forKey: "searchQuery")
            .addQueryItem(lastTitle, forKey: "lastTitle")
            .build()

        let (data, _) = try await URLSession.shared.data(for: urlRequest)

        do {
            return try JSONDecoder().decode([Movie].self, from: data)
        } catch {
            log.error(error)
            throw APIError.decoderFailed
        }
    }


    func getUser(id: String) async throws -> User {
        let urlRequest = try RequestBuilder(baseURL: baseURL, path: "/users/\(id)")
            .build()

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let response = response as? HTTPURLResponse else { throw APIError.invalidResponse }

        if response.statusCode == 404 { throw APIError.userNotFound }

        do {
            return try JSONDecoder().decode(User.self, from: data)
        } catch {
            log.error(error)
            throw APIError.decoderFailed
        }
    }

    func createUser(_ user: User) async throws -> User {
        let urlRequest = try RequestBuilder(baseURL: baseURL, path: "/users")
            .setMethod(.post)
            .addHeader("application/json", forKey: "Content-Type")
            .addBody(user.id, forKey: "id")
            .addBody(user.name, forKey: "name")
            .addBody(user.email, forKey: "email")
            .addBody(user.imageUrl ?? "", forKey: "imageUrl")
            .addBody(user.favoriteMovies, forKey: "favoriteMovies")
            .build()

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let response = response as? HTTPURLResponse else { throw APIError.invalidResponse }

        if response.statusCode == 409 { throw APIError.userAlreadyExists }

        do {
            return try JSONDecoder().decode(User.self, from: data)
        } catch {
            log.error(error)
            throw APIError.decoderFailed
        }
    }

    func updateUser(_ user: User) async throws -> User {
        let urlRequest = try RequestBuilder(baseURL: baseURL, path: "/users")
            .setMethod(.put)
            .addHeader("application/json", forKey: "Content-Type")
            .addBody(user.id, forKey: "id")
            .addBody(user.name, forKey: "name")
            .addBody(user.email, forKey: "email")
            .addBody(user.imageUrl ?? "", forKey: "imageUrl")
            .addBody(user.favoriteMovies.map { $0.id }, forKey: "favoriteMovies")
            .build()

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let response = response as? HTTPURLResponse else { throw APIError.invalidResponse }

        if response.statusCode == 404 { throw APIError.userNotFound }

        do {
            return try JSONDecoder().decode(User.self, from: data)
        } catch {
            log.error(error)
            throw APIError.decoderFailed
        }
    }
}
