//
//  AppDelegate.swift
//  StrideScribe
//
//  Created by Anthony Duenez on 3/2/25.
//

import UIKit
import BackgroundTasks

class AppDelegate: UIResponder, UIApplicationDelegate {

    func applicationDidEnterBackground(_ application: UIApplication) {
        let taskID = application.beginBackgroundTask(expirationHandler: nil)
        DispatchQueue.global().async {
            while true {
                if application.backgroundTimeRemaining < 5 {
                    break
                }
                sleep(1)
            }
            application.endBackgroundTask(taskID)
        }
    }
}
