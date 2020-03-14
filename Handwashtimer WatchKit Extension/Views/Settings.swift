//
//  Settings.swift
//  Handwashtimer WatchKit Extension
//
//  Created by Bror Brurberg on 10/03/2020.
//  Copyright © 2020 Bror Brurberg. All rights reserved.
//

import SwiftUI

struct ListRow<Content: View>: View {
    let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        VStack {
            self.content()
        }
        .padding()
        .background(Color(UIColor(red:0.13, green:0.13, blue:0.14, alpha:1.0)))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct Settings: View {
    @State private var remindEvery: Int
    @State private var startingAt: Date
    @State private var endingAt: Date
    @ObservedObject var washObservable: WashObservable
    @State var saving = false
    
    init(washObservable: WashObservable) {
        _startingAt = State(initialValue: washObservable.startTime)
        _endingAt = State(initialValue: washObservable.endTime)
        _remindEvery = State(initialValue: washObservable.interval)
        self.washObservable = washObservable
    }
    
    private func hideSaved() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                self.saving = false
            }
        }
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                if (self.washObservable.permissions == false) {
                    ListRow {
                        HStack {
                            Text("Permissions")
                                .font(Font.system(.headline, design: .rounded))
                            Spacer()
                        }
                        HStack {
                            Text("This app needs permissions for sending notifications.")
                            Spacer()
                        }
                    }
                        .padding(.bottom)
                }
                ListRow {
                    HStack {
                        Text("Remind me every")
                            .font(Font.system(.headline, design: .rounded))
                        Spacer()
                    }
                    Stepper(value: self.remindEvery) {
                        self.remindEvery = $0
                    }
                }
                ListRow{
                    HStack {
                        Text("Starting at")
                            .font(Font.system(.headline, design: .rounded))
                        Spacer()
                    }
                    DatePicker(value: self.startingAt) {
                        if $0 < self.endingAt {
                            self.startingAt = $0
                        }
                    }
                }
                ListRow{
                    HStack {
                        Text("Ending at")
                            .font(Font.system(.headline, design: .rounded))
                        Spacer()
                    }
                    DatePicker(value: self.endingAt) {
                        if $0 > self.startingAt {
                            self.endingAt = $0
                        }
                    }
                }
                Button("Save") {
                    withAnimation {
                        self.saving = true
                    }
                    self.washObservable.setInterval(start: self.startingAt, end: self.endingAt, interval: self.remindEvery)
                }
            }
            
            if saving {
                GeometryReader {geo in
                    ZStack {
                        Color.black
                            .frame(width: geo.size.width, height: geo.size.height)
                            .opacity(0.7)
                            .blur(radius: 10)
                        VStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Saved")
                                .font(.headline)
                        }
                    }
                }
                    .transition(.scale)
                    .onAppear{
                        self.hideSaved()
                    }
            }
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings(washObservable: WashObservable())
    }
}
