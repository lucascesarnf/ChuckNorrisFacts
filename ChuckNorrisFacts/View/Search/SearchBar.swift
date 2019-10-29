//
//  SearchBar.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 28/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import SwiftUI

struct SearchBar: View {
    @Binding var shouldShowSearchScreen: Bool

    var body: some View {
       HStack {
            Text("CHUCK NORRIS FACTS")
                .foregroundColor(.white)
                .fontWeight(.bold)
            Spacer()
            Button(action: {
                self.shouldShowSearchScreen = true
            }, label: {
                Image("search")
                    .resizable()
                    .frame(width: 30, height: 30, alignment: .center)
                    .foregroundColor(.white)
            })
        }
        .padding()
        .background(Color.gray)
    }
}

#if DEBUG
struct SearchBar_Previews: PreviewProvider {
    @State static var shouldShowSearchScreen = false
    static var previews: some View {
        SearchBar(shouldShowSearchScreen: $shouldShowSearchScreen)
    }
}
#endif
