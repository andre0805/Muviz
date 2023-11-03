//
//  DRUMRE LAB1
//  HomeViewModel.swift
//
//  Andre Flego
//

import Foundation
import Combine
import UIKit
import SwiftUI

class HomeViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()

    private let homeRouter: HomeRouter
    private let homeRepository: HomeRepositoryProtocol

    var genres: [Genre] = []
    var movies: [Movie] = []

    let input = Input()
    @Published private(set) var output: Output

    init(
        router: HomeRouter,
        homeRepository: HomeRepositoryProtocol
    ) {
        self.homeRouter = router
        self.homeRepository = homeRepository
        self.output = Output(user: homeRepository.sessionManager.currentUser)
        bindInput()
    }
}

// MARK: Input & Output
extension HomeViewModel {
    struct Input {
        let viewDidAppear = PassthroughSubject<Void, Never>()
        let userButtonTapped = PassthroughSubject<Void, Never>()
        let logoutButtonTapped = PassthroughSubject<Void, Never>()
        let selectGenreTapped = PassthroughSubject<Genre?, Never>()
        let movieTapped = PassthroughSubject<Movie, Never>()
    }

    struct Output {
        let title: String = "Home"
        let user: User?
        var movies: [Movie] = []
        var genres: [Genre] = []
        var selectedGenre: Genre?
        var isLoading = false
    }
}

// MARK: Bind Input
private extension HomeViewModel {
    func bindInput() {
        bindViewDidAppear()
        bindUserButtonTapped()
        bindLogoutButtonTapped()
        bindSelectGenreTapped()
        bindMovieTapped()
    }

    func bindViewDidAppear() {
        input.viewDidAppear
            .prefix(1)
            .handleEvents(receiveOutput: { [unowned self] _ in
                withAnimation {
                    output.isLoading = true
                }
            })
            .receive(on: DispatchQueueFactory.background)
            .flatMap { [unowned self] _ in
                return fetchGenres()
            }
            .receive(on: DispatchQueueFactory.background)
            .flatMap { [unowned self] _ in
                return fetchMovies()
            }
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
                guard let user = output.user else { return }
                homeRouter.present(.userInfo(user))
//                getJson()
            }
            .store(in: &cancellables)
    }

    func bindLogoutButtonTapped() {
        input.logoutButtonTapped
            .sink { [unowned self] _ in
                homeRepository.logout()
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
                homeRouter.push(to: .movieDetails(movie))
            }
            .store(in: &cancellables)
    }
}

// MARK: Functions
private extension HomeViewModel {
    func fetchGenres() -> AnyPublisher<Void, Never> {
        Future<[Genre], Never> { [unowned self] promise in
            Task {
                do {
                    let genres = try await homeRepository.getGenres()
                    promise(.success(genres))
                } catch {
                    log.error(error.localizedDescription)
                    promise(.success([]))
                }
            }
        }
        .handleEvents(receiveOutput: { [unowned self] genres in
            self.genres = genres
        })
        .map { _ in () }
        .eraseToAnyPublisher()
    }

    func fetchMovies() -> AnyPublisher<Void, Never> {
        Future<[Movie], Never> { [unowned self] promise in
            Task {
                do {
                    var movies: [Movie] = []
                    for page in 1...20 {
                        let newMovies = try await homeRepository.getMovies(page: page)
                        movies.append(contentsOf: newMovies)
                    }
                    movies.removeDuplicates()
                    promise(.success(movies))
                } catch {
                    log.error(error)
                    promise(.success([]))
                }
            }
        }
        .handleEvents(receiveOutput: { [unowned self] movies in
            self.movies = movies
        })
        .map { _ in () }
        .eraseToAnyPublisher()
    }
}
