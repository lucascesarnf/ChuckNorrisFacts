//
//  FactsListView.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 21/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit
import Combine

struct FactsListView: View {
    // MARK: - @Combine
    @ObservedObject var viewModel: FactsListViewModel
    @State private var shouldShowSearchScreen = false
    @State private var queryType = PerformQuery.none
    @State private var spin = false
    @State private var enableSearchButton = true

    // MARK: - Variables/Constants
    var navigationController: UINavigationController

    // MARK: - Views
    var body: some View {
        VStack(spacing: 0) {
            SearchBar(queryType: $queryType, enableSearchButton: $enableSearchButton)
            if viewModel.didError {
                errorToast
            }
            containedView()
        }.onAppear(perform: {
            self.navigationController.setNavigationBarHidden(true, animated: false)
        })
    }

    var errorToast: some View {
        VStack {
            Spacer()
                .frame(height: 5)
            Text(self.viewModel.error.errorDescription†)
                .transition(.opacity)
                .animation(.easeIn)
                .font(.system(size: 20))
                .foregroundColor(.white)
                .padding()
                .background(Color.red)
            Spacer()
                .frame(height: 5)
                .onAppear(perform: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        self.viewModel.setError(false)
                    }
                })
        }
    }

    var error: some View {
        VStack {
            Text(viewModel.error.errorDescription†)
                .fontWeight(.bold)
                .font(.system(size: 18))
                .padding()
            Image("error")
                .resizable()
                .frame(width: 150, height: 150, alignment: .center)
                .foregroundColor(.white)
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
    }

    var factsList: some View {
        List(content: {
            Section(content: {
               ForEach(viewModel.facts, id: \.self) { fact in
                   FactRow(model: FactViewModel(fact))
               }
            })
            Section(header: Text("Randon Past Searches").fontWeight(.bold).font(.system(size:25)).padding(),
                content: {
                 ForEach(viewModel.localFacts, id: \.self) { fact in
                     FactRow(model: FactViewModel(fact))
                     .background(Color("Local"))
                 }
            })
        })
    }

    var noFacts: some View {
        VStack(alignment: .center) {
            Image("alert")
                .resizable()
                .frame(width: 150, height: 150, alignment: .center)
                .foregroundColor(.white)
            Text("Search and share my facts now!")
            .fontWeight(.bold)
            .font(.system(size: 20))
            .accessibility(identifier: "No Facts")
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
    }

    var loading: some View {
        VStack(alignment: .center) {
            Image("refresh")
                .resizable()
                .frame(width: 70, height: 70)
                .rotationEffect(.degrees(spin ? 360 : 0))
                .animation(loaderAnimation)
                .onAppear(perform: {
                    self.spin.toggle()
                })
                .onDisappear(perform: {
                    self.spin.toggle()
                })
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            .onAppear(perform: {
                self.enableSearchButton = false
            })
        .onDisappear(perform: {
               self.enableSearchButton = true
        })
    }

    var loaderAnimation: Animation {
        Animation.linear(duration: 0.8)
            .repeatForever(autoreverses: false)
    }

    // MARK: - Funcitons
   private func containedView() -> AnyView {
        query()
        switch viewModel.currentState {
        case .facts:
            return AnyView(factsList)
        case .noFacts:
            return  AnyView(noFacts)
        case .load:
            return AnyView(loading)
        case .noCasheAndError:
            return AnyView(error)
        }
    }

   private func query() {
        viewModel.performQuery(queryType)
    }
}

#if DEBUG
struct FactListView_Previews: PreviewProvider {
    static var previews: some View {
        FactsListView(viewModel: FactsListViewModel(), navigationController: UINavigationController())
    }
}
#endif
