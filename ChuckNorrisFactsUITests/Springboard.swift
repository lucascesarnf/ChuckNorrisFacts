//
//  Springboard.swift
//  ChuckNorrisFactsUITests
//
//  Created by Lucas César  Nogueira Fonseca on 30/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import XCTest

class Springboard {

    static let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")

    /**
     Terminate and delete the app via springboard
     */
    class func deleteMyApp() {
        XCUIApplication().terminate()
        XCUIDevice.shared.press(.home)
        XCUIDevice.shared.press(.home)
        let icon = springboard.icons["ChuckNorrisFacts"]
        if !icon.exists { return }
        let iconFrame = icon.frame
        let springboardFrame = springboard.frame
        //springboard.swipeLeft()
        // springboard.activate() 
        //Thread.sleep(forTimeInterval: 1.0)

        icon.press(forDuration: 1.3)
        springboard.buttons["Rearrange Apps"].tap()
        springboard.coordinate(withNormalizedOffset:
            CGVector(dx: ((iconFrame.minX + 3) / springboardFrame.maxX),
                     dy: ((iconFrame.minY + 3) / springboardFrame.maxY))).tap()
        //icon.buttons["DeleteButton"].tap()
        springboard.alerts.buttons["Delete"].tap()

        //XCUIDevice.shared.press(.home)
        //XCUIDevice.shared.press(.home)
    }
}
