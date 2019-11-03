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
    @Binding var queryType: QueryType
    @Binding var enableSearchButton: Bool

    var body: some View {
       HStack {
            Text("CHUCK NORRIS FACTS")
                .foregroundColor(.white)
                .fontWeight(.bold)
                .background(Color("Search"))
            Spacer()
            searchBarButton
        }
       .padding()
       .background(Color("Search"))
    }

    var searchBarButton: some View {
        Button(action: {
            self.showSearch = true
        }, label: {
            Image("search")
                .resizable()
                .frame(width: 30, height: 30, alignment: .center)
                .foregroundColor(.white)
        })
        .disabled(!enableSearchButton)
            .sheet(isPresented: $showSearch, onDismiss: {
            self.showSearch = false
        }, content: {
            SearchFactView(queryType: self.$queryType)
        })
    }
}

#if DEBUG
struct SearchBar_Previews: PreviewProvider {
    @State static var queryType = QueryType.none
    @State static var enableSearchButton = true
    static var previews: some View {
        SearchBar(queryType: $queryType, enableSearchButton: $enableSearchButton)
    }
}
#endif
