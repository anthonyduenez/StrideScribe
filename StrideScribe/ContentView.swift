//
//  ContentView.swift
//  StrideScribe
//
//  Created by Anthony Duenez on 2/27/25.
//

import SwiftUI
import MapKit

struct AreaMap: View{
    @Binding var region: MKCoordinateRegion
    
    var body: some View{
        let binding = Binding(
            get: { self.region },
            set: { newValue in DispatchQueue.main.async { self.region = MKCoordinateRegion(center : newValue.center, span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)) } }
        )
        return Map(coordinateRegion: binding, showsUserLocation: true).ignoresSafeArea()
    }
}

struct ContentView: View {
    @EnvironmentObject var runTrack: runTracker
    
    var body: some View {
        NavigationStack {
            VStack{
                ZStack(alignment: .bottom) {
                    AreaMap(region: $runTrack.region)
                    Button{
                        runTrack.presentCountdown.toggle()
                    } label: {
                        Text("Start")
                            .bold(true)
                            .font(.title)
                            .foregroundStyle(.white)
                            .padding(36)
                            .background(.green)
                            .clipShape(Circle())
                    }
                    .padding(.bottom, 48)
                }
                
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .fullScreenCover(isPresented: $runTrack.presentCountdown, content: {
                    CountdownView()
                    .environmentObject(runTrack)
                }
            )
            .fullScreenCover(isPresented: $runTrack.presentRunView, content: {
                runView()
                    .environmentObject(runTrack)
            })
            .fullScreenCover(isPresented: $runTrack.presentStopView, content: {
                StopView()
                    .environmentObject(runTrack)
            })
        }
        .toolbarBackgroundVisibility(.visible, for: .tabBar)
    }
}

#Preview {
    ContentView()
}
