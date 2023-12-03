//
//  DRUMRE LAB1
//  MoviesViewModel.swift
//
//  Andre Flego
//

import Combine
import SwiftUI

class MoviesViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()

    private let moviesRouter: MoviesRouter
    private let moviesRepository: MoviesRepositoryProtocol
    private let sessionManager: SessionManager

    var genres: [Genre] = []
    var movies: [Movie] = []

    let input = Input()
    @Published private(set) var output: Output

    init(
        moviesRouter: MoviesRouter,
        moviesRepository: MoviesRepositoryProtocol,
        sessionManager: SessionManager
    ) {
        self.moviesRouter = moviesRouter
        self.moviesRepository = moviesRepository
        self.sessionManager = sessionManager

        self.output = Output(user: sessionManager.currentUser ?? .mock)

        bindInput()
    }
}

// MARK: Input & Output
extension MoviesViewModel {
    struct Input {
        let viewDidAppear = PassthroughSubject<Void, Never>()
        let userButtonTapped = PassthroughSubject<Void, Never>()
        let selectGenreTapped = PassthroughSubject<Genre?, Never>()
        let movieTapped = PassthroughSubject<Movie, Never>()
        let loadMoreMovies = PassthroughSubject<Void, Never>()
    }

    struct Output {
        let title: String = "Movies"
        let user: User
        var movies: [Movie] = []
        var genres: [Genre] = []
        var selectedGenre: Genre?
        var isLoading = false
    }
}

// MARK: Bind Input
private extension MoviesViewModel {
    func bindInput() {
        bindViewDidAppear()
        bindUserButtonTapped()
        bindSelectGenreTapped()
        bindMovieTapped()
        bindLoadMoreMovies()
    }

    func bindViewDidAppear() {
        input.viewDidAppear
            .prefix(1)
            .handleEvents(receiveOutput: { [unowned self] _ in
                output.isLoading = true
            })
            .receive(on: DispatchQueueFactory.background)
            .flatMap { [unowned self] _ in
                fetchGenres()
            }
            .handleEvents(receiveOutput: { [unowned self] genres in
                self.genres = genres
            })
            .flatMap { [unowned self] _ in
                fetchMovies()
            }
            .handleEvents(receiveOutput: { [unowned self] movies in
                self.movies = movies
            })
            .receive(on: DispatchQueueFactory.main)
            .sink { [unowned self] _ in
                withAnimation {
                    output.isLoading = false
                    output.genres = genres
                    output.movies = movies
                }
            }
            .store(in: &cancellables)
    }

    func bindUserButtonTapped() {
        input.userButtonTapped
            .sink { [unowned self] _ in
                moviesRouter.present(.userInfo)
            }
            .store(in: &cancellables)
    }

    func bindSelectGenreTapped() {
        input.selectGenreTapped
            .sink { [unowned self] genre in
                withAnimation {
                    output.selectedGenre = genre
                    if let genre {
                        output.movies = movies.filter { $0.genres.contains(genre) }
                    } else {
                        output.movies = movies
                    }
                }
            }
            .store(in: &cancellables)
    }

    func bindMovieTapped() {
        input.movieTapped
            .sink { [unowned self] movie in
                moviesRouter.push(to: .movieDetails(movie))
            }
            .store(in: &cancellables)
    }

    func bindLoadMoreMovies() {
        input.loadMoreMovies
            .debounce(for: .seconds(0.5), scheduler: DispatchQueueFactory.main)
            .handleEvents(receiveOutput: { [unowned self] _ in
                withAnimation {
                    output.isLoading = true
                }
            })
            .receive(on: DispatchQueueFactory.background)
            .flatMap { [unowned self] _ in
                fetchMovies()
            }
            .delay(for: 1, scheduler: DispatchQueueFactory.main)
            .receive(on: DispatchQueueFactory.main)
            .sink { [unowned self] movies in
                withAnimation {
                    self.movies.append(contentsOf: movies)

                    if let selectedGenre = output.selectedGenre {
                        let filteredMovies = movies.filter { $0.genres.contains(selectedGenre) }
                        output.movies.append(contentsOf: filteredMovies)
                    } else {
                        output.movies.append(contentsOf: movies)
                    }

                    output.isLoading = false
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: Functions
private extension MoviesViewModel {
    func fetchGenres() -> AnyPublisher<[Genre], Never> {
        Future<[Genre], Never> { [unowned self] promise in
            Task {
                do {
                    let genres = try await moviesRepository.getGenres()
                    promise(.success(genres))
                } catch {
                    log.error(error.localizedDescription)
                    promise(.success([]))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func fetchMovies() -> AnyPublisher<[Movie], Never> {
        Future<[Movie], Never> { [unowned self] promise in
            Task {
                do {
                    let movies = try await moviesRepository.getMovies(lastTitle: movies.last?.title)
                    promise(.success(movies))
                } catch {
                    log.error(error)
                    promise(.success([]))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
