//
//  ContentView.swift
//  Handwashtimer WatchKit Extension
//
//  Created by Bror Brurberg on 10/03/2020.
//  Copyright © 2020 Bror Brurberg. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var washObservable = washObservableSingleton
    @State var timeLeft = 20
    @State var running = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geo in
            List {
                HStack {
                    Spacer()
                    ZStack {
                        Circle()
                            .fill(self.running ? Color.red : Color.blue)
                        Text(self.running ? "Washing" : "Wash")
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                    .frame(width: geo.size.width * 0.6, height: geo.size.width * 0.6)
                    .onTapGesture {
                        withAnimation {
                            self.running = true
                        }
                        WKExtension().isAutorotating = true
                        self.washObservable.createWashNotification(time: self.timeLeft)
                    }
                    .onReceive(self.timer) { time in
                        if self.timeLeft > 0 && self.running {
                            self.timeLeft -= 1
                        }
                        if self.timeLeft == 0 {
                            WKExtension().isAutorotating = false
                            WKInterfaceDevice().play(.success)
                            withAnimation {
                                self.running = false
                            }
                            self.timeLeft = 20
                        }
                    }
                    Spacer()
                }.listRowBackground(Color.black)
                Spacer(minLength: 25).listRowBackground(Color.black)
                NavigationLink(destination: Settings(
                    washObservable: self.washObservable
                )) {
                    Text("Settings")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
