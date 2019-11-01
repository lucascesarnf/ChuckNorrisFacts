//
//  SearchBar.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 28/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import SwiftUI

struct SearchBar: View {
    @State private var showSearch = false
    @State var text = ""
    var body: some View {
       HStack {
            Text("CHUCK NORRIS FACTS")
                .foregroundColor(.white)
                .fontWeight(.bold)
            Spacer()
            searchBarButton
        }
        .padding()
        .background(Color.gray)
    }

    var searchBarButton: some View {
        Button(action: {
            self.showSearch = true
        }, label: {
            Image("search")
                .resizable()
                .frame(width: 30, height: 30, alignment: .center)
                .foregroundColor(.white)
        }).sheet(isPresented: $showSearch, onDismiss: {
            self.showSearch = false
        }, content: {
            SearchFactView(searchText: self.$text)
        })
    }
}

#if DEBUG
struct SearchBar_Previews: PreviewProvider {
    @State static var shouldShowSearchScreen = false
    static var previews: some View {
        SearchBar()
    }
}
#endif
