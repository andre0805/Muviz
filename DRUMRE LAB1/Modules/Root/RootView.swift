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

    init(_ viewModel: @escaping () -> RootViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        Group {
            switch viewModel.output.state {
            case .loading:
                ProgressView()
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
    var loginView: some View {
        NavigationStack {
            LoginView {
                LoginViewModel(sessionManager: sessionManager)
            }
        }
    }

    var homeView: some View {
        NavigationStack {
            HomeView {
                HomeViewModel(sessionManager: sessionManager)
            }
        }
    }
}

#Preview {
    RootView {
        RootViewModel(sessionManager: .shared)
    }
}

