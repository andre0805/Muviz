//
//  DRUMRE LAB1
//  TheMovieDBMock.swift
//
//  Andre Flego
//

import Foundation

class TheMovieDBMock: TheMovieDBProtocol {
    private(set) var cachedGenres: [TMDBGenre] = []
    private(set) var cachedMovies: [TMDBMovie] = []

    func getGenres() async throws -> [TMDBGenre] {
        let genres = [
            TMDBGenre(id: 1, name: "Action"),
            TMDBGenre(id: 2, name: "Comedy"),
            TMDBGenre(id: 3, name: "Drama"),
            TMDBGenre(id: 4, name: "Crimi"),
            TMDBGenre(id: 5, name: "Science Fiction and Fantasy"),
            TMDBGenre(id: 6, name: "Romance"),
            TMDBGenre(id: 7, name: "Mystery"),
            TMDBGenre(id: 8, name: "Documentary"),
            TMDBGenre(id: 9, name: "Animation"),
            TMDBGenre(id: 10, name: "Horror"),
        ]

        self.cachedGenres = genres
        
        return genres
    }

    func getMovies(page: Int = 1) async throws -> [TMDBMovie] {
        let movies = [
            TMDBMovie(
                id: 1,
                title: "Movie 1",
                overview: "An exciting movie",
                originalLanguage: "English",
                releaseDate: "2023-01-01",
                genreIds: [1],
                posterPath: "poster1.jpg"
            ),
            
            TMDBMovie(
                id: 2,
                title: "Movie 2", 
                overview: "A funny comedy",
                originalLanguage: "English",
                releaseDate: "2023-02-01", 
                genreIds: [2, 6],
                posterPath: "poster2.jpg"
            ),
            TMDBMovie(
                id: 3,
                title: "Movie 3", 
                overview: "A dramatic story",
                originalLanguage: "Spanish",
                releaseDate: "2023-03-01", 
                genreIds: [3, 7],
                posterPath: "poster3.jpg"
            ),
            TMDBMovie(
                id: 4,
                title: "Movie 4", 
                overview: "An action-packed adventure",
                originalLanguage: "English",
                releaseDate: "2023-04-01", 
                genreIds: [1, 4],
                posterPath: "poster4.jpg"
            ),
            TMDBMovie(
                id: 5,
                title: "Movie 5", 
                overview: "A romantic tale",
                originalLanguage: "French",
                releaseDate: "2023-05-01", 
                genreIds: [6],
                posterPath: "poster5.jpg"
            ),
            TMDBMovie(
                id: 6,
                title: "Movie 6", 
                overview: "A thrilling mystery",
                originalLanguage: "English",
                releaseDate: "2023-06-01", 
                genreIds: [7],
                posterPath: "poster6.jpg"
            ),
            TMDBMovie(
                id: 7,
                title: "Movie 7", 
                overview: "A sci-fi adventure",
                originalLanguage: "English",
                releaseDate: "2023-07-01", 
                genreIds: [9],
                posterPath: "poster7.jpg"
            ),
            TMDBMovie(
                id: 8,
                title: "Movie 8", 
                overview: "A family animation",
                originalLanguage: "English",
                releaseDate: "2023-08-01", 
                genreIds: [9],
                posterPath: "poster8.jpg"
            ),
            TMDBMovie(
                id: 9,
                title: "Movie 9", 
                overview: "A classic drama",
                originalLanguage: "English",
                releaseDate: "2023-09-01", 
                genreIds: [3],
                posterPath: "poster9.jpg"
            ),
            TMDBMovie(
                id: 10,
                title: "Movie 10", 
                overview: "A horror thriller",
                originalLanguage: "English",
                releaseDate: "2023-10-01", 
                genreIds: [1, 10],
                posterPath: "poster10.jpg"
            )
        ]

        self.cachedMovies = movies
        
        return movies
    }
}
