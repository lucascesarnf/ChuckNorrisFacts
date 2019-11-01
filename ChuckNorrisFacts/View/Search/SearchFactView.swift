//
//  SearchFactView.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 28/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import SwiftUI

struct SearchFactView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var queryType: QueryType
    @State var searchText = ""
    private let searchModel = SearchViewModel()

    var body: some View {
        VStack {
            TextField("Enter your search term", text: $searchText, onCommit: {
                self.queryType = .query(self.searchText)
                self.presentationMode.wrappedValue.dismiss()
            })
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(Color("Search"))
            Spacer()
            if searchModel.theareCategories() {
                categories
                .padding()
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .onAppear(perform: {
            self.queryType = .none
        })
        .onDisappear(perform: {
             self.queryType = .none
        })
    }

    var categories: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(searchModel.categoriesGrid, id: \.self) { categories in
                HStack {
                    ForEach(categories, id: \.self) { category in
                        Button(action: {
                            self.queryType = .category(category)
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                        Text(category.uppercased())
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(5)
                            .background(Color("Category"))
                        })
                        .cornerRadius(5)
                    }
                }.padding(3)
            }
        }
    }
}

#if DEBUG
struct SearchFactView_Previews: PreviewProvider {
    @State static var query = QueryType.none
    static var previews: some View {
        SearchFactView(queryType: $query)
    }
}
#endif
