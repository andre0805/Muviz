//
//  DRUMRE LAB1
//  HomeView.swift
//
//  Andre Flego
//

import SwiftUI
import Combine

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel

    init(_ viewModel: @escaping () -> HomeViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Logged in as: \(viewModel.output.user.email)")
                .bold()

            Button {
                viewModel.input.logoutButtonTapped.send()
            } label: {
                Text("Logout")
                    .bold()
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .foregroundStyle(.white)
                    .background(Color(red: 8/255, green: 102/255, blue: 255/255))
                    .clipShape(Capsule())
            }

            Button {
                viewModel.input.updateUserButtonTapped.send()
            } label: {
                Text("Update user")
                    .bold()
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .foregroundStyle(.white)
                    .background(Color(red: 8/255, green: 102/255, blue: 255/255))
                    .clipShape(Capsule())
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
        HomeView {
            HomeViewModel(
                homeRepository: HomeRepository(
                    sessionManager: .shared,
                    database: .shared
                )
            )
        }
    }
}

