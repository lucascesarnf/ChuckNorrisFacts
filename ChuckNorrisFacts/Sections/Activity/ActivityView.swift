//
//  ActivityView.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 26/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation
import SwiftUI

struct ActivityView: UIViewControllerRepresentable {

    let activityItems: [Any]
    let applicationActivities: [UIActivity]?

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        let activityView = UIActivityViewController(activityItems: activityItems,
                                        applicationActivities: applicationActivities)
        return activityView
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController,
                                context: UIViewControllerRepresentableContext<ActivityView>) {
    }
}
