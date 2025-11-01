//
//  runView.swift
//  StrideScribe
//
//  Created by Anthony Duenez on 2/28/25.
//

import SwiftUI
import AudioToolbox

struct runView: View {
    @EnvironmentObject var runTrack : runTracker
    @State var isPaused : Bool = false
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("\((runTrack.distance / 1609), specifier: "%.2f") mil")
                        .font(.title)
                        .bold()
                        .foregroundStyle(.white)
                    Text("Distance")
                        .font(.system(size:24))
                        .bold()
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                VStack {
                    Text("\(Int(runTrack.pace).convertDurationToString())")
                        .font(.title)
                        .bold()
                        .foregroundStyle(.white)
                    
                    HStack {
                        Text("Pace")
                            .font(.system(size: 24))
                            .bold()
                            .foregroundStyle(.white)
                        Text("min/mil")
                            .font(.system(size: 12))
                            .bold()
                            .foregroundStyle(.white)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.top, 32)
            
            Spacer()
            
            VStack {
                Text("\(runTrack.elapsedTime.convertDurationToString())")
                    .font(.system(size: 64))
                    .bold()
                    .foregroundStyle(.white)
                Text("Time")
                    .font(.system(size: 24))
                    .bold()
                    .foregroundStyle(.white)
            }
            
            Spacer()
        
            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "stop.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .padding(36)
                        .background(Color.red)
                        .clipShape(Circle())
                }
                .frame(maxWidth: .infinity)
                .simultaneousGesture(LongPressGesture().onEnded({ _ in
                    withAnimation {
                        runTrack.stopRun()
                        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)){}
                    }
                }))
                
                Button {
                    
                } label: {
                    Image(systemName: runTrack.isRunning ? "pause.fill" : "play.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .padding(36)
                        .background(!isPaused ? .yellow : .green)
                        .clipShape(Circle())
                }
                .frame(maxWidth: .infinity)
                .simultaneousGesture(LongPressGesture().onEnded({ _ in
                    withAnimation{
                        if runTrack.isRunning {
                            runTrack.pauseRun()
                            isPaused = true
                        } else {
                            runTrack.resumeRun()
                            isPaused = false
                        }
                        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)){}
                    }
                }))
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background(!isPaused ? .green : .yellow)
    }
}
