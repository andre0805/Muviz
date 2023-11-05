//
//  RootView.swift
//  DRUMRE LAB1
//
//  Andre Flego
//

import SwiftUI
import Combine

struct RootView: View {
    @StateObject private var viewModel: RootViewModel

    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var database: Database

    init(_ viewModel: @escaping () -> RootViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        Group {
            switch viewModel.output.state {
            case .loading:
                loadingView
            case .authRequired:
                loginView
            case .home:
                homeView
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
                .tint(Color.blackPrimary)
        }
    }
    var loginView: some View {
        NavigationStack {
            LoginView {
                LoginViewModel(
                    loginRepository: LoginRepository(
                        sessionManager: sessionManager,
                        database: database
                    )
                )
            }
        }
    }

    var homeView: some View {
        HomeView {
            HomeViewModel()
        }
    }
}

#Preview {
    RootView {
        RootViewModel(sessionManager: .shared, database: .shared)
    }
    .environmentObject(SessionManager.shared)
    .environmentObject(Database.shared)
}

