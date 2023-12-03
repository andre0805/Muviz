//
//  DRUMRE LAB1
//  LoginView.swift
//
//  Andre Flego
//

import SwiftUI
import Combine

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel

    init(_ viewModel: @escaping () -> LoginViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        ZStack {
            Color.backgroundColor
                .ignoresSafeArea()
            
            VStack {
                if viewModel.output.isLoading {
                    loadingIndicator
                } else {
                    loginButton
                }
            }
        }
        .alert(
            "Oops! Something went wrong...",
            isPresented: $viewModel.output.isAlertPresented,
            actions: { Button("OK", role: .cancel, action: { }) },
            message: { Text(viewModel.output.errorMessage ?? "") }
        )
        .navigationTitle(viewModel.output.title)
        .onAppear {
            viewModel.input.viewDidAppear.send()
        }
    }
}

// MARK: Views
private extension LoginView {
    var loadingIndicator: some View {
        ProgressView()
            .scaleEffect(1.5)
            .tint(.white)
            .transition(.opacity.combined(with: .scale))
    }
    var loginButton: some View {
        Button {
            viewModel.input.loginButtonTapped.send()
        } label: {
            HStack(spacing: 16) {
                Image(.facebookLogo)

                Text("Login with Facebook")
                    .bold()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .foregroundStyle(Color.whitePrimary)
            .background(Color.fbButtonBackground)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: Color.fbButtonShadow, radius: 4, y: 2)
            .transition(.opacity.combined(with: .scale))
        }
    }
}

#Preview {
    NavigationStack {
        LoginView {
            LoginViewModel(
                sessionManager: .shared,
                loginRepository: LoginRepository(
                    fbLoginManager: .shared,
                    moviesApi: MoviesAPIMock()
                )
            )
        }
    }
}
