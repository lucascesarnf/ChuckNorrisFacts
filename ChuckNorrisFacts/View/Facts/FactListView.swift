//
//  FactListView.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 21/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import SwiftUI
import Combine

struct FactListView: View {
    @ObservedObject var model = FactListViewModel()
    
    var body: some View {
        List(model.facts) { model in
            FactRow(model: model)
        }
    }
}

#if DEBUG
struct FactListView_Previews: PreviewProvider {
    static var previews: some View {
        FactListView()
    }
}
#endif
