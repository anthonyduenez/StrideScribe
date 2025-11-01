//
//  TabView.swift
//  StrideScribe
//
//  Created by Anthony Duenez on 3/1/25.
//

import SwiftUI

struct StrideTabView: View {
    @EnvironmentObject var runTrack: runTracker
    @State private var selectedTab = 0

    var body: some View {
        VStack {
            TabView(selection: $selectedTab) {
                ContentView()
                    .tabItem {
                        Image(systemName: "figure.run")
                    }
                    .tag(0)

                ActivityView()
                    .tabItem {
                        Image(systemName: "book.fill")
                    }
                    .tag(1)
            }
            .accentColor(.black)
        }
        .ignoresSafeArea(.all)
    }
}
