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
        VStack {
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
                .foregroundStyle(.white)
                .background(Color(red: 8/255, green: 102/255, blue: 255/255))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .navigationTitle(viewModel.output.title)
        .onAppear {
            viewModel.input.viewDidAppear.send()
        }
    }
}

#Preview {
    NavigationStack {
        LoginView {
            LoginViewModel(sessionManager: .shared)
        }
    }
}

