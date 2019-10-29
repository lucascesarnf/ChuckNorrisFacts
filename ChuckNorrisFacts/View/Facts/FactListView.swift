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
    @ObservedObject var model = FactListViewModel()
    @ObservedObject var searchModel = SearchViewModel()
    @State var isNavigationBarHidden: Bool = true
    @State private var shouldShowSearchScreen = false
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: SearchFactView(searchModel: searchModel, isNavigationBarHidden:
                    $isNavigationBarHidden), isActive: $shouldShowSearchScreen) {
                        SearchBar(shouldShowSearchScreen: $shouldShowSearchScreen)
                }
                .navigationBarTitle("")
                .navigationBarHidden(isNavigationBarHidden)
                .onAppear {
                    self.isNavigationBarHidden = true
                }
                
                List(model.facts) { model in
                    FactRow(model: model)
                }
            }
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
