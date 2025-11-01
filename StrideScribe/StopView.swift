//
//  StopView.swift
//  StrideScribe
//
//  Created by Anthony Duenez on 2/28/25.
//

import SwiftUI
import MapKit

struct StopView: View {
    @EnvironmentObject var runTrack : runTracker
    
    var body: some View {
        VStack {
            ZStack {
                Map {
                    if !runTrack.locations.isEmpty {
                        MapPolyline(coordinates: runTrack.locations.map { $0.coordinate })
                            .foregroundStyle(.clear)
                            .stroke(.green, style: StrokeStyle(lineWidth: 9, lineCap: .round, lineJoin: .round))
                    }
                    
                }
                Button {
                    withAnimation {
                        runTrack.presentStopView = false
                    }
                } label: {
                    Image(systemName: "arrowshape.left.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(.black)
                        .background(.white)
                        .padding(10)
                }
                .padding(5)
                .overlay(Circle().stroke(.gray, lineWidth: 4))
                .background(.white)
                .foregroundStyle(.black)
                .clipShape(Circle())
                .position(x: 50, y: 40)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
            VStack {
                HStack(spacing: 20) { // Adjust spacing between elements
                    VStack {
                        Text("\((runTrack.distance / 1609), specifier: "%.2f")")
                            .font(.title)
                            .bold()
                            .foregroundStyle(.black)
                        VStack(spacing: 2) {
                            Text("Distance")
                                .font(.system(size: 22))
                                .bold()
                                .foregroundStyle(.gray)
                            Text("(miles)")
                                .font(.system(size: 20))
                                .foregroundStyle(.gray)
                        }
                    }
                    .frame(maxWidth: 160, minHeight: 120)
                    .padding()
                    .background(Color.white) // Box background
                    .cornerRadius(24)
                    .overlay(RoundedRectangle(cornerRadius: 24).stroke(.gray, lineWidth: 4))
                    .shadow(color: .gray.opacity(0.2), radius: 6, x: 0, y: 4) // Adds shadow
                    
                    VStack {
                        Text("\(Int(runTrack.pace).convertDurationToString())")
                            .font(.title)
                            .bold()
                            .foregroundStyle(.black)
                        VStack(spacing: 2) {
                            Text("Pace")
                                .font(.system(size: 22))
                                .bold()
                                .foregroundStyle(.gray)
                            Text("(min/mil)")
                                .font(.system(size: 20))
                                .foregroundStyle(.gray)
                        }
                    }
                    .frame(maxWidth: 160, minHeight: 120)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(24)
                    .overlay(RoundedRectangle(cornerRadius: 24).stroke(.gray, lineWidth: 4))
                    .shadow(color: .gray.opacity(0.2), radius: 6, x: 0, y: 4) // Adds shadow
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(24)
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 6)
                .padding(.horizontal, 20)
                
                VStack (spacing: 4){
                    Text("\(runTrack.elapsedTime.convertDurationToString())")
                        .font(.system(size: 64))
                        .bold()
                        .foregroundStyle(.black)
                    Text("Time")
                        .font(.system(size: 24))
                        .bold()
                        .foregroundStyle(.gray)
                        .padding(.top,-15)
                        .padding(.bottom,10)
                }
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.systemGray6)) // Subtle background to contrast with boxes
                .cornerRadius(24)
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 6) // Overall shadow effect
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .frame(maxHeight: .infinity)
        .background(.white)
    }
}
