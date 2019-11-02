//
//  FactCategories.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 28/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import SwiftUI

struct FactCategories: View {
    var categories: [String]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack {
                ForEach(categories, id: \.self) { category in
                    Text(category.uppercased())
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color("Category"))
                        .cornerRadius(5)
                }
            }
        }
    }
}

#if DEBUG
struct FactCategories_Previews: PreviewProvider {
    static var previews: some View {
        FactCategories(categories: ["CAT4", "CAT2", "CAT4", "CAT3", "CAT%"])
    }
}
#endif
