//
//  FactRow.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 24/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import SwiftUI

struct FactRow: View {
    var model: FactViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(model.factDescription)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .padding(5)
            HStack {
                ForEach(model.categories, id: \.self) { category in
                   Group {
                    Text(category.uppercased())
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(5)
                    }
                   .background(Color.blue)
                }
            }
            .padding()
        }
    }
}

#if DEBUG
struct FactRow_Previews: PreviewProvider {
    static var previews: some View {
        FactRow(model: FactViewModel(fact:
            ChuckNorrisFact(iconURL: "https://assets.chucknorris.host/img/avatar/chuck-norris.png",
        id: nil,
        url: nil,
        value: "CHuck Norris' Mother has a tatoo of Chuck Norris on her right bicep.",
        categories:["First","Second"])))
    }
}
#endif
