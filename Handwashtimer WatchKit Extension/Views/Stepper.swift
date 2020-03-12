//
//  Stepper.swift
//  Handwashtimer WatchKit Extension
//
//  Created by Bror Brurberg on 10/03/2020.
//  Copyright © 2020 Bror Brurberg. All rights reserved.
//

import SwiftUI

struct Stepper: View {
    var value: Int
    var onChange: (Int) -> Void
    var body: some View {
        HStack {
            Button(action: {
                if self.value > 1 {
                    self.onChange(self.value - 1)
                }
            }) {
                HStack {
                    Image(systemName: "minus.circle.fill")
                    .foregroundColor(.blue)
                    Spacer()
                }
            }.buttonStyle(PlainButtonStyle())
            Text("\(value)h")
            Button(action: {
                if self.value < 24 {
                    self.onChange(self.value + 1)
                }
            }) {
                HStack {
                    Spacer()
                    Image(systemName: "plus.circle.fill")
                    .foregroundColor(.blue)
                }
            }.buttonStyle(PlainButtonStyle())
        }
        .padding()
    }
}

struct Stepper_Previews: PreviewProvider {
    static var previews: some View {
        Stepper(
            value: 1
        ) {
            print($0)
        }
    }
}
