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
        let movies: [TMDBMovie] = [
            TMDBMovie(
                id: 1,
                title: "Inception",
                overview: "A thief who enters the dreams of others to steal their secrets.",
                originalLanguage: "English",
                releaseDate: "2010-07-16",
                genreIds: [1, 5],
                posterPath: "inception_poster.jpg"
            ),
            TMDBMovie(
                id: 2,
                title: "The Shawshank Redemption",
                overview: "Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.",
                originalLanguage: "English",
                releaseDate: "1994-09-10",
                genreIds: [3, 4],
                posterPath: "shawshank_redemption_poster.jpg"
            ),
            TMDBMovie(
                id: 3,
                title: "The Godfather",
                overview: "The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.",
                originalLanguage: "English",
                releaseDate: "1972-03-14",
                genreIds: [3, 4],
                posterPath: "godfather_poster.jpg"
            ),
            TMDBMovie(
                id: 4,
                title: "Pulp Fiction",
                overview: "The lives of two mob hitmen, a boxer, a gangster and his wife, and a pair of diner bandits intertwine.",
                originalLanguage: "English",
                releaseDate: "1994-09-10",
                genreIds: [3, 7],
                posterPath: "pulp_fiction_poster.jpg"
            ),
            TMDBMovie(
                id: 5,
                title: "The Dark Knight",
                overview: "When the menace known as The Joker emerges, Batman must confront his own demons while protecting Gotham City from destruction.",
                originalLanguage: "English",
                releaseDate: "2008-07-18",
                genreIds: [1, 3, 7],
                posterPath: "dark_knight_poster.jpg"
            ),
            TMDBMovie(
                id: 6,
                title: "Schindler's List",
                overview: "In German-occupied Poland during World War II, industrialist Oskar Schindler gradually becomes concerned for his Jewish workforce after witnessing their persecution by the Nazis.",
                originalLanguage: "English",
                releaseDate: "1993-12-15",
                genreIds: [3, 8],
                posterPath: "schindlers_list_poster.jpg"
            ),
            TMDBMovie(
                id: 7,
                title: "Forrest Gump",
                overview: "The presidencies of Kennedy and Johnson, the events of Vietnam, Watergate, and other history unfold through the perspective of an Alabama man with an IQ of 75.",
                originalLanguage: "English",
                releaseDate: "1994-07-06",
                genreIds: [2, 3],
                posterPath: "forrest_gump_poster.jpg"
            ),
            TMDBMovie(
                id: 8,
                title: "The Matrix",
                overview: "A computer programmer discovers that reality as he knows it is a simulation created by machines to subjugate humanity.",
                originalLanguage: "English",
                releaseDate: "1999-03-30",
                genreIds: [1, 5],
                posterPath: "matrix_poster.jpg"
            ),
            TMDBMovie(
                id: 9,
                title: "Goodfellas",
                overview: "The story of Henry Hill and his life in the mob, covering his relationship with his wife Karen Hill and his mob partners Jimmy Conway and Tommy DeVito in the Italian-American crime syndicate.",
                originalLanguage: "English",
                releaseDate: "1990-09-12",
                genreIds: [3, 4],
                posterPath: "goodfellas_poster.jpg"
            ),
            TMDBMovie(
                id: 10,
                title: "Gladiator",
                overview: "A former Roman General sets out to exact vengeance against the corrupt emperor who murdered his family and sent him into slavery.",
                originalLanguage: "English",
                releaseDate: "2000-05-01",
                genreIds: [1, 3, 4],
                posterPath: "gladiator_poster.jpg"
            )
        ]


        self.cachedMovies = movies
        
        return movies
    }
}
