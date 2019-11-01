//
//  FactListView.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 21/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import SwiftUI
import Combine

struct FactListView: View {
    // MARK: - @Combine
    @ObservedObject var viewModel = FactListViewModel()
    @State private var shouldShowSearchScreen = false
    @State private var searchText = ""

    // MARK: - @Views
    var body: some View {
        VStack {
            if viewModel.didError {
                errorToast
            }
            SearchBar()
            containedView()
        }
    }

    var errorToast: some View {
        Text(viewModel.error.errorDescription†)
            .transition(.slide)
            .font(.system(size: 20))
            .foregroundColor(.white)
            .padding()
            .background(Color.red)
    }

    var factsList: some View {
        List(viewModel.facts) { model in
            FactRow(model: model)
        }
    }

    var noFacts: some View {
        VStack {
            Text("Search and share mi facts now!")
                .fontWeight(.bold)
                .font(.system(size: 20))
            Image("alert")
                .resizable()
                .frame(width: 150, height: 150, alignment: .center)
                .foregroundColor(.white)
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
    }

    // MARK: - @Funcitons
    func containedView() -> AnyView {
        switch viewModel.currentState {
        case .facts:
            return AnyView(factsList)
        case .noFacts:
            return  AnyView(noFacts)
        }
    }
}

#if DEBUG
struct FactListView_Previews: PreviewProvider {
    static var previews: some View {
        FactListView()
    }
}
#endif
