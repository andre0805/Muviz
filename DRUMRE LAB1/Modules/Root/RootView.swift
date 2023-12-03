//
//  RootView.swift
//  DRUMRE LAB1
//
//  Andre Flego
//

import SwiftUI
import Combine
import FacebookLogin

struct RootView: View {
    @StateObject private var viewModel: RootViewModel

    @EnvironmentObject var moviesApi: MoviesAPI
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var fbLoginManager: FBLoginManager

    init(_ viewModel: @escaping () -> RootViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        Group {
            switch viewModel.output.state {
            case .loading:
                loadingView
                    .transition(.opacity)
            case .authRequired:
                loginView
                    .transition(.opacity)
            case .home:
                homeView
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
        .onAppear {
            viewModel.input.viewDidAppear.send()
        }
    }
}

// MARK: Views
private extension RootView {
    var loadingView: some View {
        ZStack {
            Color.backgroundColor
                .ignoresSafeArea()

            ProgressView()
                .scaleEffect(1.5)
                .tint(.white)
        }
    }
    var loginView: some View {
        NavigationStack {
            LoginView {
                LoginViewModel(
                    sessionManager: sessionManager,
                    loginRepository: LoginRepository(
                        fbLoginManager: fbLoginManager,
                        moviesApi: moviesApi
                    )
                )
            }
        }
    }

    var homeView: some View {
        HomeView()
            .environmentObject(sessionManager)
            .environmentObject(moviesApi)
    }
}

#Preview {
    RootView {
        RootViewModel(
            moviesApi: MoviesAPIMock(),
            sessionManager: .shared,
            fbLoginManager: .shared
        )
    }
    .environmentObject(MoviesAPI.shared)
    .environmentObject(SessionManager.shared)
    .environmentObject(FBLoginManager.shared)
}

