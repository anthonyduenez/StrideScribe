//
//  RunDetailView.swift
//  StrideScribe
//
//  Created by Anthony Duenez on 3/1/25.
//

import SwiftUI
import MapKit

struct RunDetailView: View {
    var run: RunData
    
    @State private var region = MKCoordinateRegion()
    
    var body: some View {
        VStack {
            Map {
                if !run.locations.isEmpty {
                    MapPolyline(coordinates: run.locations.map { $0.coordinate })
                        .foregroundStyle(.clear)
                        .stroke(.green, style: StrokeStyle(lineWidth: 9, lineCap: .round, lineJoin: .round))
                }
            }
            .frame(maxHeight: .infinity)
            VStack {
                HStack(spacing: 20) { // Adjust spacing between elements
                    VStack {
                        Text("\((run.distance / 1609), specifier: "%.2f")")
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
                        Text("\(Int(run.pace).convertDurationToString())")
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
                    .background(Color.white) // Box background
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
                    Text("\(run.elapsedTime.convertDurationToString())")
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
                .frame(maxHeight: 300, alignment: .top)
            }
            .padding(.top,20)
        }
        .ignoresSafeArea(.all)
        .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
    }
}
