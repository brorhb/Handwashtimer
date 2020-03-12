//
//  DatePicker.swift
//  Handwashtimer WatchKit Extension
//
//  Created by Bror Brurberg on 10/03/2020.
//  Copyright © 2020 Bror Brurberg. All rights reserved.
//

import SwiftUI

enum Action {
    case add
    case remove
}

struct DatePicker: View {
    var value: Date
    var onChange: (Date) -> Void
    private var hour: Int {
        return Calendar.current.dateComponents([.hour], from: self.value).hour ?? 0
    }
    
    func change(date: Date, action: Action) {
        var dateComponents = Calendar.current.dateComponents([.hour, .second, .minute], from: date)
        guard let hour = dateComponents.hour else { return }
        var newHour: Int
        switch action {
        case .add:
             newHour = hour + 1
        case .remove:
            newHour = hour - 1
        }
        dateComponents.hour = newHour
        dateComponents.second = 0
        dateComponents.minute = 0
        guard let newDate = Calendar.current.date(from: dateComponents) else { return }
        onChange(newDate)
    }
    
    var body: some View {
        HStack {
            Button(action: {
                self.change(date: self.value, action: .remove)
            }) {
                Image(systemName: "minus.circle.fill")
                .foregroundColor(.blue)
            }.buttonStyle(PlainButtonStyle())
            Spacer()
            Text("\(hour):00")
            Spacer()
            Button(action: {
                self.change(date: self.value, action: .add)
            }) {
                Image(systemName: "plus.circle.fill")
                .foregroundColor(.blue)
            }.buttonStyle(PlainButtonStyle())
        }
        .padding()
    }
}

struct DatePicker_Previews: PreviewProvider {
    static var previews: some View {
        DatePicker(value: Date()) {
            print($0)
        }
    }
}
