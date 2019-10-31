//
//  FactRow.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 24/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import SwiftUI

struct FactRow: View {
    @State private var showShare = false
    var model: FactViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Spacer(minLength: 10)
            Text(model.factDescription())
                .fontWeight(.bold)
                .font(.system(size: model.fontSize()))
            HStack {
                FactCategories(categories: model.categories())
                Spacer()
                shareButton
            }
        }
    }

    var shareButton: some View {
        Button(action: {
            self.showShare = true
            self.model.shareFact()
        }, label: {
            Image("share")
                .resizable()
                .frame(width: 30, height: 30, alignment: .center)
        }).sheet(isPresented: $showShare, onDismiss: {
            self.showShare = false
        }, content: {
            self.model.activityVC
        })
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
                            categories: ["First", "Second"])))
    }
}
#endif
