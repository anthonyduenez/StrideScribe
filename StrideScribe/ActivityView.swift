//
//  ActivityView.swift
//  StrideScribe
//
//  Created by Anthony Duenez on 3/1/25.
//

import SwiftUI
import MapKit

struct ActivityView: View {
    @EnvironmentObject var runTrack: runTracker

    var body: some View {
        NavigationStack {
            List {
                if runTrack.pastRuns.isEmpty {
                    Text("No runs yet!")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
                else {
                    ForEach(runTrack.pastRuns) { run in
                        NavigationLink(destination: RunDetailView(run: run)) {
                            VStack(alignment: .leading) {
                                Text(run.date, style: .date)
                                    .font(.headline)
                                Text("Distance: \(run.distance / 1609, specifier: "%.2f") miles")
                                    .font(.subheadline)
                                Text("Duration: \(run.elapsedTime.convertDurationToString())")
                                    .font(.subheadline)
                                Text("Pace: \(Int(run.pace).convertDurationToString()) min/mile")
                                    .font(.subheadline)
                            }
                        }
                    }
                    .onDelete(perform: deleteRun)
                }
            }
            .navigationTitle("Activity History")
            .toolbarBackgroundVisibility(.visible, for: .tabBar)
        }
    }
    func deleteRun(at offsets: IndexSet){
        runTrack.deleteRun(at: offsets)
    }
}
