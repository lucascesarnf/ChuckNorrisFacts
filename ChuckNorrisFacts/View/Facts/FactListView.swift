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
    @State private var queryType = QueryType.none

    // MARK: - @Views
    var body: some View {
        VStack(spacing: 0) {
            SearchBar(queryType: $queryType)
            if viewModel.didError {
                errorToast
            }
            containedView()
        }
    }

    var errorToast: some View {
        Text(self.viewModel.error.errorDescription†)
            .transition(.opacity)
            .animation(.easeIn)
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
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
    }

    var loading: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                VStack {
                    Text("Loading...")
                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                }
                .frame(width: geometry.size.width / 2,
                       height: geometry.size.height / 5)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(20)
            }
        }
    }

    // MARK: - @Funcitons
    func containedView() -> AnyView {
        query()
        switch viewModel.currentState {
        case .facts:
            return AnyView(factsList)
        case .noFacts:
            return  AnyView(noFacts)
        case .load:
            return AnyView(loading)
        }
    }

    func query() {
        viewModel.performQuery(queryType)
    }
}

#if DEBUG
struct FactListView_Previews: PreviewProvider {
    static var previews: some View {
        FactListView()
    }
}
#endif
