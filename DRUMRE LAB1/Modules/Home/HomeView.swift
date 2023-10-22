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
        }
        .navigationTitle(viewModel.output.title)
        .toolbar {
            toolbarView
        }
        .onAppear {
            viewModel.input.viewDidAppear.send()
        }
    }
}

// MARK: Views
private extension HomeView {
    var toolbarView: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                viewModel.input.userButtonTapped.send()
            } label: {
                let imageUrl = URL(string: viewModel.output.user?.imageUrl ?? "")
                AsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .frame(width: 32, height: 32)
                } placeholder: {
                    let initials = viewModel.output.user?.name
                        .split(separator: " ")
                        .compactMap { $0.first}
                        .map { String($0) }
                        .joined()

                    Text(initials ?? "ME")
                        .font(.system(size: 16))
                        .padding(8)
                        .foregroundStyle(.white)
                        .background(.blue)
                }
                .clipShape(Circle())
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView {
            HomeViewModel(
                router: HomeRouter(),
                homeRepository: HomeRepository(
                    sessionManager: .shared,
                    database: .shared
                )
            )
        }
    }
}

