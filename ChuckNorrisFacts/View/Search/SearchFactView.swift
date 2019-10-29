//
//  SearchFactView.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 28/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import SwiftUI

struct SearchFactView: View {
    var searchModel: SearchViewModel
    @Binding var isNavigationBarHidden: Bool
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello World!"/*@END_MENU_TOKEN@*/)
        .navigationBarHidden(false)
        .onAppear {
            self.isNavigationBarHidden = false
        }
    }
}

#if DEBUG
struct SearchFactView_Previews: PreviewProvider {
    @State static var isNavigationBarHidden = true
    static var previews: some View {
        SearchFactView(searchModel: SearchViewModel(), isNavigationBarHidden: $isNavigationBarHidden)
    }
}
#endif
