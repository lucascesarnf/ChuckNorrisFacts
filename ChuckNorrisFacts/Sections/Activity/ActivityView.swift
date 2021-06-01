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
        size()
        return activityView
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController,
                                context: UIViewControllerRepresentableContext<ActivityView>) {
    }
    
    func size() {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        print("Screen width = \(screenWidth), screen height = \(screenHeight)")
    }
}
