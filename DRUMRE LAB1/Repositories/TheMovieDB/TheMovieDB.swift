//
//  DRUMRE LAB1
//  TheMovieDB.swift
//
//  Andre Flego
//

import Foundation

protocol TheMovieDBProtocol {
    var cachedGenres: [TMDBGenre] { get }
    var cachedMovies: [TMDBMovie] { get }

    func getGenres() async throws -> [TMDBGenre]
    func getMovies(page: Int) async throws -> [TMDBMovie]
}

class TheMovieDB: TheMovieDBProtocol {    
    let baseURL = "api.themoviedb.org"
    let apiKey = "a6a28403da7287a32604ff37a6a0f2b9"
    let token = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhNmEyODQwM2RhNzI4N2EzMjYwNGZmMzdhNmEwZjJiOSIsInN1YiI6IjY1NDAxMjRmMWQxYmY0MDEwMTYyNGZlYyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.rlb3ysEUFE7ZDQHmNx19KAji0L-G3vBBeCvcWXRpug0"

    private(set) var cachedGenres: [TMDBGenre] = []
    private(set) var cachedMovies: [TMDBMovie] = []

    func getGenres() async throws -> [TMDBGenre] {
        let urlRequest = try RequestBuilder(
            baseURL: baseURL,
            path: "/3/genre/movie/list"
        )
            .addHeader("application/json", forKey: "accept")
            .addHeader("Bearer \(token)", forKey: "Authorization")
            .addQueryItem(apiKey, forKey: "apiKey")
            .addQueryItem("en", forKey: "language")
            .build()

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard 
            let response = response as? HTTPURLResponse,
            response.statusCode == 200
        else {
            throw APIError.invalidResponse
        }

        do {
            let genresResponse =  try JSONDecoder().decode(TMDBGenresResponse.self, from: data)
            self.cachedGenres = genresResponse.genres
            return genresResponse.genres
        } catch {
            throw APIError.decoderFailed
        }
    }

    func getMovies(page: Int = 1) async throws -> [TMDBMovie] {
        let urlRequest = try RequestBuilder(
            baseURL: baseURL,
            path: "/3/discover/movie"
        )
            .addHeader("application/json", forKey: "accept")
            .addHeader("Bearer \(token)", forKey: "Authorization")
            .addQueryItem(apiKey, forKey: "apiKey")
            .addQueryItem("en-US", forKey: "language")
            .addQueryItem("\(page)", forKey: "page")
            .addQueryItem("popularity.desc", forKey: "sort_by")
            .addQueryItem("false", forKey: "include_video")
            .addQueryItem("false", forKey: "include_adult")
            .build()

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard
            let response = response as? HTTPURLResponse,
            response.statusCode == 200
        else {
            throw APIError.invalidResponse
        }

        do {
            let moviesResponse =  try JSONDecoder().decode(TMDBMoviesResponse.self, from: data)
            var movies = moviesResponse.results
            movies.removeDuplicates()

            self.cachedMovies.append(contentsOf: movies)
            self.cachedMovies.removeDuplicates()

            return movies
        } catch {
            throw APIError.decoderFailed
        }
    }
}

extension Array where Element: Hashable {
    mutating func removeDuplicates() {
        let uniqueElements = Set(self)
        self = Array(uniqueElements)
    }
}
