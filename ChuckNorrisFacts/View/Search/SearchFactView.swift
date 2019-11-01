//
//  SearchFactView.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 28/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import SwiftUI

struct SearchFactView: View {
    @Binding var searchText: String
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    private let searchModel = SearchViewModel()

    var body: some View {
        VStack {
            TextField("Enter your search term", text: $searchText)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(Color.gray)
            Spacer()
            if searchModel.theareCategories() {
                categories
                .padding()
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }

    var categories: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(searchModel.categoriesGrid, id: \.self) { categories in
                HStack {
                    ForEach(categories, id: \.self) { category in
                        Button(action: {
                            print(category)
                           self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                        Text(category.uppercased())
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(5)
                            .background(Color.blue)
                        })
                    }
                }.padding(3)
            }
        }
    }
}

#if DEBUG
struct SearchFactView_Previews: PreviewProvider {
    @State static var text = ""
    static var previews: some View {
        SearchFactView(searchText: $text)
    }
}
#endif
