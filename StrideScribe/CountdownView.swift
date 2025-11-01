//
//  CountdownView.swift
//  StrideScribe
//
//  Created by Anthony Duenez on 2/28/25.
//

import SwiftUI

struct CountdownView: View {
    @EnvironmentObject var runTrack: runTracker
    @State var timer: Timer?
    @State var countdown = 3
    
    var body: some View {
        Text("\(countdown)")
            .font(.system(size: 256))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.green)
            .onAppear {
                setupCountdown()
            }
            
    }
    
    func setupCountdown(){
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            if countdown <= 1 {
                timer?.invalidate()
                timer = nil
                runTrack.presentCountdown = false
                runTrack.startRun()
            } else {
                countdown -= 1
            }
        }
    }
}

#Preview {
    CountdownView()
}
