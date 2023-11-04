//
//  DRUMRE LAB1
//  OMDBMock.swift
//
//  Andre Flego
//

import Foundation

class OMDBMock: OMDBProtocol {
    func searchMovies(_ searchQuery: String) async throws -> [OMDBMovieDetails] {
        [
            OMDBMovieDetails(
                id: "1",
                title: "Inception",
                plot: "A thief who enters the dreams of others to steal their secrets.",
                language: "English",
                year: "2010",
                poster: "inception_poster.jpg",
                genre: "Science Fiction"
            ),
            OMDBMovieDetails(
                id: "2",
                title: "The Shawshank Redemption",
                plot: "Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.",
                language: "English",
                year: "1994",
                poster: "shawshank_redemption_poster.jpg",
                genre: "Drama"
            ),
            OMDBMovieDetails(
                id: "3",
                title: "The Godfather",
                plot: "The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.",
                language: "English",
                year: "1972",
                poster: "godfather_poster.jpg",
                genre: "Crime"
            ),
            OMDBMovieDetails(
                id: "4",
                title: "Pulp Fiction",
                plot: "The lives of two mob hitmen, a boxer, a gangster and his wife, and a pair of diner bandits intertwine.",
                language: "English",
                year: "1994",
                poster: "pulp_fiction_poster.jpg",
                genre: "Crime"
            ),
            OMDBMovieDetails(
                id: "5",
                title: "The Dark Knight",
                plot: "When the menace known as The Joker emerges, Batman must confront his own demons while protecting Gotham City from destruction.",
                language: "English",
                year: "2008",
                poster: "dark_knight_poster.jpg",
                genre: "Action"
            ),
            OMDBMovieDetails(
                id: "6",
                title: "Schindler's List",
                plot: "In German-occupied Poland during World War II, industrialist Oskar Schindler gradually becomes concerned for his Jewish workforce after witnessing their persecution by the Nazis.",
                language: "English",
                year: "1993",
                poster: "schindlers_list_poster.jpg",
                genre: "Biography"
            ),
            OMDBMovieDetails(
                id: "7",
                title: "Forrest Gump",
                plot: "The presidencies of Kennedy and Johnson, the events of Vietnam, Watergate, and other history unfold through the perspective of an Alabama man with an IQ of 75.",
                language: "English",
                year: "1994",
                poster: "forrest_gump_poster.jpg",
                genre: "Drama"
            ),
            OMDBMovieDetails(
                id: "8",
                title: "The Matrix",
                plot: "A computer programmer discovers that reality as he knows it is a simulation created by machines to subjugate humanity.",
                language: "English",
                year: "1999",
                poster: "matrix_poster.jpg",
                genre: "Action"
            ),
            OMDBMovieDetails(
                id: "9",
                title: "Goodfellas",
                plot: "The story of Henry Hill and his life in the mob, covering his relationship with his wife Karen Hill and his mob partners Jimmy Conway and Tommy DeVito in the Italian-American crime syndicate.",
                language: "English",
                year: "1990",
                poster: "goodfellas_poster.jpg",
                genre: "Crime"
            ),
            OMDBMovieDetails(
                id: "10",
                title: "Gladiator",
                plot: "A former Roman General sets out to exact vengeance against the corrupt emperor who murdered his family and sent him into slavery.",
                language: "English",
                year: "2000",
                poster: "gladiator_poster.jpg",
                genre: "Action"
            )
        ]

    }
}
