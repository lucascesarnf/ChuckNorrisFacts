//
//  SearchFactView.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 28/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import SwiftUI

struct SearchFactView: View {
    // MARK: - @Combine
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var queryType: PerformQuery
    @State private var searchText = ""

    // MARK: - Variables/Constants
    private let viewModel = SearchFactViewModel()

    // MARK: - Views
    var body: some View {
        VStack {
            TextField("Enter your search term", text: $searchText, onCommit: {
                self.queryType = .query(self.searchText)
                self.viewModel.saveSearchTerm(self.searchText)
                self.presentationMode.wrappedValue.dismiss()
            })
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(Color("Search"))
            Spacer()
            .frame(height: 5)
            if viewModel.haveCategories() {
                categories
            }
            Spacer()
            .frame(height: 20)
            pastSearches
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
        VStack(alignment: .leading) {
            Text("Suggestions")
            .fontWeight(.bold)
            .font(.system(size: 22))
            .padding(7)
            ForEach(viewModel.categoriesGrid, id: \.self) { categories in
                HStack {
                    ForEach(categories, id: \.self) { category in
                        Button(action: {
                            self.queryType = .query(category)
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                        Text(category.uppercased())
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(5)
                            .background(Color("Category"))
                        })
                        .cornerRadius(5)
                        .padding(3)
                    }
                }.padding(.leading, 20)
            }
        }.frame(minWidth: 50, maxWidth: .infinity, alignment: .topLeading)
    }

    var pastSearches: some View {
        VStack(alignment: .leading) {
            if !viewModel.pastSearches.isEmpty {
                Text("Past Searches")
                    .fontWeight(.bold)
                    .font(.system(size: 22))
                    .padding(7)
            }
            Spacer()
                .frame(height: 5)
            Group {
                ForEach(viewModel.pastSearches, id: \.self) { term in
                    Button(action: {
                        self.queryType = .query(term)
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text(term)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(5)
                            .background(Color("Category"))
                    })
                        .cornerRadius(5)
                        .padding(3)
                }
                .padding(.leading, 20)
            }
        }.frame(minWidth: 50, maxWidth: .infinity, minHeight: 20, maxHeight: .infinity, alignment: .topLeading)
    }
}

#if DEBUG
struct SearchFactView_Previews: PreviewProvider {
    @State static var query = PerformQuery.none
    static var previews: some View {
        SearchFactView(queryType: $query)
    }
}
#endif
