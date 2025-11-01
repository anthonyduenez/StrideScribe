//
//  StrideScribeApp.swift
//  StrideScribe
//
//  Created by Anthony Duenez on 2/27/25.
//

import SwiftUI

@main
struct StrideScribeApp: App {
    @StateObject var runTrack = runTracker()
    var body: some Scene {
        WindowGroup {
            StrideTabView()
                .environmentObject(runTrack)
        }
    }
}
