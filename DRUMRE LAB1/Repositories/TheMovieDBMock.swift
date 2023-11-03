//
//  DRUMRE LAB1
//  TheMovieDBMock.swift
//
//  Andre Flego
//

import Foundation

class TheMovieDBMock: TheMovieDBProtocol {
    private(set) var cachedGenres: [TheMovieDB.Genre] = []
    private(set) var cachedMovies: [TheMovieDB.Movie] = []

    func getGenres() async throws -> [TheMovieDB.Genre] {
        let genres = [
            TheMovieDB.Genre(id: 1, name: "Action"),
            TheMovieDB.Genre(id: 2, name: "Comedy"),
            TheMovieDB.Genre(id: 3, name: "Drama"),
            TheMovieDB.Genre(id: 4, name: "Crimi"),
            TheMovieDB.Genre(id: 5, name: "Science Fiction and Fantasy"),
            TheMovieDB.Genre(id: 6, name: "Romance"),
            TheMovieDB.Genre(id: 7, name: "Mystery"),
            TheMovieDB.Genre(id: 8, name: "Documentary"),
            TheMovieDB.Genre(id: 9, name: "Animation"),
            TheMovieDB.Genre(id: 10, name: "Horror"),
        ]

        self.cachedGenres = genres
        
        return genres
    }

    func getMovies(page: Int = 1) async throws -> [TheMovieDB.Movie] {
        let movies = [
            TheMovieDB.Movie(
                id: 1,
                title: "Movie 1",
                overview: "An exciting movie",
                originalLanguage: "English",
                releaseDate: "2023-01-01",
                genreIds: [1],
                posterPath: "poster1.jpg"
            ),
            
            TheMovieDB.Movie(
                id: 2,
                title: "Movie 2", 
                overview: "A funny comedy",
                originalLanguage: "English",
                releaseDate: "2023-02-01", 
                genreIds: [2, 6],
                posterPath: "poster2.jpg"
            ),
            TheMovieDB.Movie(
                id: 3,
                title: "Movie 3", 
                overview: "A dramatic story",
                originalLanguage: "Spanish",
                releaseDate: "2023-03-01", 
                genreIds: [3, 7],
                posterPath: "poster3.jpg"
            ),
            TheMovieDB.Movie(
                id: 4,
                title: "Movie 4", 
                overview: "An action-packed adventure",
                originalLanguage: "English",
                releaseDate: "2023-04-01", 
                genreIds: [1, 4],
                posterPath: "poster4.jpg"
            ),
            TheMovieDB.Movie(
                id: 5,
                title: "Movie 5", 
                overview: "A romantic tale",
                originalLanguage: "French",
                releaseDate: "2023-05-01", 
                genreIds: [6],
                posterPath: "poster5.jpg"
            ),
            TheMovieDB.Movie(
                id: 6,
                title: "Movie 6", 
                overview: "A thrilling mystery",
                originalLanguage: "English",
                releaseDate: "2023-06-01", 
                genreIds: [7],
                posterPath: "poster6.jpg"
            ),
            TheMovieDB.Movie(
                id: 7,
                title: "Movie 7", 
                overview: "A sci-fi adventure",
                originalLanguage: "English",
                releaseDate: "2023-07-01", 
                genreIds: [9],
                posterPath: "poster7.jpg"
            ),
            TheMovieDB.Movie(
                id: 8,
                title: "Movie 8", 
                overview: "A family animation",
                originalLanguage: "English",
                releaseDate: "2023-08-01", 
                genreIds: [9],
                posterPath: "poster8.jpg"
            ),
            TheMovieDB.Movie(
                id: 9,
                title: "Movie 9", 
                overview: "A classic drama",
                originalLanguage: "English",
                releaseDate: "2023-09-01", 
                genreIds: [3],
                posterPath: "poster9.jpg"
            ),
            TheMovieDB.Movie(
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
