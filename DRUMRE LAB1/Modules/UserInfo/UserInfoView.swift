//
//  DRUMRE LAB1
//  UserInfoView.swift
//
//  Andre Flego
//

import SwiftUI
import Combine

struct UserInfoView: View {
    @StateObject private var viewModel: UserInfoViewModel

    init(_ viewModel: @escaping () -> UserInfoViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        VStack(spacing: 32) {
            profileDetails
            favoriteMovies
        }
        .padding(.top, 32)
        .toolbar {
            toolbarView
        }
        .background(Color.backgroundColor)
    }
}

// MARK: Views
private extension UserInfoView {
    var profileDetails: some View {
        VStack(spacing: 8) {
            profileImage

            VStack(spacing: 4) {
                Text(viewModel.output.user.name)
                    .font(.system(size: 28, weight: .bold))

                Text(viewModel.output.user.email)
                    .font(.system(size: 18, weight: .light))
            }
            .foregroundStyle(Color.blackPrimary)
        }
    }

    var favoriteMovies: some View {
        VStack(spacing: 8) {
            Text("Favorite movies")
                .font(.title)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)

            let movies = viewModel.output.user.favoriteMovies.sorted(by: { $0.title < $1.title })

            if movies.isEmpty {
                Spacer()

                Text("Bwoah, looks like you don't have any favorite movies 😬")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.customGray)
                    .frame(width: 300, alignment: .center)
                    .shadow(color: Color.customGray, radius: 4, y: 2)

                Spacer()
                Spacer()
            } else {
                MovieList(movies: movies) { movie in
                    viewModel.input.movieTapped.send(movie)
                }
            }
        }
    }

    var toolbarView: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                viewModel.input.logoutButtonTapped.send()
            } label: {
                Image(.logout)
            }
        }
    }

    @ViewBuilder
    var profileImage: some View {
        let imageUrl = URL(string: viewModel.output.user.imageUrl?.appending("asda") ?? "")

        AsyncImage(url: imageUrl) { image in
            image
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)

        } placeholder: {
            let initials = viewModel.output.user.name
                .split(separator: " ")
                .compactMap { $0.first}
                .map { String($0) }
                .joined()

            Text(initials)
                .font(.system(size: 32))
                .padding(8)
                .frame(width: 100, height: 100)
                .foregroundStyle(Color.whitePrimary)
                .background(Color.blackPrimary)
        }
        .clipShape(Circle())
        .shadow(color: Color.shadow, radius: 4, y: 2)
    }
}

#Preview {
    NavigationStack {
        UserInfoView {
            UserInfoViewModel(
                userInfoRouter: UserInfoRouter()
            )
        }
    }
}

