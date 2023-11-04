//
//  DRUMRE LAB1
//  SearchMoviesViewModel.swift
//
//  Andre Flego
//

import SwiftUI
import Combine

class SearchMoviesViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()

    var movies: [Movie] = []

    private let searchRouter: SearchRouter
    private let searchMoviesRepository: SearchMoviesRepositoryProtocol
    private let sessionManager: SessionManager

    let input = Input()
    @Published private(set) var output: Output

    init(
        searchRouter: SearchRouter,
        searchMoviesRepository: SearchMoviesRepositoryProtocol,
        sessionManager: SessionManager
    ) {
        self.searchRouter = searchRouter
        self.searchMoviesRepository = searchMoviesRepository
        self.sessionManager = sessionManager

        self.output = Output(user: sessionManager.currentUser ?? .mock)

        bindInput()
    }
}

// MARK: Input & Output
extension SearchMoviesViewModel {
    struct Input {
        let userButtonTapped = PassthroughSubject<Void, Never>()
        let searchInput = PassthroughSubject<String, Never>()
        let movieTapped = PassthroughSubject<Movie, Never>()
    }

    struct Output {
        let title: String = "Search"
        let user: User
        var movies: [Movie] = []
        var isLoading = false
        var noMoviesFound = false
    }
}

// MARK: Bind Input
private extension SearchMoviesViewModel {
    func bindInput() {
        bindUserButtonTapped()
        bindSearchInput()
        bindMovieTapped()
    }

    func bindUserButtonTapped() {
        input.userButtonTapped
            .sink { [unowned self] _ in
                searchRouter.present(.userInfo)
            }
            .store(in: &cancellables)
    }

    func bindSearchInput() {
        input.searchInput
            .debounce(for: .seconds(0.5), scheduler: DispatchQueueFactory.main)
            .handleEvents(receiveOutput: { [unowned self] search in
                withAnimation {
                    output.isLoading = true
                    output.movies.removeAll()
                    output.noMoviesFound = false
                }
            })
            .receive(on: DispatchQueueFactory.networking)
            .flatMap { [unowned self] searchQuery -> AnyPublisher<[Movie], Never> in
                return searchMovies(searchQuery)
            }
            .receive(on: DispatchQueueFactory.main)
            .sink { [unowned self] movies in
                self.movies = movies
                withAnimation {
                    output.isLoading = false
                    output.movies = movies
                    output.noMoviesFound = movies.isEmpty
                }
            }
            .store(in: &cancellables)
    }

    func bindMovieTapped() {
        input.movieTapped
            .sink { [unowned self] movie in
                searchRouter.push(to: .movieDetails(movie))
            }
            .store(in: &cancellables)
    }
}

// MARK: Functions
private extension SearchMoviesViewModel {
    func searchMovies(_ searchQuery: String) -> AnyPublisher<[Movie], Never> {
        Future { [unowned self] promise in
            Task {
                do {
                    let movies: [Movie] = try await searchMoviesRepository.searchMovies(searchQuery)
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
