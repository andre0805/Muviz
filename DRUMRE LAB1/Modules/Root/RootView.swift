//
//  RootView.swift
//  DRUMRE LAB1
//
//  Created by Andre Flego on 07.10.2023..
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
            Text(viewModel.output.title)
        }
        .onAppear {
            viewModel.input.viewDidAppear.send()
        }
    }
}

struct RootPreviews: PreviewProvider {
    static var previews: some View {
        RootView {
            RootViewModel()
        }
    }
}

