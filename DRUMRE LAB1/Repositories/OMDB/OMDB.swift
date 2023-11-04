//
//  DRUMRE LAB1
//  OMDB.swift
//
//  Andre Flego
//

import Foundation

protocol OMDBProtocol {
    func searchMovies(_ searchQuery: String) async throws -> [OMDBMovieDetails]
}

class OMDB: OMDBProtocol {
    let baseURL = "www.omdbapi.com"
    let apiKey = "f05a2497"

    func searchMovies(_ searchQuery: String) async throws -> [OMDBMovieDetails] {
        let urlRequest = try RequestBuilder(
            baseURL: baseURL,
            path: ""
        )
            .addQueryItem(apiKey, forKey: "apiKey")
            .addQueryItem(searchQuery, forKey: "s")
            .build()

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard
            let response = response as? HTTPURLResponse,
            response.statusCode == 200
        else {
            throw APIError.invalidResponse
        }

        do {
            let omdbMoviesResponse =  try OMDBMoviesResponse<OMDBMoviesResponseSuccess>(from: data)

            switch omdbMoviesResponse {
            case .success(let success):
                var omdbMovies: [OMDBMovieDetails] = []
                
                for movie in success.search {
                    if let movieDetails = try await getMovieDetails(movie.id) {
                        omdbMovies.append(movieDetails)
                    }
                }

                return omdbMovies

            case .error(let error):
                log.error(error)
                return []
            }

        } catch {
            log.error(error)
            throw APIError.decoderFailed
        }
    }

    private func getMovieDetails(_ id: String) async throws -> OMDBMovieDetails? {
        let urlRequest = try RequestBuilder(
            baseURL: baseURL,
            path: ""
        )
            .addQueryItem(apiKey, forKey: "apiKey")
            .addQueryItem(id, forKey: "i")
            .build()

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard
            let response = response as? HTTPURLResponse,
            response.statusCode == 200
        else {
            throw APIError.invalidResponse
        }

        do {
            let omdbMoviesResponse =  try OMDBMoviesResponse<OMDBMovieDetails>(from: data)

            switch omdbMoviesResponse {
            case .success(let success):
                return success
            case .error(let error):
                log.error(error)
                return nil
            }

        } catch {
            throw APIError.decoderFailed
        }
    }
}
