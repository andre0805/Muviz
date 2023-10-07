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
        Button {
            print("🔥 login")
        } label: {
            Text("Login")
        }
    }

    var homeView: some View {
        Text("Home")
    }
}

struct RootPreviews: PreviewProvider {
    static var previews: some View {
        RootView {
            RootViewModel()
        }
    }
}

